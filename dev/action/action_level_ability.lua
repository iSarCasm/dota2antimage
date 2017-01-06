local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
M.name = "Purchase Next Item";
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
  print("ability choice is "..self.ability);
  if (bot:GetAbilityPoints() > 0) then
    bot:Action_LevelAbility(self.ability);
    if (self.table) then
        table.remove(self.table, 1);
    end
  end
end

function M:Finish()
  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
