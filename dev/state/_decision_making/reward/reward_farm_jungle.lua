local RewardFarmJungle = {}
----------------------------------------------------
function RewardFarmJungle:Camp(JungleSpawn, BotInfo, Mode)
  return JUNGLE_CAMP[JungleSpawn].Gold;
end
----------------------------------------------------
return RewardFarmJungle;
