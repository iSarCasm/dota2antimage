local AbilityItems = {};
-----------------------------------------------
AbilityItems.ability = {};
-- Antimage
AbilityItems.ability["antimage_blink"]   = require(GetScriptDirectory().."/dev/abilities/skills/antimage/antimage_blink");

AbilityItems.item = {}
-- Items
AbilityItems.item["item_courier"]   = require(GetScriptDirectory().."/dev/abilities/items/item_courier");
AbilityItems.item["item_bfury"]     = require(GetScriptDirectory().."/dev/abilities/items/item_bfury");
AbilityItems.item["item_quelling_blade"] = require(GetScriptDirectory().."/dev/abilities/items/item_quelling_blade");
AbilityItems.item["item_iron_talon"]     = require(GetScriptDirectory().."/dev/abilities/items/item_iron_talon");
AbilityItems.item["item_tango"]   = require(GetScriptDirectory().."/dev/abilities/items/item_tango");
AbilityItems.item["item_flask"]   = require(GetScriptDirectory().."/dev/abilities/items/item_flask");
-----------------------------------------------
function AbilityItems:Think(BotInfo, Mode, Strategy)
  for i, ability in ipairs(BotInfo.abilities) do
    if (self.ability[ability] and self.ability[ability].Think) then
      self.ability[ability]:Think(Mode, Strategy);
    end
  end

  for i = 0, 5 do
    local slot = GetBot():GetItemInSlot(i);
    if (slot) then
      if (self.item[slot:GetName()] and self.item[slot:GetName()].Think) then
        self.item[slot:GetName()]:Think(Mode, Strategy);
      end
    end
  end
end

function AbilityItems:TryTravel( vLocation )

end
-----------------------------------------------
return AbilityItems;
