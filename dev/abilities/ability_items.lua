local AbilityItems = {};
-----------------------------------------------
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
-----------------------------------------------
AbilityItems.ability = {};
-- Antimage
AbilityItems.ability["antimage_blink"] = require(GetScriptDirectory().."/dev/abilities/skills/antimage/antimage_blink");

AbilityItems.item = {}
AbilityItems.item["item_courier"]   = require(GetScriptDirectory().."/dev/abilities/items/item_courier");
AbilityItems.item["item_tango"]     = require(GetScriptDirectory().."/dev/abilities/items/item_tango");
AbilityItems.item["item_flask"]     = require(GetScriptDirectory().."/dev/abilities/items/item_flask");
-----------------------------------------------
function AbilityItems:Think(Mode, Strategy)
  for i, ability in ipairs(BotInfo:Me().abilities) do
    if (self.ability[ability]) then
      self.ability[ability]:Think(Mode, Strategy);
    end
  end

  for i = 0, 5 do
    local slot = GetBot():GetItemInSlot(i);
    if (slot) then
      if (self.item[slot:GetName()]) then
        self.item[slot:GetName()]:Think(Mode, Strategy);
      end
    end
  end
end
-----------------------------------------------
return AbilityItems;
