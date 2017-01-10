local RewardFarmCreepwave = {}
----------------------------------------------------
function RewardFarmCreepwave:Generic(Lane, BotInfo, Mode)
  return 170 + (self:LaningReward(Lane, BotInfo, Mode));
end

function RewardFarmCreepwave:LaningReward(Lane, BotInfo, Mode)
  if (Mode == MODE_LANING) then
    if (Lane == BotInfo.LANE) then
      return 0;
    end
    return -70;
  end
  return 0;
end
----------------------------------------------------
return RewardFarmCreepwave;
