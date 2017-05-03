local FountainDanger = {};
------------------------------------------
local VectorHelper = require(GetScriptDirectory().."/dev/helper/vector_helper")
------------------------------------------
local DANGER_FOUNTAIN       = 500;
local DANGER_FOUNTAIN_FAR   = 50;
local DANGER_FOUNTAIN_BASE  = 5;
------------------------------------------
function FountainDanger:Power(distance)
  if (distance < 1000) then
    return DANGER_FOUNTAIN / (distance*distance);
  elseif (distance < 3000) then
    return DANGER_FOUNTAIN_FAR / (distance*distance);
  else
    return DANGER_FOUNTAIN_BASE / (distance*distance); -- fountain is basic safety
  end
end

function FountainDanger:ResultVector(team, unit, distance)
  return self:PowerDelta(team, unit, distance) * self:Location(team);
end

function FountainDanger:PowerDelta(team, unit, distance)
  local current_distance = GetUnitToLocationDistance(unit, self:Location(team));
  local delta = ((team == GetTeam()) and -distance or distance);
  return math.abs(self:Power(Max(1, current_distance + delta)) - self:Power(current_distance));
end

function FountainDanger:Location(team)
  return FOUNTAIN[team];
end
------------------------------------------
return FountainDanger;
