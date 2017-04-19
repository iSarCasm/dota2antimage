local Danger = {};
-----------------------------------------
local FountainDanger  = require(GetScriptDirectory().."/dev/danger/fountain_danger");
local TowerDanger     = require(GetScriptDirectory().."/dev/danger/tower_danger");
-----------------------------------------
Danger.danger_sources = {
  FountainDanger,
  TowerDanger
}
-----------------------------------------
local DANGER_TRAVEL_DISTANCE = 1000;
-----------------------------------------
function Danger:SafestLocation(unit)
  local result_vector = 0;
  local total_delta = 0;
  for i = 1, #self.danger_sources do
    local source = self.danger_sources[i];
    local source_delta = source:PowerDelta(GetTeam(), unit, DANGER_TRAVEL_DISTANCE);
    local source_vector = source:Location(GetTeam()) * source_delta;
    total_delta = total_delta + source_delta;
    result_vector = result_vector + source_vector;
  end
  return result_vector / total_delta;
end
-----------------------------------------
return Danger;
