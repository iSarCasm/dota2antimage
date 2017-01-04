local M = {}

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

function M:IsFacingEntity( hUnit, hTarget, degAccuracy )
  local degree = nil;
  -- Do we have a target?
  if(hTarget) then
    -- Get my hero and my heros target location
    local unitX = hUnit:GetLocation()[1];
    local unitY = hUnit:GetLocation()[2];
    local targetX = hTarget:GetLocation()[1];
    local targetY = hTarget:GetLocation()[2];

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

return M;
