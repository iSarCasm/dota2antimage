local EffortDanger = {}
----------------------------------------------------
local VectorHelper = require(GetScriptDirectory().."/dev/helper/vector_helper")
----------------------------------------------------
function EffortDanger:OfLocation(Location)
  local bot = GetBot();
  local dist = VectorHelper:Length(FOUNTAIN[GetTeam()] - Location);
  return dist / 1000;
end

function EffortDanger:Delta(Location)
  return Max(self:OfLocation(Location) - self:OfLocation(GetBot():GetLocation()), 0);
end
----------------------------------------------------
return EffortDanger;
