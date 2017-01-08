local AntimageBlink = {}
      AntimageBlink.name = "antimage_blink";
------------------------------------
local BotActions  = require(GetScriptDirectory().."/dev/bot_actions");
local BotInfo     = require(GetScriptDirectory().."/dev/bot_info")
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper")
------------------------------------
function AntimageBlink:Think(Mode, Strategy)
  local bot = GetBot();
  local ability = bot:GetAbilityByName(self.name);
  if (ability:IsFullyCastable()) then
    if (BotInfo:Me().action == BotActions.ActionMoveToLocation) then
      local location = BotInfo:Me().action.location;
      if (bot:GetMana() > 120 and GetUnitToLocationDistance(bot, location) > 900) then
        if (InventoryHelper:Contains(bot, "item_power_treads", true)) then
          BotActions.ActionPtSwitchAbility:Call(self.name, location);
        else
          BotActions.ActionUseAbility:Call(self.name, location);
        end
      end
    elseif (BotInfo:Me().action == BotActions.ActionPtSwitchAbility and BotInfo:Me().action.ability == self.name) then
      local location = BotInfo:Me().action.second;
      BotActions.ActionPtSwitchAbility:Call(self.name, location);
    end
  end
end
------------------------------------
return AntimageBlink;
