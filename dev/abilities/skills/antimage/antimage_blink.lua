local AntimageBlink = {}
      AntimageBlink.name = "antimage_blink";
------------------------------------
local BotActions  = require(GetScriptDirectory().."/dev/bot_actions");
local BotInfo     = require(GetScriptDirectory().."/dev/bot_info")
------------------------------------
function AntimageBlink:Think(Mode, Strategy)
  local bot = GetBot();
  local ability = bot:GetAbilityByName(self.name);
  if (ability:IsFullyCastable()) then
    if (BotInfo:Me().action == BotActions.ActionMoveToLocation) then
      local location = BotInfo:Me().action.location;
      if (bot:GetMana() > 120 and GetUnitToLocationDistance(bot, location) > 900) then
        BotActions.ActionUseAbility:Call(self.name, location);
      end
    end
  end
end
------------------------------------
return AntimageBlink;
