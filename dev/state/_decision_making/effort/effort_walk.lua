local EffortWalk = {}
----------------------------------------------------
function EffortWalk:ToLocation(location)
  local bot = GetBot();
  local walkSpeed = bot:GetCurrentMovementSpeed();
  local walkDistance = GetUnitToLocationDistance(bot, location);
  return walkDistance / walkSpeed;
end

function EffortWalk:IntoRange( vLocation, iRange )
  local bot = GetBot();
  local walkSpeed = bot:GetCurrentMovementSpeed();
  local walkDistance = Max(0, GetUnitToLocationDistance(bot, vLocation) - iRange);
  return walkDistance / walkSpeed;
end

function EffortWalk:ToShop(shop)
  local walkSpeed = GetBot():GetCurrentMovementSpeed();
  local walkDistance = GetUnitToLocationDistance(GetBot(), SHOP[shop]);
  -- if (self:ShopDistance(shop) == 0 and shop ~= GetShop()) then return 0.1 end;
  return walkDistance / walkSpeed;
end
----------------------------------------------------
function EffortWalk:ShopDistance(shop)
  if (shop == SHOP_DIRE or shop == SHOP_RADIANT) then
    return GetBot():DistanceFromFountain();
  elseif (shop == SHOP_SIDE_BOT or shop == SHOP_SIDE_TOP) then
    return GetBot():DistanceFromSideShop();
  else
    return GetBot():DistanceFromSecretShop();
  end
end
----------------------------------------------------
return EffortWalk;
