local M = {};
----------------------------------------------
local MapHelper       = require(GetScriptDirectory().."/dev/helper/map_helper");
local UnitHelper      = require(GetScriptDirectory().."/dev/helper/unit_helper");
local VectorHelper    = require(GetScriptDirectory().."/dev/helper/vector_helper");
----------------------------------------------
M.TOWER_POWER = 400;
M.MELEE_POWER = 45;
M.RANGE_POWER = 80;
function M:ExtrapolatedDamage(creep, time)
  return 0;
end

function M:GetPhysDamageToCreep(bot, creep)
  local isMelee = (string.find(creep:GetUnitName(), "melee") ~= nil);
  return UnitHelper:GetPhysDamageToUnit(bot, creep, true, (not isMelee));
end

function M:GetNearestCreep(range, bEnemies)
  local creeps = FGetNearbyCreeps(range, bEnemies);
  local nearest_creeps = nil;
  local nearest_distance = VERY_HIGH_INT;
  for i = 1, #creeps do
    local creep = creeps[i];
    local distance = GetUnitToUnitDistance(GetBot(), creep);
    if (creep and not creep:IsNull() and nearest_distance > distance) then
      nearest_distance = distance;
      nearest_creeps = creep;
    end
  end
  return nearest_creeps;
end

function M:CreepHasLessHealthThanNHits(bot, creep, hits)
  local BotInfo = bot.flex_bot.botInfo;
  if (creep:IsAlive()) then
    local bot_damage = self:GetPhysDamageToCreep(bot, creep);
    local time_to_damage = UnitHelper:TimeToGetInRange(bot, creep) + UnitHelper:TimeOnAttacks(bot, hits) + UnitHelper:ProjectileTimeTravel(bot, creep, BotInfo.projectileSpeed) * hits;
    local extrapolated_damage = self:ExtrapolatedDamage(creep, time_to_damage);
    if (extrapolated_damage < bot_damage) then
      extrapolated_damage = 0;
    end
    local total_damage = bot_damage + creep:GetActualIncomingDamage(extrapolated_damage, DAMAGE_TYPE_PHYSICAL);
    return creep:GetHealth() < total_damage
  end
  return false;
end

function M:CreepWithNHitsOfHealth(range, enemy, ally, hits)
  if ((enemy and ally) == false) then return nil end;
  local bot = GetBot();
  if (enemy) then
    local enemy_creeps = FGetNearbyCreeps(range, true);
    for _,creep in pairs(enemy_creeps) do
      if (self:CreepHasLessHealthThanNHits(bot, creep, hits)) then
        return creep;
      end
    end
  end

  if (ally) then
    local ally_creeps = FGetNearbyCreeps(range, false);
    for _,creep in pairs(ally_creeps) do
      if (self:CreepHasLessHealthThanNHits(bot, creep, hits)) then
        return creep;
      end
    end
  end

  return nil;
end

function M:isAttackedByCreeps()
  return (GetBot():TimeSinceDamagedByTower() < 1 or GetBot():TimeSinceDamagedByCreep() < 0.5); -- ok
end

function M:WeakestCreep(range, ally)
  local bot = GetBot();
  local creeps = FGetNearbyCreeps(range, true);
  if (ally) then
    local ally_creeps = FGetNearbyCreeps(range, false);
    for k,v in pairs(ally_creeps) do creeps[k] = v end
  end
  local lowest_hp = VERY_HIGH_INT;
  local weakest_creep = nil;
  for creep_k,creep in pairs(creeps)
  do
      if(creep:IsAlive()) then
          local creep_hp = creep:GetHealth();
          if(lowest_hp > creep_hp) then
               lowest_hp = creep_hp;
               weakest_creep = creep;
          end
      end
  end
  return weakest_creep;
end

function M:GetCreepTeam(creep)
  if ((string.find(creep:GetUnitName(), "goodguys") ~= nil)) then
    return TEAM_RADIANT;
  elseif ((string.find(creep:GetUnitName(), "badguys") ~= nil)) then
    return TEAM_DIRE;
  else
    return -100;
  end
end

return M;
