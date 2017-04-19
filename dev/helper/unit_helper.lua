local M = {};
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper");

M.LanePoints = {}
function M:InitLanePoints()
    for i = 1, 3 do
        self.LanePoints[i] = {};
        for j = 0, 24 do
            self.LanePoints[i][j] = GetLocationAlongLane(i, j / 24.0);
        end
    end
end
M:InitLanePoints();

function M:GetUnitLane(unit)
  for i = 1, 3 do
      for j = 0, 24 do
        if (GetUnitToLocationDistance(unit, self.LanePoints[i][j]) < 900) then
          return i;
        end
      end
    end
    return nil;
end

function M:IsFacingTree( hUnit, nTree, degAccuracy )
  local degree = nil;
  -- Do we have a target?
  if(nTree) then
    return self:IsFacing(hUnit, GetTreeLocation(nTree), degAccuracy);
  end
  return false;
end

function M:IsFacingEntity( hUnit, hTarget, degAccuracy )
  local degree = nil;
  -- Do we have a target?
  if(hTarget) then
    return self:IsFacing(hUnit, hTarget:GetLocation(), degAccuracy);
  end
  return false;
end

function M:IsFacing( hUnit, tVector, degAccuracy )
  local degree = nil;
  -- Do we have a target?
  if(tVector) then
    -- Get my hero and my heros target location
    local unitX = hUnit:GetLocation().x;
    local unitY = hUnit:GetLocation().y;
    local targetX = tVector.x;
    local targetY = tVector.y;

    local vX = (targetX-unitX);
    local vY = (targetY-unitY);

    local radians = math.atan2( vY , vX );
    degree = (radians * 180 / math.pi);

    if ( degree < 0 )
    then
        degree = degree + 360;
    end

    -- Time to check if the facing is good enough
    local botBoundary = degree - degAccuracy;
    local topBoundary = degree + degAccuracy;
    local flippedBoundaries = false;

    if(botBoundary < 0)
    then
        botBoundary = botBoundary + 360;
        flippedBoundaries = true;
    end

    if(topBoundary > 360)
    then
        topBoundary = topBoundary - 360;
        flippedBoundaries = true;
    end
    if( ( flippedBoundaries and (topBoundary < hUnit:GetFacing() ) and ( hUnit:GetFacing() < botBoundary) ) or
    ( not flippedBoundaries and (botBoundary < hUnit:GetFacing() ) and ( hUnit:GetFacing() < topBoundary) )    )
    then
        return true
    end
  end
  return false;
end

function M:ProjectileTimeTravel(unit, target, speed)
  speed = speed or 1000;
  if (speed == 0) then
    return 0;
  end
  return GetUnitToUnitDistance(unit, target) / speed;
end

function M:TimeOnAttacks(unit, hits)
  if (hits == 1) then
    return unit:GetAttackPoint();
  else
    return unit:GetAttackPoint() + (hits-1) * unit:GetSecondsPerAttack();
  end
end

function M:TimeToGetInRange(unit, target)
  local dist = GetUnitToUnitDistance(unit, target);
  local range = unit:GetAttackRange();
  if (dist < range) then
    return 0;
  else
    return (dist-range) / unit:GetCurrentMovementSpeed();
  end
end

function M:GetPhysDamageToUnit(unit, target, isCreep, hasMana)
  local isAlly = (unit:GetTeam() == target:GetTeam());
  local total = unit:GetAttackDamage();
  if (isCreep and (not isAlly) and InventoryHelper:Contains(unit, "item_quelling_blade", true)) then
    total = total + 24;
  end
  if (hasMana and (not isAlly)) then
    local mana_break = unit:GetAbilityByName("antimage_mana_break");
    if (mana_break) then
      total = total + mana_break:GetSpecialValueFloat("damage_per_burn") * mana_break:GetSpecialValueFloat("mana_per_hit");
    end
  end
  return target:GetActualIncomingDamage(total, DAMAGE_TYPE_PHYSICAL);
end

function M:NetWorth(unit)
  local goldLeft = gold;
  local worth = 0;
  for i = 0, 5 do
    local item = unit:GetItemInSlot(i);
    if (item) then
      worth = worth + GetItemCost(item:GetName());
    end
  end
  return worth;
end

return M;
