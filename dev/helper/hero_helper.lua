local HeroHelper = {};
----------------------------------------------
local UnitHelper = require(GetScriptDirectory().."/dev/helper/unit_helper")
----------------------------------------------
function HeroHelper:TooDangerous(unit)
  local heroes = unit.flex_bot.botInfo:GetNearbyHeroes(700, true, BOT_MODE_NONE);
  local burst_damage = 0;
  for i = 1, #heroes do
    local hero = heroes[i];
    burst_damage = burst_damage + self:HeroBurstDamage(unit, hero, 3);
  end
  return unit:GetHealth() < burst_damage;
end

function HeroHelper:HeroHarassDamage(me, target)
  local phys_damage = UnitHelper:GetPhysDamageToUnit(target, me, false, false, true);
  local phys_dps = phys_damage / target:GetSecondsPerAttack();
  return phys_dps;
end

function HeroHelper:HeroBurstDamage(me, target, time)
  local phys_damage = UnitHelper:GetPhysDamageToUnit(target, me, false, false, true);
  local phys_dps = phys_damage / target:GetSecondsPerAttack();
  return phys_dps * time;
end

function HeroHelper:LaningOffensivePower(target, me)
  local phys_range = target:GetAttackRange();
  local phys_damage = UnitHelper:GetPhysDamageToUnit(target, me, false, false, true);
  local phys_dps = phys_damage / target:GetSecondsPerAttack();
  return phys_dps * (phys_range / 700);
end

function HeroHelper:LaningDefensivePower(target)
  local health = target:GetHealth();
  local health_regen = target:GetHealthRegen();
  return (health + health_regen * 5) / 10;
end
----------------------------------------------
return HeroHelper;
