local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
M.name = "Move to Location";
-------------------------------------------------
function M:Call(location)
  self.location = location;
  BotInfo:SetAction(self);
end

function M:Run()
  local bot = GetBot();
  bot:Action_MoveToLocation(self.location);
end

function M:Finish()
  self.location = nil;
  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
