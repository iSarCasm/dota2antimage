local ItemFaerieFire = {}
      ItemFaerieFire.name = "item_faerie_fire";
------------------------------------
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper")
------------------------------------
function ItemFaerieFire:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ItemFaerieFire:Ability()
  return InventoryHelper:GetItemByName(GetBot(), self.name, true);
end
------------------------------------
function ItemFaerieFire:InstaUse(Mode, Strategy)
  local bot = GetBot();
  if (bot:GetHealth() < 100) then
    bot:Action_UseAbility(self:Ability());
  end
end
------------------------------------
return ItemFaerieFire;
