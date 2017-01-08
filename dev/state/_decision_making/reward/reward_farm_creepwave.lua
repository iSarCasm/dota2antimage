local RewardFarmCreepwave = {}
----------------------------------------------------
function RewardFarmCreepwave:Generic(Lane, BotInfo, Mode)
  return ((DotaTime()-15) > 0 and (200 + (self:LaningReward(Lane, BotInfo, Mode))) or 0);
end

function RewardFarmCreepwave:LaningReward(Lane, BotInfo, Mode)
  if (Mode == MODE_LANING) then
    if (Lane == BotInfo.LANE) then
      return 50;
    end
    return -100;
  end
  return 0;
end
----------------------------------------------------
return RewardFarmCreepwave;
