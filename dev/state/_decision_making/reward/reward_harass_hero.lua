local RewardHarassHero = {};
-----------------------------------------
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper")
local HeroHelper      = require(GetScriptDirectory().."/dev/helper/hero_helper")
-----------------------------------------
local HARASS_BASE = 5;
local HARASS_FACTOR = 10;
local FLASK_ADD = 14;
local CLARITY_ADD = 10;
local BOTTLE_ADD = 8;
local REGEN_FACTOR = 5;
local STOCK_HEALTH_FACTOR = 0.5;
-----------------------------------------
function RewardHarassHero:Hero( hHero )
  local bot = GetBot();
  local my_dps = HeroHelper:HeroHarassDamage(bot, hHero);
  local my_health = bot:GetHealth();
  local my_harass_range = bot:GetAttackRange();
  local my_health_regeneration = bot:GetHealthRegen();
  local my_health_in_stock = InventoryHelper:HealthConsumables(bot);

  local enemy_dps = HeroHelper:HeroHarassDamage(hHero, bot);
  local enemy_health = hHero:GetHealth();
  local enemy_harass_range = hHero:GetAttackRange();
  local enemy_health_regeneration = hHero:GetHealthRegen();
  local enemy_health_in_stock = InventoryHelper:HealthConsumables(hHero);

  local enemy_has_flask   = ( hHero:HasModifier("modifier_flask_healing") and FLASK_ADD or 0);
  local enemy_has_clarity = ( hHero:HasModifier("modifier_greater_clarity") and CLARITY_ADD or 0);
  local enemy_has_bottle  = ( hHero:HasModifier("modifier_bottle_regeneration") and BOTTLE_ADD or 0);

  local harass_him_p = ((my_dps - enemy_health_regeneration * REGEN_FACTOR) / (enemy_health_in_stock * STOCK_HEALTH_FACTOR + enemy_health));
  local harass_me_p = 0;
  if ((GetUnitToUnitDistance(bot, hHero) - 150) < enemy_harass_range) then -- in enemy harass range
    harass_me_p = ((enemy_dps - my_health_regeneration * REGEN_FACTOR) / (my_health_in_stock * STOCK_HEALTH_FACTOR + my_health));
  end
  return HARASS_BASE + HARASS_FACTOR * (harass_him_p / (harass_me_p + harass_him_p)) + enemy_has_flask + enemy_has_clarity + enemy_has_bottle; 
end
-----------------------------------------
return RewardHarassHero;
