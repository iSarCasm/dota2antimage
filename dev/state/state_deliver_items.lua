local M = {}
local BotActions = require(GetScriptDirectory().."/dev/bot_actions");
-------------------------------------------------
M.StateMachine = {}
-------------------------------------------------
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local bot = GetBot();
  return ((self:HasItemsToDeliver(bot) and GetCourierState(GetCourier(0)) == COURIER_STATE_AT_BASE) and 100000 or -999);
end

function M:HasItemsToDeliver(bot)
  return (bot:GetStashValue() + bot:GetCourierValue()) > 0
end
-------------------------------------------------
function M:Reset()
  self.StateMachine.State = "STATE_DELIVER_ITEMS";
end
M:Reset();
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  GetBot():ActionImmediate_Courier(GetCourier(0), 6);
end
-------------------------------------------------
return M;
