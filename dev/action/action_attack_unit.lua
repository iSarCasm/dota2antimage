local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
M.name = "Attack Unit";
-------------------------------------------------
function M:Call(target, bOnce)
  local args = {target, bOnce};
  self.args = args;
  BotInfo:SetAction(self, {target, bOnce});
end

function M:SetArgs()
  self.target = self.args[1];
  self.bOnce = self.args[2];
end

function M:Run()
  self:SetArgs();
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
