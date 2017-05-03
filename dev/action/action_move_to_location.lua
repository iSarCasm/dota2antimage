local MoveToLocation = {}
local VectorHelper = require(GetScriptDirectory().."/dev/helper/vector_helper")
MoveToLocation.name = "Move to Location";
-------------------------------------------------
function MoveToLocation:Call(point)
  local bot = GetBot();
  bot.flex_bot.moving_location = point;
  DebugDrawCircle(point, 25, 255, 255 ,255);
  DebugDrawLine(bot:GetLocation(), point, 255, 255 ,255);
  bot:Action_MoveToLocation(point);
end
-------------------------------------------------
return MoveToLocation;
