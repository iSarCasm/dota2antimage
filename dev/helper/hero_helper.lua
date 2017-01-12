local HeroHelper = {};
----------------------------------------------
local UnitHelper = require(GetScriptDirectory().."/dev/helper/unit_helper")
----------------------------------------------
function HeroHelper:TooDangerous(unit)
  local heroes = unit:GetNearbyHeroes(1500, true, BOT_MODE_NONE);
  local burst_damage = 0;
  for i = 1, #heroes do
    local hero = heroes[i];
    burst_damage = burst_damage + self:HeroBurstDamage(unit, hero, 3);
  end
  print("burst is "..burst_damage);
  return unit:GetHealth() < burst_damage;
end

function HeroHelper:HeroBurstDamage(me, target, time)
  local phys_damage = UnitHelper:GetPhysDamageToUnit(target, me, false, false, true);
  print("dmg "..phys_damage);
  print("aps "..target:GetSecondsPerAttack());
  local phys_dps = phys_damage / target:GetSecondsPerAttack();
  return phys_dps * time;
end
----------------------------------------------
return HeroHelper;
