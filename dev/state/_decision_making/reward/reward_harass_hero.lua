local RewardHarassHero = {};
-----------------------------------------
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper")
local HeroHelper      = require(GetScriptDirectory().."/dev/helper/hero_helper")
-----------------------------------------
local HARASS_COFACTOR = 25;
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

  local harass_him_p = ((my_dps - enemy_health_regeneration) / (enemy_health_in_stock + enemy_health)) * HARASS_COFACTOR;
  local harass_me_p = 0;
  if ((GetUnitToUnitDistance(bot, hHero) - 150) < enemy_harass_range) then -- in enemy harass range
    harass_me_p = ((enemy_dps - my_health_regeneration) / (my_health_in_stock + my_health)) * HARASS_COFACTOR;
  end
  print("harass_him_p "..harass_him_p);
  print("harass_me_p "..harass_me_p);
  return 3.75 + harass_him_p - harass_me_p ; 
end
-----------------------------------------
return RewardHarassHero;
