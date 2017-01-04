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

return M;
