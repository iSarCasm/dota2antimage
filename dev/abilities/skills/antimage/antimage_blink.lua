local AntimageBlink = {}
      AntimageBlink.name = "antimage_blink";
------------------------------------
local BotActions  = require(GetScriptDirectory().."/dev/bot_actions");
local BotInfo     = require(GetScriptDirectory().."/dev/bot_info")
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper")
-------------------------------------
function AntimageBlink:Ability()
  return GetBot():GetAbilityByName(self.name);
end
-----------------------------------
function AntimageBlink:Think(Mode, Strategy)
  -- local bot = GetBot();
  -- local ability = bot:GetAbilityByName(self.name);
  -- if (ability:IsFullyCastable()) then
  --   if (BotInfo:Me().action == BotActions.ActionMoveToLocation) then
  --     local location = BotInfo:Me().action.location;
  --     if (location and bot:GetMana() > 120 and (GetUnitToLocationDistance(bot, location) > 900)) then
  --       bot:Action_UseAbilityOnLocation(self.name, location);
  --     end
  --   end
  -- end
end
------------------------------------
return AntimageBlink;
