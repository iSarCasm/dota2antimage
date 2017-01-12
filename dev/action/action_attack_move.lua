local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
M.name = "Attack Move";
-------------------------------------------------
function M:Call(point)
  local args = {point};
  self.args = args;
  BotInfo:SetAction(self, args);
end

function M:SetArgs()
  self.point = self.args[1];
end

function M:Run()
  self:SetArgs();
  local bot = GetBot();
  if (GetBot():GetCurrentActionType() ~= BOT_ACTION_TYPE_ATTACK and GetBot():GetCurrentActionType() ~= BOT_ACTION_TYPE_ATTACKMOVE) then
    bot:Action_AttackMove(self.point);
  end
end

function M:Finish()
  self.point = nil;
  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
