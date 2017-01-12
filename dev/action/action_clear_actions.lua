local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
M.name = "Clear Actions";
-------------------------------------------------
function M:Call()
  BotInfo:SetAction(self, {});
end

function M:Run()
  local bot = GetBot();
  bot:Action_ClearActions();
end

function M:Finish()
  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
