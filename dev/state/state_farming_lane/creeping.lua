local M = {};
----------------------------------------------
local DotaBotUtility  = require(GetScriptDirectory().."/dev/utility");
local UnitHelper      = require(GetScriptDirectory().."/dev/helper/unit_helper");
local VectorHelper    = require(GetScriptDirectory().."/dev/helper/vector_helper");
----------------------------------------------
M.TOWER_POWER = 400;
M.MELEE_POWER = 45;
M.RANGE_POWER = 80;
function M:UpdateLaningState()
  local bot = GetBot();
  local pos = bot:GetLocation();

  self.enemy_creeps = bot:GetNearbyCreeps(1500, true);
  self.ally_creeps = bot:GetNearbyCreeps(1500, false);
  self.tower = DotaBotUtility:GetFrontTowerAt(UnitHelper:GetUnitLane(bot));
  self.enemy_tower = DotaBotUtility:GetEnemyFrontTowerAt(UnitHelper:GetUnitLane(bot));

  local power_balance = 0;
  local enemy_power = 0;
  local ally_power = 0;
  local total_power = 1;
  self.enemyVector = Vector(0, 0);
  self.allyVector = Vector(0, 0);
  self.towerVector = Vector(0, 0);

  -- Enemy Creep Vector
  local positions_count = 0;
  for _,creep in pairs(self.enemy_creeps)
  do
    if (creep:IsAlive()) then
      allNil = false;
      DotaBotUtility:UpdateCreepHealth(creep);
      local creep_pos = creep:GetLocation();
      local isMelee = (string.find(creep:GetUnitName(), "melee") ~= nil);
      local power = isMelee and self.MELEE_POWER or self.RANGE_POWER;
      power_balance = power_balance - power;
      total_power = total_power + power;
      enemy_power = enemy_power + power;
      -- result
      self.enemyVector[1] = self.enemyVector[1] + creep_pos[1];
      self.enemyVector[2] = self.enemyVector[2] + creep_pos[2];
      positions_count = positions_count + 1;
    end
  end
  if (positions_count > 0) then
    self.enemyVector[1] = self.enemyVector[1] / positions_count;
    self.enemyVector[2] = self.enemyVector[2] / positions_count;
  else
    self.enemyVector = nil;
  end
  -- Enemy Tower
  if (self.enemy_tower and (GetUnitToUnitDistance(bot, self.enemy_tower)) < 950) then
    power_balance = power_balance - self.TOWER_POWER;
  end
  -- Ally Creep Vector
  positions_count = 0;
  for _,creep in pairs(self.ally_creeps)
  do
    if (creep:IsAlive()) then
      allNil = false;
      DotaBotUtility:UpdateCreepHealth(creep);
      local creep_pos = creep:GetLocation();
      local isMelee = (string.find(creep:GetUnitName(), "melee") ~= nil);
      local power = isMelee and self.MELEE_POWER or self.RANGE_POWER;
      power_balance = power_balance + power;
      total_power = total_power + power;
      ally_power = ally_power + power;
      -- result
      self.allyVector[1] = self.allyVector[1] + creep_pos[1];
      self.allyVector[2] = self.allyVector[2] + creep_pos[2];
      positions_count = positions_count + 1;
    end
  end
  if (positions_count > 0) then
    self.allyVector[1] = self.allyVector[1] / positions_count;
    self.allyVector[2] = self.allyVector[2] / positions_count;
  else
    self.allyVector = nil;
  end
  -- Tower Vector
  if (self.tower) then
    allNil = false;
    local tower_pos = self.tower:GetLocation();
    -- result
    self.towerVector[1] = tower_pos[1];
    self.towerVector[2] = tower_pos[2];
  else
    self.towerVector = nil;
  end
end

function M:ExtrapolatedDamage(creep, time)
  return Max(DotaBotUtility:GetCreepHealthDeltaPerSec(creep, time) * 0.5, 0);
end

function M:GetPhysDamageToCreep(bot, creep)
  local isMelee = (string.find(creep:GetUnitName(), "melee") ~= nil);
  return UnitHelper:GetPhysDamageToUnit(bot, creep, true, (not isMelee));
end

function M:CreepWithNHitsOfHealth(range, enemy, ally, hits)
  if ((enemy and ally) == false) then return nil end;
  local bot = GetBot();
  local BotInfo = bot.flex_bot.botInfo;
  if (enemy) then
    local enemy_creeps = bot:GetNearbyCreeps(range, true);
    for _,creep in pairs(enemy_creeps)
    do
      if (creep:IsAlive()) then
        local bot_damage = self:GetPhysDamageToCreep(bot, creep);
        local time_to_damage = UnitHelper:TimeToGetInRange(bot, creep) + UnitHelper:TimeOnAttacks(bot, hits) + UnitHelper:ProjectileTimeTravel(bot, creep, BotInfo.projectileSpeed) * hits;
        local extrapolated_damage = self:ExtrapolatedDamage(creep, time_to_damage);
        if (extrapolated_damage < bot_damage) then
          extrapolated_damage = 0;
        end
        local total_damage = bot_damage + creep:GetActualIncomingDamage(extrapolated_damage, DAMAGE_TYPE_PHYSICAL);
        if (creep:GetHealth() < total_damage) then
          -- print("My  Damage: "..bot_damage);
          -- print("Ext Damage: "..extrapolated_damage);
          -- print("Sum Damage: "..total_damage);
          -- print("Time: "..time_to_damage);
          return creep;
        end
      end
    end
  end

  if (ally) then
    local ally_creeps = bot:GetNearbyCreeps(range, false);
    for _,creep in pairs(ally_creeps)
    do
      if (creep:IsAlive()) then
        local bot_damage = self:GetPhysDamageToCreep(bot, creep);
        local time_to_damage = UnitHelper:TimeToGetInRange(bot, creep) + UnitHelper:TimeOnAttacks(bot, hits) + 2.5 * UnitHelper:ProjectileTimeTravel(bot, creep, BotInfo.projectileSpeed) * hits;
        local extrapolated_damage = self:ExtrapolatedDamage(creep, time_to_damage);
        if (extrapolated_damage < bot_damage) then
          extrapolated_damage = 0;
        end
        local total_damage = bot_damage + creep:GetActualIncomingDamage(extrapolated_damage, DAMAGE_TYPE_PHYSICAL);
        if (creep:GetHealth() < total_damage) then
          return creep;
        end
      end
    end
  end

  return nil;
end

function M:AgroOffVec()
  local bot = GetBot();
  local lane = UnitHelper:GetUnitLane(bot);
  local tower = DotaBotUtility:GetFrontTowerAt(lane);
  return bot:GetLocation() + (VectorHelper:Normalize(tower:GetLocation() - bot:GetLocation()) * 400); -- walk back range
end

function M:isAttackedByCreeps()
  return (GetBot():TimeSinceDamagedByTower() < 1 or GetBot():TimeSinceDamagedByCreep() < 0.5); -- ok
end

function M:WeakestCreep(range, ally, withDelta)
  local bot = GetBot();
  local creeps = bot:GetNearbyCreeps(range, true);
  if (ally) then
    local ally_creeps = bot:GetNearbyCreeps(range, false);
    for k,v in pairs(ally_creeps) do creeps[k] = v end
  end
  local lowest_hp = VERY_HIGH_INT;
  local weakest_creep = nil;
  for creep_k,creep in pairs(creeps)
  do
      if(creep:IsAlive() and ((not withDelta) or (DotaBotUtility:GetCreepHealthDeltaPerSec(creep, 2) > 0))) then
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
