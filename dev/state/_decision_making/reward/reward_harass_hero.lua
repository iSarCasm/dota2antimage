local RewardHarassHero = {};
-----------------------------------------
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper")
local HeroHelper      = require(GetScriptDirectory().."/dev/helper/hero_helper")
-----------------------------------------
local HARASS_BASE = 6;
local HARASS_FACTOR = 25;
local FLASK_ADD = 22;
local CLARITY_ADD = 17;
local BOTTLE_ADD = 12;
local REGEN_FACTOR = 5;
local STOCK_HEALTH_FACTOR = 0.4;
-----------------------------------------
function RewardHarassHero:Hero( hHero, allHeroes )
  local bot = GetBot();
  local my_dps = HeroHelper:HeroHarassDamage(bot, hHero);
  local my_health = bot:GetHealth();
  local my_harass_range = bot:GetAttackRange();
  local my_health_regeneration = bot:GetHealthRegen();
  local my_health_in_stock = InventoryHelper:HealthConsumables(bot);

  local enemy_dps = HeroHelper:HeroHarassDamage(hHero, bot);
  local enemy_health = hHero:GetHealth();
  local enemy_health_regeneration = hHero:GetHealthRegen();
  local enemy_health_in_stock = InventoryHelper:HealthConsumables(hHero);

  local enemy_has_flask   = ( hHero:HasModifier("modifier_flask_healing") and FLASK_ADD or 0);
  local enemy_has_clarity = ( hHero:HasModifier("modifier_greater_clarity") and CLARITY_ADD or 0);
  local enemy_has_bottle  = ( hHero:HasModifier("modifier_bottle_regeneration") and BOTTLE_ADD or 0);

  local harass_him_p = ((my_dps - enemy_health_regeneration * REGEN_FACTOR) / (enemy_health_in_stock * STOCK_HEALTH_FACTOR + enemy_health));
  local harass_me_p = self:HarassMe(allHeroes);
  return HARASS_BASE + HARASS_FACTOR * (harass_him_p / (harass_me_p + harass_him_p)) + enemy_has_flask + enemy_has_clarity + enemy_has_bottle; 
end

function RewardHarassHero:HarassMe(allHeroes)
  local bot = GetBot();
  local harass_me_p = 0;
  for i = 1, #allHeroes do
    local hero = allHeroes[i];

    local my_dps = HeroHelper:HeroHarassDamage(bot, hero);
    local my_health = bot:GetHealth();
    local my_harass_range = bot:GetAttackRange();
    local my_health_regeneration = bot:GetHealthRegen();
    local my_health_in_stock = InventoryHelper:HealthConsumables(bot);

    local enemy_dps = HeroHelper:HeroHarassDamage(hero, bot);
    local enemy_health = hero:GetHealth();
    local enemy_health_regeneration = hero:GetHealthRegen();
    local enemy_health_in_stock = InventoryHelper:HealthConsumables(hero);
    local enemy_harass_range = hero:GetAttackRange();
    if ((GetUnitToUnitDistance(bot, hero) - 150) < enemy_harass_range) then -- in enemy harass range
      harass_me_p = harass_me_p + ((enemy_dps - my_health_regeneration * REGEN_FACTOR) / (my_health_in_stock * STOCK_HEALTH_FACTOR + my_health));
    end
  end
  return harass_me_p;
end
-----------------------------------------
return RewardHarassHero;
