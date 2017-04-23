local RotateTowards = {}
local VectorHelper = require(GetScriptDirectory().."/dev/helper/vector_helper")
RotateTowards.name = "Rotate Towards";
-------------------------------------------------
function RotateTowards:Call(point)
  local bot = GetBot();
  local towards_vector = VectorHelper:Normalize(point - bot:GetLocation());
  bot:Action_MoveToLocation(bot:GetLocation() + towards_vector);
end
-------------------------------------------------
return RotateTowards;
