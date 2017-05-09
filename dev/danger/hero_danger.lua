local HeroDanger = {};
------------------------------------------
local VectorHelper = require(GetScriptDirectory().."/dev/helper/vector_helper");
local Game         = require(GetScriptDirectory().."/dev/game");
------------------------------------------
function HeroDanger:Power(distance)
  if (distance < 800) then 
    return 90 / (distance*distance);
  elseif (distance < 1000) then 
    return 50 / (distance*distance);
  else
    return 0;
  end
end

function HeroDanger:OfLocation( vLocation, team )
  local bEnemies = (team == GetEnemyTeam());
  local all_heroes = GetBot().flex_bot.botInfo:GetNearbyHeroes(1599, bEnemies, BOT_MODE_NONE);
  if (#all_heroes == 0 or ((not bEnemies) and #all_heroes == 1)) then
    return 0;
  end
  local total_danger = 0;
  for i = 1, #all_heroes do
    local hero = all_heroes[i];
    total_danger = total_danger + self:Power(GetUnitToLocationDistance(hero, vLocation));
  end
  return total_danger;
end 

function HeroDanger:PowerDelta(team, unit, distance)
  -- print("hero danger");
  self.HeroLocation = Vector(0, 0);

  local total_delta = 0;
  local bEnemies = (team == GetEnemyTeam());
  local all_heroes = unit.flex_bot.botInfo:GetNearbyHeroes(1599, bEnemies, BOT_MODE_NONE);
  -- print("heroes "..#all_heroes);
  if (#all_heroes == 0 or ((not bEnemies) and #all_heroes == 1)) then
    return 0;
  end

  for i = 1, #all_heroes do
    local hero = all_heroes[i];
    if (hero ~= GetBot()) then
      local current_distance = GetUnitToLocationDistance(unit, hero:GetLocation());
      local delta_distance = ((team == GetTeam()) and -distance or distance);
      local delta = math.abs(self:Power(Max(1, current_distance + delta_distance)) - self:Power(current_distance)); 
      total_delta = total_delta + delta;
      -- print("delta "..delta);
      -- print(hero:GetLocation());
      self.HeroLocation = self.HeroLocation + hero:GetLocation() * delta;
    end
  end
  self.HeroLocation = self.HeroLocation / total_delta;
  -- print("total delta "..total_delta);
  return total_delta;
end

function HeroDanger:Location(team)
  -- print("hero location");
  -- print(self.HeroLocation);
  return self.HeroLocation;
end
------------------------------------------
return HeroDanger;
