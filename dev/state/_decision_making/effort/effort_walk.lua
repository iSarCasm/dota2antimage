local EffortWalk = {}
----------------------------------------------------
function EffortWalk:ToLocation(location)
  local bot = GetBot();
  local walkSpeed = bot:GetCurrentMovementSpeed();
  local walkDistance = GetUnitToLocationDistance(bot, location);
  return  walkDistance / walkSpeed;
end
----------------------------------------------------
return EffortWalk;
