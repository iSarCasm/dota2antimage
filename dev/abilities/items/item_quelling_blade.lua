local ItemQuellingBlade = {}
      ItemQuellingBlade.name = "item_quelling_blade";
------------------------------------
local BotActions  = require(GetScriptDirectory().."/dev/bot_actions");
local UnitHelper  = require(GetScriptDirectory().."/dev/helper/unit_helper")
------------------------------------
function ItemQuellingBlade:Think(Mode, Strategy)
  local bot = GetBot();
  local trees = bot:GetNearbyTrees(300);
  if (trees) then
    for i = 1, #trees do
      if (UnitHelper:IsFacingTree(bot, trees[i], 30) and IsLocationPassable(GetTreeLocation(trees[i]))) then
        BotActions.ActionUseAbility:Call(self.name, trees[i]);
        return;
      end
    end
  end
end
------------------------------------
return ItemQuellingBlade;
