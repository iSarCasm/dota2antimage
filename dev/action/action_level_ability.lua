local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
M.name = "Level Ability";
-------------------------------------------------
function M:Call(ability, table)
  self.ability = ability;
  self.table = table;
  BotInfo:SetAction(self);
end

function M:Run()
  local bot = GetBot();
  if (self.ability == nil) then
    self.Finish();
    return;
  end
  if (bot:GetAbilityPoints() > 0) then
    local ability = bot:GetAbilityByName(self.ability);
    if(ability and ability:CanAbilityBeUpgraded()) then
      local was = ability:GetLevel();
      bot:Action_LevelAbility(self.ability);
      if ((ability:GetLevel() - was) > 0) then
        print("Ability "..self.ability.." leveled from "..was.." to "..ability:GetLevel());
        if (self.table) then
          table.remove(self.table, 1);
        end
      end
    end
  end
end

function M:Finish()
  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
