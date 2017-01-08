local EffortDanger = {}
----------------------------------------------------
local VectorHelper = require(GetScriptDirectory().."/dev/helper/vector_helper")
----------------------------------------------------
function EffortDanger:OfLocation(Location)
  local bot = GetBot();
  local dist = VectorHelper:Length(FOUNTAIN[GetTeam()] - Location);
  return dist / 1000;
end
----------------------------------------------------
return EffortDanger;
