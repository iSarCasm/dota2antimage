local ItemTango = {}
      ItemTango.name = "item_tango";
------------------------------------
local BotActions  = require(GetScriptDirectory().."/dev/bot_actions");
local BotInfo     = require(GetScriptDirectory().."/dev/bot_info")
------------------------------------
function ItemTango:Think(Mode, Strategy)
  local bot = GetBot();
  if (not bot:HasModifier("modifier_tango_heal")) then
    if ((bot:GetMaxHealth()-bot:GetHealth()) > 150) then
      local trees = bot:GetNearbyTrees(700);
      if (trees) then
        local closest_range = VERY_HIGH_INT;
        local closest = nil;
        for i = 1, #trees do
          local tree = trees[i];
          if (IsLocationPassable(GetTreeLocation(tree))) then
            local dist = GetUnitToLocationDistance(bot, GetTreeLocation(tree));
            if (dist < closest_range) then
              closest_range = dist;
              closest = tree;
            end
          end
        end
        if (closest) then
          print("please it tree "..closest);
          BotActions.ActionUseAbility:Call(self.name, closest);
          return;
        end
      end
    end
  end
end
------------------------------------
return ItemTango;
