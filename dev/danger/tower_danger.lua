local TowerDanger = {};
------------------------------------------
local VectorHelper = require(GetScriptDirectory().."/dev/helper/vector_helper");
local Game         = require(GetScriptDirectory().."/dev/game");
-----------------------------------------
local DANGER_TOWER      = 150;
local DANGER_TOWER_FAR  = 50;
------------------------------------------
function TowerDanger:Power(distance)
  if (distance < 800) then -- below attack range (actual tower range is 700 + ~100 for bounding radius)
    return DANGER_TOWER / distance;
  elseif (distance < 14000) then -- 14000 is random range from the tower which is `kinda safe`
    return DANGER_TOWER_FAR / distance;
  else
    return 0;
  end
end

function TowerDanger:PowerDelta(team, unit, distance)
  self.Tower = nil;
  local tower_max_delta = 0;
  local all_towers = Game:GetTowersForTeam(team);       -- we look through all team's current towers and select the most `powerful`
  for i = 1, #all_towers do
    local tower = all_towers[i];
    local current_distance = GetUnitToLocationDistance(unit, tower:GetLocation());
    local delta = self:Power(Max(1, current_distance - distance)) - self:Power(current_distance);
    if (tower_max_delta < delta) then
      tower_max_delta = delta;
      self.Tower = tower;
    end
  end
  return tower_max_delta;
end

function TowerDanger:Location(team)
  if (self.Tower) then    -- if any of team towers still present
    return self.Tower:GetLocation();
  end
  return Vector(0,0);
end
------------------------------------------
return TowerDanger;
