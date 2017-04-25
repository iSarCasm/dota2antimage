local RewardFarmCreepwave = {}
----------------------------------------------------
local Creeping = require(GetScriptDirectory().."/dev/state/state_farming_lane/creeping");
----------------------------------------------------
function RewardFarmCreepwave:Generic(Lane, BotInfo, Mode)
  return 80 + (self:LaningReward(Lane, BotInfo, Mode)) + self:LowCreepReward();
end

function RewardFarmCreepwave:LaningReward(Lane, BotInfo, Mode)
  if (Mode == MODE_LANING) then
    if (Lane == BotInfo.LANE) then
      return 0;
    end
    return -30;
  end
  return 0;
end

function RewardFarmCreepwave:LowCreepReward()
  if (Creeping:CreepWithNHitsOfHealth(1000, true, true, 1)) then
    return 140;
  else
    return 0;
  end
end
----------------------------------------------------
return RewardFarmCreepwave;
