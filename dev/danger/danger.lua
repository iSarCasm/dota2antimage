local Danger = {};
-----------------------------------------
local Cache         = require(GetScriptDirectory().."/dev/cache");
local VectorHelper  = require(GetScriptDirectory().."/dev/helper/vector_helper");
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
function Danger:Location( vLocation )
  local cached = Cache:GetCacheVector(CACHE_DANGER, vLocation)
  if (cached) then
    -- print("cache hit")
    -- print(vLocation)
    return cached;
  else
    -- print("cache miss "..#Cache.Data[CACHE_DANGER])
    -- print(vLocation)
    local total_danger = 0;
    for i = 1, #self.danger_sources do
      local source = self.danger_sources[i];
      local s_danger = source:OfLocation(vLocation, GetTeam());
      local e_danger = source:OfLocation(vLocation, GetEnemyTeam());
      total_danger = total_danger + e_danger - s_danger;
    end
    local result = Max(0, total_danger)
    Cache:CacheVector(CACHE_DANGER, vLocation, result)
    return result
  end
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
  end
  local res = result_vector / total_delta;
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

function Danger:Cache(vector, value)
  self.CACHE[vector.x+vector.y] = value
end

function Danger:GetCache(vector)
  self:GC();
  if (self.CACHE and self.CACHE[vector.x+vector.y]) then
    return self.CACHE[vector.x+vector.y]
  end
  return nil
end

function Danger:GC()
  if (DotaTime() ~= self.CACHE.time) then
    -- fprint("GC")
    self.CACHE = {}
    self.CACHE.time = DotaTime()
  end
end
-----------------------------------------
return Danger;
