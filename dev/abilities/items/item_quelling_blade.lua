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
  local trees = bot:GetNearbyTrees(300);
  if (trees) then
    for i = 1, #trees do
      if (UnitHelper:IsFacingTree(bot, trees[i], 30) and IsLocationPassable(GetTreeLocation(trees[i]))) then
        bot:Action_UseAbilityOnTree(self:Ability(), trees[i]);
        return;
      end
    end
  end
end
------------------------------------
return ItemQuellingBlade;
