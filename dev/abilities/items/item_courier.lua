local ItemCourier = {}
      ItemCourier.name = "item_courier";
------------------------------------
local BotActions  = require(GetScriptDirectory().."/dev/bot_actions");
local BotInfo     = require(GetScriptDirectory().."/dev/bot_info")
------------------------------------
function ItemCourier:Think(Mode, Strategy)
  local bot = GetBot();
  BotActions.ActionUseAbility:Call(self.name);
end
------------------------------------
return ItemCourier;
