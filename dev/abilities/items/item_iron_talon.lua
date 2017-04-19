local ItemIronTalon = {}
      ItemIronTalon.name = "item_iron_talon";
------------------------------------
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper");
local UnitHelper      = require(GetScriptDirectory().."/dev/helper/unit_helper");
local BotInfo         = require(GetScriptDirectory().."/dev/bot_info");
------------------------------------
function ItemIronTalon:Ability()
  return InventoryHelper:GetItemByName(GetBot(), self.name, true);
end
------------------------------------
function ItemIronTalon:Think(Mode, Strategy)
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
return ItemIronTalon;
