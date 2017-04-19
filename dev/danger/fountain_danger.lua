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
    return DANGER_FOUNTAIN / distance;
  elseif (distance < 3000) then
    return DANGER_FOUNTAIN_FAR / distance;
  else
    return DANGER_FOUNTAIN_BASE / distance; -- fountain is basic safety
  end
end

function FountainDanger:ResultVector(team, unit, distance)
  return self:PowerDelta(team, unit, distance) * self:Location(team);
end

function FountainDanger:PowerDelta(team, unit, distance)
  local current_distance = GetUnitToLocationDistance(unit, self:Location(team));
  return self:Power(Max(1, current_distance - distance)) - self:Power(current_distance);
end

function FountainDanger:Location(team)
  return FOUNTAIN[team];
end
------------------------------------------
return FountainDanger;
