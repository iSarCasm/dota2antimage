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
  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
