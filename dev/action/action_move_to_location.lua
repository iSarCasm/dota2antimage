local MoveToLocation = {}
local VectorHelper = require(GetScriptDirectory().."/dev/helper/vector_helper")
MoveToLocation.name = "Move to Location";
-------------------------------------------------
function MoveToLocation:Call(point)
  local bot = GetBot();
  bot.flex_bot.moving_location = point;
  bot:Action_MoveToLocation(point);
end
-------------------------------------------------
return MoveToLocation;
