local EffortKillJungle = {}
----------------------------------------------------
function EffortKillJungle:Camp(JungleSpawn)
  local bot = GetBot();
  local camp_power = JUNGLE_CAMP[JungleSpawn].Power;
  local dps = bot:GetBaseDamage() / bot:GetSecondsPerAttack();
  -- if (DotaTime() > 15*60) then return camp_power * 0.25 / dps end;
  return camp_power * 2 / dps;
end
----------------------------------------------------
return EffortKillJungle;
