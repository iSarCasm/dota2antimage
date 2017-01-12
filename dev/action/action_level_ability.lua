local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
M.name = "Level Ability";
-------------------------------------------------
function M:Call(ability, table)
  local args = {ability, table};
  self.args = args;
  BotInfo:SetAction(self, args);
end

function M:SetArgs()
  self.ability = self.args[1];
  self.table = self.args[2];
end

function M:Run()
  self:SetArgs();
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
  self.ability = nil;
  self.table = nil;
  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
