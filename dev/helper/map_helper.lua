local M = {}
----------------------
function M:LaneFrontLocation(team, lane, ignoreTowers)
  return GetLaneFrontLocation(team, lane, GetLaneFrontAmount(team, lane, ignoreTowers));
end
----------------------
return M;
