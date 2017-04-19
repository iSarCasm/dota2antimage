local ItemFlask = {}
      ItemFlask.name = "item_flask";
------------------------------------
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper")
local BotInfo         = require(GetScriptDirectory().."/dev/bot_info")
------------------------------------
function ItemFlask:Ability()
  return InventoryHelper:GetItemByName(GetBot(), self.name, true);
end
------------------------------------
function ItemFlask:Think(Mode, Strategy)
  local bot = GetBot();
  if (not bot:HasModifier("modifier_flask_healing")) then
    if ((bot:GetMaxHealth()-bot:GetHealth()) > 300) then
      bot:Action_UseAbilityOnEntity(self:Ability(), bot);
    end
  end
end
------------------------------------
return ItemFlask;
