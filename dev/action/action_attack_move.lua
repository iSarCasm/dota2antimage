local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
M.name = "Attack Move";
-------------------------------------------------
function M:Call(point, bOnce)
  self.point = point;
  BotInfo:SetAction(self);
end

function M:Run()
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
