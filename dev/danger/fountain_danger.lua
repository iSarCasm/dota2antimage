local FountainDanger = {};
------------------------------------------
local VectorHelper = require(GetScriptDirectory().."/dev/helper/vector_helper")
------------------------------------------
function FountainDanger:Estimate(team, location)
  local bot = GetBot();
  local dist = VectorHelper:Length(FOUNTAIN[team] - location);
  return self:Power(dist);
end

function FountainDanger:Power(distance)
  if (distance < 1000) then
    return distance / 50;
  elseif (distance < 5000) then
    return distance / 200;
  else
    return distance / 1000;
  end
end

function FountainDanger:PowerDelta(team, unit, distance)
  local current_distance = GetUnitToLocationDistance(unit, self:Location(team));
  return self:Power(current_distance) - self:Power(current_distance - distance);
end

function FountainDanger:Location(team)
  return FOUNTAIN[team];
end
------------------------------------------
return FountainDanger;
