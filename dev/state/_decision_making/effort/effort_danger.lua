local EffortDanger = {}
----------------------------------------------------
local Danger       = require(GetScriptDirectory().."/dev/danger/danger");
local VectorHelper = require(GetScriptDirectory().."/dev/helper/vector_helper")
EffortDanger.Multiplier = 3.5;
----------------------------------------------------
function EffortDanger:OfLocation(Location)
  return Danger:Location(Location) * self.Multiplier;
end

function EffortDanger:Delta(Location)
  return Max(self:OfLocation(Location) - self:OfLocation(GetBot():GetLocation()), 0) * self.Multiplier;
end
----------------------------------------------------
return EffortDanger;
