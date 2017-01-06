local M = {}
local BotActions      = require(GetScriptDirectory().."/dev/bot_actions");
-------------------------------------------------
M.StateMachine = {}
M.StateMachine.State = "STATE_LEARN_ABILITY";
-------------------------------------------------
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  local ability = BotInfo.abilityBuild[1];
  BotActions.ActionLevelAbility:Call(ability, BotInfo.abilityBuild);
end
-------------------------------------------------
return M;
