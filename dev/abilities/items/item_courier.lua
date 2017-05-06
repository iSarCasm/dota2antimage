local ItemCourier = {}
      ItemCourier.name = "item_courier";
------------------------------------
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper")
local BotInfo         = require(GetScriptDirectory().."/dev/bot_info")
------------------------------------
function ItemCourier:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ItemCourier:Ability()
  return InventoryHelper:GetItemByName(GetBot(), self.name, true);
end
------------------------------------
function ItemCourier:InstaUse(Mode, Strategy)
  local bot = GetBot();
  bot:Action_UseAbility(self:Ability());
end
------------------------------------
return ItemCourier;
