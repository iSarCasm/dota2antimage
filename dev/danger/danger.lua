local Danger = {};
-----------------------------------------
local VectorHelper = require(GetScriptDirectory().."/dev/helper/vector_helper");
-----------------------------------------
local FountainDanger  = require(GetScriptDirectory().."/dev/danger/fountain_danger");
local TowerDanger     = require(GetScriptDirectory().."/dev/danger/tower_danger");
local HeroDanger      = require(GetScriptDirectory().."/dev/danger/hero_danger");
-----------------------------------------
Danger.danger_sources = {
  FountainDanger,
  TowerDanger,
  HeroDanger
}
-----------------------------------------
local DANGER_TRAVEL_DISTANCE = 1000;
-----------------------------------------
function Danger:SafestLocation(unit)
  local result_vector = 0;
  local total_delta = 0;
  for i = 1, #self.danger_sources do
    local source = self.danger_sources[i];
    local safety_delta = self:SafetyDelta(source, unit);
    local safety_vector = self:SafetyVector(source, unit);
    local danger_delta = self:DangerDelta(source, unit);
    local danger_vector = unit:GetLocation() + VectorHelper:Normalize(unit:GetLocation() - self:DangerVector(source, unit)) * 250;
    total_delta = total_delta + safety_delta + danger_delta;
    result_vector = result_vector + safety_vector * safety_delta + danger_vector * danger_delta;
    DebugDrawCircle(safety_vector, 25, 0, 255 ,0);
    DebugDrawLine(unit:GetLocation(), safety_vector, 0, 255 ,0);
    DebugDrawCircle(self:DangerVector(source, unit), 25, 255, 0 ,0);
    DebugDrawLine(unit:GetLocation(), self:DangerVector(source, unit), 255, 0 ,0);
  end
  return result_vector / total_delta;
end

function Danger:SafetyDelta(source, unit)
  return source:PowerDelta(GetTeam(), unit, DANGER_TRAVEL_DISTANCE);
end

function Danger:SafetyVector(source, unit)
  return source:Location(GetTeam());
end

function Danger:DangerDelta(source, unit)
  return source:PowerDelta(GetEnemyTeam(), unit, 250);
end

function Danger:DangerVector(source, unit)
  return source:Location(GetEnemyTeam());
end
-----------------------------------------
return Danger;
