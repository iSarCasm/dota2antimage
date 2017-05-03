local TowerDanger = {};
------------------------------------------
local VectorHelper = require(GetScriptDirectory().."/dev/helper/vector_helper");
local Game         = require(GetScriptDirectory().."/dev/game");
-----------------------------------------
local DANGER_TOWER      = 150;
local DANGER_TOWER_FAR  = 100;
------------------------------------------
function TowerDanger:Power(distance)
  if (distance < 800) then -- below attack range (actual tower range is 700 + ~100 for bounding radius)
    return DANGER_TOWER / (distance*distance);
  elseif (distance < 5000) then -- 14000 is random range from the tower which is `kinda safe`
    return DANGER_TOWER_FAR / (distance*distance);
  else
    return 0;
  end
end

function TowerDanger:PowerDelta(team, unit, distance)
  self.TowerVector = Vector(0, 0);

  local total_delta = 0;
  local all_towers = self:Towers(team, unit);

  if (#all_towers == 0) then
    return 0;
  end

  for i = 1, #all_towers do
    local tower = all_towers[i];
    local current_distance = GetUnitToLocationDistance(unit, tower:GetLocation());
    local delta_distance = ((team == GetTeam()) and -distance or distance);
    local delta = math.abs(self:Power(Max(1, current_distance + delta_distance)) - self:Power(current_distance));
    total_delta = total_delta + delta;
    self.TowerVector = self.TowerVector + tower:GetLocation() * delta;
  end
  self.TowerVector = self.TowerVector / total_delta;
  return total_delta;
end

function TowerDanger:Location(team)
  return self.TowerVector;
end

function TowerDanger:Towers(team, unit)
 if (team == GetTeam()) then
  return Game:GetTowersForTeam(team);
 else
  return unit:GetNearbyTowers(1500, true);
 end
end
------------------------------------------
return TowerDanger;
