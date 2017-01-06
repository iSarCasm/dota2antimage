local M = {}
local BotActions      = require(GetScriptDirectory().."/dev/bot_actions");
-------------------------------------------------
M.StateMachine = {}
-------------------------------------------------
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local bot = GetBot();
  return ((bot:GetAbilityPoints() > 0) and 100 or 0);
end
-------------------------------------------------
function M:Reset()
  self.StateMachine.State = "STATE_LEARN_ABILITY";
end
M:Reset();
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  local ability = BotInfo.abilityBuild[1];
  BotActions.ActionLevelAbility:Call(ability, BotInfo.abilityBuild);
end
-------------------------------------------------
return M;
