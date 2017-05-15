local Dance = {}
Dance.name = "Dance";
-------------------------------------------------
function Dance:Call(point, range, time)
  local bot = GetBot();
  if (not bot.flex_bot.dance_location) then
    self:SetNewVector(point, range, time);
  end
  if (self:OldVectorExpired()) then
    self:SetNewVector(point, range, time);
  end
  bot:Action_MoveToLocation(bot.flex_bot.dance_location);
  DebugDrawCircle(bot.flex_bot.dance_location, 25, 0, 0 ,0);
  DebugDrawLine(bot:GetLocation(), bot.flex_bot.dance_location, 0, 0 ,0);
end

function Dance:SetNewVector(point, range, time)
  local bot = GetBot();
  local new_vec = point + RandomVector(range);
  bot.flex_bot.dance_location = new_vec;
  bot.flex_bot.dance_time = DotaTime() + time;
end

function Dance:OldVectorExpired()
  local bot = GetBot();
  local time_expired = DotaTime() > bot.flex_bot.dance_time;
  return (GetUnitToLocationDistance(bot, bot.flex_bot.dance_location) < 10) or time_expired;
end
-------------------------------------------------
return Dance;
