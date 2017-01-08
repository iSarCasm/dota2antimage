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
      if (trees[1]) then
        BotActions.ActionUseAbility:Call(self.name, trees[1]);
      end
    end
  end
end
------------------------------------
return ItemTango;
