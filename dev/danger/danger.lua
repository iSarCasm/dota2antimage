local Danger = {};
-----------------------------------------
local FountainDanger = require(GetScriptDirectory().."/dev/danger/fountain_danger");
-----------------------------------------
function Danger:SafestLocation(unit)
  local total_delta = 0;
  local fountain_delta = FountainDanger:PowerDelta(GetTeam(), unit, 1000);
  local result_vector = FountainDanger:Location(GetTeam()) * fountain_delta;
  local total_delta = total_delta + fountain_delta;
  return result_vector / total_delta;
end

function Danger:EstimateDanger(location)
  return FountainDanger:Estimate(GetEnemyTeam(), location);
end
-----------------------------------------
return Danger;
