local ItemCourier = {}
      ItemCourier.name = "item_courier";
------------------------------------
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper")
local BotInfo         = require(GetScriptDirectory().."/dev/bot_info")
------------------------------------
function ItemCourier:Ability()
  return InventoryHelper:GetItemByName(GetBot(), self.name, true);
end
------------------------------------
function ItemCourier:Think(Mode, Strategy)
  local bot = GetBot();
  print('use courier');
  bot:Action_UseAbility(self:Ability());
end
------------------------------------
return ItemCourier;
