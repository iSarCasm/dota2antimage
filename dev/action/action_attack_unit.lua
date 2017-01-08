local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
M.name = "Attack Unit";
-------------------------------------------------
function M:Call(target, bOnce)
  self.target = target;
  self.bOnce = bOnce;
  BotInfo:SetAction(self);
end

function M:Run()
  local bot = GetBot();
  bot:Action_AttackUnit(self.target, self.bOnce);
end

function M:Finish()
  self.target = nil;
  self.bOnce = nil;
  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
