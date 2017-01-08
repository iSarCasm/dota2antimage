local ItemFlask = {}
      ItemFlask.name = "item_flask";
------------------------------------
local BotActions  = require(GetScriptDirectory().."/dev/bot_actions");
local BotInfo     = require(GetScriptDirectory().."/dev/bot_info")
------------------------------------
function ItemFlask:Think(Mode, Strategy)
  local bot = GetBot();
  if (not bot:HasModifier("modifier_flask_healing")) then
    if ((bot:GetMaxHealth()-bot:GetHealth()) > 300) then
      BotActions.ActionUseAbility:Call(self.name, bot);
    end
  end
end
------------------------------------
return ItemFlask;
