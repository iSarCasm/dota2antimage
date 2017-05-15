local AbilityItems = {};
-----------------------------------------------
-----------------------------------------------
function AbilityItems:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.ability = {};
    -- Antimage
    o.ability["antimage_blink"]   = require(GetScriptDirectory().."/dev/abilities/skills/antimage/antimage_blink"):new();
    -- Nevermore
    o.ability["nevermore_shadowraze1"]   = require(GetScriptDirectory().."/dev/abilities/skills/nevermore/nevermore_shadowraze1"):new();
    o.ability["nevermore_shadowraze2"]   = require(GetScriptDirectory().."/dev/abilities/skills/nevermore/nevermore_shadowraze2"):new();
    o.ability["nevermore_shadowraze3"]   = require(GetScriptDirectory().."/dev/abilities/skills/nevermore/nevermore_shadowraze3"):new();

    -- Items
    o.ability["item_courier"]   = require(GetScriptDirectory().."/dev/abilities/items/item_courier"):new();
    o.ability["item_bfury"]     = require(GetScriptDirectory().."/dev/abilities/items/item_bfury"):new();
    o.ability["item_quelling_blade"] = require(GetScriptDirectory().."/dev/abilities/items/item_quelling_blade"):new();
    o.ability["item_iron_talon"]     = require(GetScriptDirectory().."/dev/abilities/items/item_iron_talon"):new();
    o.ability["item_tango"]   = require(GetScriptDirectory().."/dev/abilities/items/item_tango"):new();
    o.ability["item_branches"]   = require(GetScriptDirectory().."/dev/abilities/items/item_branches"):new();
    o.ability["item_flask"]   = require(GetScriptDirectory().."/dev/abilities/items/item_flask"):new();
    o.ability["item_bottle"]   = require(GetScriptDirectory().."/dev/abilities/items/item_bottle"):new();
    o.ability["item_faerie_fire"]   = require(GetScriptDirectory().."/dev/abilities/items/item_faerie_fire"):new();
    return o;
end
-----------------------------------------------
function AbilityItems:InstaUse(BotInfo, Mode, Strategy)
  for i, ability in ipairs(self:List(GetBot())) do
    if (self.ability[ability] and self.ability[ability].InstaUse) then
      self.ability[ability]:InstaUse(Mode, Strategy);
    end
  end
end

function AbilityItems:List(bot)
  local list = {};
  for i, ability in ipairs(bot.flex_bot.botInfo.abilities) do
    table.insert(list, ability);
  end

  for i = 0, 5 do
    local slot = GetBot():GetItemInSlot(i);
    if (slot) then
      table.insert(list, slot:GetName());
    end
  end
  return list;
end
-----------------------------------------------
return AbilityItems;
