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

Danger.fast_danger_sources = {
  FountainDanger
}
-----------------------------------------
local DANGER_TRAVEL_DISTANCE = 1000;
-----------------------------------------
function Danger:Location( vLocation )
  local total_danger = 0;
  for i = 1, #self.fast_danger_sources do
    local source = self.fast_danger_sources[i];
    local s_danger = source:OfLocation(vLocation, GetTeam());
    local e_danger = source:OfLocation(vLocation, GetEnemyTeam());
    total_danger = total_danger + e_danger - s_danger;
  end
  return Max(0, total_danger);
end

function Danger:SafestLocation(unit)
  local result_vector = 0;
  local total_delta = 0;
  for i = 1, #self.danger_sources do
    local source = self.danger_sources[i];
    local safety_delta = self:SafetyDelta(source, unit);
    local safety_vector = self:SafetyVector(source, unit);
    local danger_delta = self:DangerDelta(source, unit) / 10;
    local danger_location = self:DangerVector(source, unit);
    local danger_vector = unit:GetLocation() + VectorHelper:Normalize(unit:GetLocation() - danger_location) * 250;
    total_delta = total_delta + safety_delta + danger_delta;
    result_vector = result_vector + safety_vector * safety_delta + danger_vector * danger_delta;
    self:Debug(unit, safety_vector, 0, 255);
    self:Debug(unit, danger_location, 255, 0);
    fprint(source.name);
    fprint(safety_delta);
    fprint(danger_delta);
  end
  local res = result_vector / total_delta;
  fprint("my loc");
  print(unit:GetLocation());
  fprint("t loc");
  print(res);
  DebugDrawCircle(res, 50, 255, 255 ,255);
  DebugDrawLine(unit:GetLocation(), res, 255, 255 ,255);
  return res;
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

function Danger:Debug(unit, vector, cr, cg)
  if (not(vector.x == 0 and vector.y == 0)) then
    DebugDrawCircle(vector, 25, cr, cg ,0);
    DebugDrawLine(unit:GetLocation(), vector, cr, cg ,0);
  end
end
-----------------------------------------
return Danger;
