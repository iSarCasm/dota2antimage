local EffortDanger = {}
----------------------------------------------------
local Danger       = require(GetScriptDirectory().."/dev/danger/danger");
local VectorHelper = require(GetScriptDirectory().."/dev/helper/vector_helper")
----------------------------------------------------
function EffortDanger:OfLocation(Location)
  return Danger:Location(Location);
end

function EffortDanger:Delta(Location)
  return Max(self:OfLocation(Location) - self:OfLocation(GetBot():GetLocation()), 0);
end
----------------------------------------------------
return EffortDanger;
