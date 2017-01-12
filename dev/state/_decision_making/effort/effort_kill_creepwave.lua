local EffortKillCreepwave = {}
----------------------------------------------------
function EffortKillCreepwave:Generic()
  local bot = GetBot();
  local creep_health = 2000; -- approx creep wave health
  local dps = bot:GetBaseDamage() + 50; -- needs API fix
  local last_hit_simplify = 0.25; -- ??
  return (creep_health * last_hit_simplify) / dps;
end
----------------------------------------------------
return EffortKillCreepwave;
