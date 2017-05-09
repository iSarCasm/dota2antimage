local ItemBranches = {}
      ItemBranches.name = "item_branches";
------------------------------------
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper")
------------------------------------
function ItemBranches:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.Time = DotaTime();
    return o
end

function ItemBranches:Ability()
  return InventoryHelper:GetItemByName(GetBot(), self.name, true);
end
------------------------------------
function ItemBranches:InstaUse(Mode, Strategy)
  local bot = GetBot();
  -- if (InventoryHelper:Contains(bot, "item_tango", true) and not bot:HasModifier("modifier_tango_heal")) then
  --   if ((bot:GetMaxHealth() - bot:GetHealth()) > 200 and DotaTime() > self.Time) then
  --     bot:Action_UseAbilityOnLocation(self:Ability(), bot:GetLocation());
  --     self.Time = DotaTime() + 10;
  --   end
  -- end
end
------------------------------------
return ItemBranches;
