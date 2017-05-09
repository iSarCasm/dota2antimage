local ItemFlask = {}
      ItemFlask.name = "item_bottle";
------------------------------------
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper")
------------------------------------
function ItemFlask:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ItemFlask:Ability()
  return InventoryHelper:GetItemByName(GetBot(), self.name, true);
end
------------------------------------
function ItemFlask:InstaUse(Mode, Strategy)
  local bot = GetBot();
  if (not bot:HasModifier("modifier_bottle_regeneration")) then
    if ((bot:GetMaxHealth()-bot:GetHealth()) > 300 or ((bot:GetMaxHealth()-bot:GetHealth()) > 90 and (bot:GetMaxMana()-bot:GetMana()) > 90)) then
      bot:Action_UseAbilityOnEntity(self:Ability(), bot);
    end
  end
end
------------------------------------
return ItemFlask;
