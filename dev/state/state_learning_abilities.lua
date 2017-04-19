local M = {}
local BotActions = require(GetScriptDirectory().."/dev/bot_actions");
-------------------------------------------------
M.StateMachine = {}
-------------------------------------------------
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local bot = GetBot();
  return ((bot:GetAbilityPoints() > 0 and BotInfo.abilityBuild[1]) and 100 or -999);
end
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  local bot = GetBot();
  local ability_name = BotInfo.abilityBuild[1];
  local ability = bot:GetAbilityByName(ability_name);
  if(ability and ability:CanAbilityBeUpgraded()) then
    local prev_level = ability:GetLevel();
    bot:ActionImmediate_LevelAbility(ability_name);
    if (ability:GetLevel() ~= prev_level) then
      print("Ability "..ability_name.." leveled from "..prev_level.." to "..ability:GetLevel());
      table.remove(BotInfo.abilityBuild, 1);
    end
  end
end
-------------------------------------------------
return M;
