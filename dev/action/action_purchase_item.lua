local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
M.name = "Purchase Item";
-------------------------------------------------
function M:Call(item)
  local args = {item};
  self.args = args;
  BotInfo:SetAction(self, args);
end

function M:SetArgs()
  self.item = self.args[1];
end

function M:Run()
  self:SetArgs();
  local bot = GetBot();
  local me = BotInfo:Me();
  local item =self.item;
  if (item == nil) then
    self.Finish();
    return;
  end
  print("item buy is "..item);
  if (bot:GetGold() >= GetItemCost(item)) then
    bot:ActionImmediate_PurchaseItem(item);
    table.remove( me.itemBuild, 1 );
  end
end

function M:Finish()
  self.item = nil;
  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
