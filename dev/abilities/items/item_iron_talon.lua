local ItemIronTalon = {}
      ItemIronTalon.name = "item_iron_talon";
------------------------------------
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper");
local UnitHelper      = require(GetScriptDirectory().."/dev/helper/unit_helper");
local BotInfo         = require(GetScriptDirectory().."/dev/bot_info");
------------------------------------
function ItemIronTalon:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ItemIronTalon:Ability()
  return InventoryHelper:GetItemByName(GetBot(), self.name, true);
end
------------------------------------
function ItemIronTalon:InstaUse(Mode, Strategy)
  local bot = GetBot();
end
------------------------------------
return ItemIronTalon;
