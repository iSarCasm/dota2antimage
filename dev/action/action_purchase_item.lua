local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
M.name = "Purchase Item";
-------------------------------------------------
function M:Call(item)
  self.item = item;
  BotInfo:SetAction(self);
end

function M:Run()
  local bot = GetBot();
  local me = BotInfo:Me();
  local item =self.item;
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
  self.item = nil;
  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
