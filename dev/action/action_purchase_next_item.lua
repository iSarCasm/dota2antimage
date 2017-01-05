local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
M.name = "Purchase Next Item";
-------------------------------------------------
function M:Call()
  BotInfo:SetAction(self);
end

function M:Run()
  local bot = GetBot();
  local me = BotInfo:Me();
  local item = me.itemBuild[1];
  if (item == nil) then
    self.Finish();
    return;
  end
  print("item buy is "..item);
  if (bot:GetGold() >= GetItemCost(item)) then
    bot:Action_PurchaseItem(item);
    table.remove( me.itemBuild, 1 );
  end
end

function M:Finish()
  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
