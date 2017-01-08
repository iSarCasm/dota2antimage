local M = {}
local BotActions = require(GetScriptDirectory().."/dev/bot_actions");
-------------------------------------------------
M.StateMachine = {}
-------------------------------------------------
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local bot = GetBot();
  return (((bot:GetStashValue() + bot:GetCourierValue()) > 0 and IsCourierAvailable()) and 100000 or -999);
end
-------------------------------------------------
function M:Reset()
  self.StateMachine.State = "STATE_DELIVER_ITEMS";
end
M:Reset();
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  BotActions.ActionCourierDeliver:Call();
end
-------------------------------------------------
return M;
