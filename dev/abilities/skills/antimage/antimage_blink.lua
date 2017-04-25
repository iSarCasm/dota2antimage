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
  local bot = GetBot();
  local ability = bot:GetAbilityByName(self.name);
  if (ability:IsFullyCastable()) then
    local move_location = bot.flex_bot.moving_location;
    if (move_location and self:IsWorthUsing(move_location)) then
      bot:Action_UseAbilityOnLocation(ability, move_location);
    end
  end
end

function AntimageBlink:IsWorthUsing( vLocation )
  local bot = GetBot();
  return bot:GetMana() > 120 and (GetUnitToLocationDistance(bot, vLocation) > 900)
end
------------------------------------
return AntimageBlink;
