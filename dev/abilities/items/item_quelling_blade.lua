local ItemQuellingBlade = {}
      ItemQuellingBlade.name = "item_quelling_blade";
------------------------------------
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper");
local UnitHelper      = require(GetScriptDirectory().."/dev/helper/unit_helper");
local BotInfo         = require(GetScriptDirectory().."/dev/bot_info");
------------------------------------
function ItemQuellingBlade:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ItemQuellingBlade:Ability()
  return InventoryHelper:GetItemByName(GetBot(), self.name, true);
end
------------------------------------
function ItemQuellingBlade:InstaUse(Mode, Strategy)
  local bot = GetBot();
end
------------------------------------
return ItemQuellingBlade;
