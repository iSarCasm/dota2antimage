local EffortKillJungle = {}
----------------------------------------------------
function EffortKillJungle:Camp(JungleSpawn)
  local bot = GetBot();
  local camp_power = JUNGLE_CAMP[JungleSpawn].Power;
  local dps = 50 + bot:GetBaseDamage() / bot:GetSecondsPerAttack(); -- needs fix
  if (DotaTime() > 15*60) then return camp_power * 0.05 / dps end;
  return camp_power * 100000 / dps;
end
----------------------------------------------------
return EffortKillJungle;
