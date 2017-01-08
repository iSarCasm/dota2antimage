local M = {}
----------------------------------------------
local BotActions      = require(GetScriptDirectory().."/dev/bot_actions");
local DotaBotUtility  = require(GetScriptDirectory().."/dev/utility");
local Creeping        = require(GetScriptDirectory().."/dev/state/state_farming_lane/creeping");
local UnitHelper      = require(GetScriptDirectory().."/dev/helper/unit_helper");
local VectorHelper    = require(GetScriptDirectory().."/dev/helper/vector_helper");
----------------------------------------------
----------------------------------------------
M.STATE_WALK_TO_CREEPS  = "STATE_WALK_TO_CREEPS";
M.STATE_ATTACK_CREEP    = "STATE_ATTACK_CREEP"
M.STATE_AGRO_OFF        = "STATE_AGRO_OFF";
----------------------------------------------
-- Some Shitty CONSTANTS I made up
M.TOWER_POWER = 800;
M.TOWER_DANGER = 400;
M.SAFETY = 0.25;
M.LOW_HEALTH = 400;
M.ENEMY_RANGE_REWARD = 14;
M.ENEMY_MELEE_REWARD = 8;
M.HEALTH_PERCENTAGE_POWER = 9;
M.ALLY_RANGE_DENY_REWARD = 20;
M.ALLY_MELEE_DENY_REWARD = 10;
M.MELEE_POWER = 90;
M.RANGE_POWER = 170;
M.SEARCH_RANGE = 1500;
M.CREEP_POWER_EXP = 2;
M.DANGER = 60;
M.NORMAL_DELTA_DROP = 40;
M.POTENTIAL = 3;
M.HEALTH_FACTOR = 1.75;
M.ADDITIONAL_RANGE = 40;
M.MIN_RANGE = 180;
M.FAR_RANGE_ADD = 350;
----------------------------------------------
function M:GetComfortPoint(BotInfo)
  local bot = GetBot();
  local pos = bot:GetLocation();
  local new_pos_x = 0;
  local new_pos_y = 0;
  local allNil = true;

  local range  = bot:GetAttackRange() + self.ADDITIONAL_RANGE;
  local enemy_creeps = bot:GetNearbyCreeps(self.SEARCH_RANGE, true);
  local ally_creeps = bot:GetNearbyCreeps(self.SEARCH_RANGE, false);
  local tower = DotaBotUtility:GetFrontTowerAt(UnitHelper:GetUnitLane(bot));
  local enemy_tower = DotaBotUtility:GetEnemyFrontTowerAt(UnitHelper:GetUnitLane(bot));

  local power_balance = 0;
  local enemy_power = 0;
  local ally_power = 0;
  local total_power = 1;

  self.enemyVector = Vector(0, 0);
  self.allyVector = Vector(0, 0);
  self.towerVector = Vector(0, 0);
  resultVector = Vector(0, 0);

  -- Enemy Creep Vector
  local positions_count = 0;
  for _,creep in pairs(enemy_creeps)
  do
    if (creep:IsAlive()) then
      allNil = false;
      DotaBotUtility:UpdateCreepHealth(creep);
      local creep_pos = creep:GetLocation();
      local isMelee = (string.find(creep:GetUnitName(), "melee") ~= nil);
      local creep_distance = GetUnitToUnitDistance(bot, creep);
      -- base power
      local power = isMelee and self.MELEE_POWER or self.RANGE_POWER;
      -- power is exp-distanced
      -- power = power * math.pow((1-creep_distance/self.SEARCH_RANGE), self.CREEP_POWER_EXP);
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
  end
  -- Enemy Tower
  if (enemy_tower and (GetUnitToUnitDistance(bot, enemy_tower)) < 950) then
    power_balance = power_balance - self.TOWER_POWER;
  end
  -- Ally Creep Vector
  positions_count = 0;
  for _,creep in pairs(ally_creeps)
  do
    if (creep:IsAlive()) then
      allNil = false;
      DotaBotUtility:UpdateCreepHealth(creep);
      local creep_pos = creep:GetLocation();
      local isMelee = (string.find(creep:GetUnitName(), "melee") ~= nil);
      local creep_distance = GetUnitToUnitDistance(bot, creep);
      -- creep power
      local power = isMelee and self.MELEE_POWER or self.RANGE_POWER;
      -- creep power is exp-distanced
      -- power = power * math.pow((1-creep_distance/self.SEARCH_RANGE), self.CREEP_POWER_EXP);
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
  end
  -- Tower Vector
  if (tower) then
    allNil = false;
    local tower_pos = tower:GetLocation();
    -- result
    self.towerVector[1] = tower_pos[1];
    self.towerVector[2] = tower_pos[2];
  end
  if (allNil) then
    return nil;
  end
  -- result pos
  local middleVector = (self.enemyVector + self.allyVector) / 2;
  DebugDrawText(25, 300, "balance "..power_balance, 255, 255, 255);
  if (ally_power <= 0) then -- no ally
    if (tower and GetUnitToUnitDistance(bot, tower) > 400) then
      -- go to tower
      resultVector = self.towerVector;
    elseif (power_balance < 0) then
      -- run from them
      resultVector = self.enemyVector + VectorHelper:Normalize((pos - self.enemyVector)) * Min(range, self.MIN_RANGE);
    else -- no enemies either
      resultVector = self.towerVector;
    end
  else
    local min = Min(range+self.FAR_RANGE_ADD, self.MIN_RANGE);
    local max = Max(range+self.FAR_RANGE_ADD, self.MIN_RANGE);
    local hp_factor = Max(1+2*(Max(self.LOW_HEALTH - bot:GetHealth(),0)/self.LOW_HEALTH), 1);
    local clamp1 = Max(hp_factor * (self.SAFETY-power_balance/total_power) * (min+max), 0);
    local clamp2 = Max(hp_factor * (self.SAFETY-power_balance/total_power) * (min+max), min);
    -- hide behind ally
    if (enemy_power > 0) then
      resultVector = middleVector + (VectorHelper:Normalize((self.allyVector - self.enemyVector)) * clamp1);
    else
      resultVector = self.allyVector + (VectorHelper:Normalize((self.allyVector - self.enemyVector)) * clamp2);
    end
    -- DebugDrawText(25, 260, "power_balance: "..power_balance,255,255,255);
    -- DebugDrawText(25, 280, "clamp: "..self.SAFETY-power_balance/total_power,255,255,255);
    -- DebugDrawText(25, 300, "fallback: "..clamp, 255, 255, 255);
  end
  return resultVector;
end
--------------------------------------------------
function M.StateWalkToCreeps(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  local comfort_point = self:GetComfortPoint(BotInfo);
  local lane = UnitHelper:GetUnitLane(bot);
  local tower = DotaBotUtility:GetFrontTowerAt(lane);

  target = Creeping:CreepWithNHitsOfHealth(1000, true, true, 1);
  if (target) then
    self.StateMachine.State = self.STATE_ATTACK_CREEP;
    return;
  end

  if (comfort_point) then
    if (Creeping:isAttackedByCreeps() and GetUnitToUnitDistance(bot, tower) > 600) then
      self.StateMachine.State = self.STATE_AGRO_OFF;
      return;
    else
      local dist = GetUnitToLocationDistance(bot, comfort_point);
      if (dist > 250) then
        BotActions.ActionMoveToLocation:Call(comfort_point);
      elseif (dist < 200) then
        local weak = Creeping:WeakestCreep(1000, false);
        if (weak) then
          if (not UnitHelper:IsFacingEntity(bot, weak, 10)) then
            BotActions.ActionCancelAttack:Call(weak);
          end
        end
      end
      -- Debug
      DebugDrawCircle(Vector(comfort_point[1], comfort_point[2], bot:GetGroundHeight()), 20, 0, 255, 0);
      DebugDrawLine(bot:GetLocation(), Vector(comfort_point[1], comfort_point[2], bot:GetGroundHeight()), 0, 255, 0);
    end
  end
end

function M.StateAttackCreep(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  target = Creeping:CreepWithNHitsOfHealth(1000, true, true, 1)
  if (target and (not self.DangerUnderTower())) then
    BotActions.ActionAttackUnit:Call(target, false);
  else
    self.StateMachine.State = self.STATE_WALK_TO_CREEPS;
  end
end

function M.StateAgroOff(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  local comfort_point = Creeping:AgroOffVec(BotInfo);
  local lane = UnitHelper:GetUnitLane(bot);
  local tower = DotaBotUtility:GetFrontTowerAt(lane);

  target = Creeping:CreepWithNHitsOfHealth(1000, true, true, 1);
  if (target) then
    self.StateMachine.State = self.STATE_ATTACK_CREEP;
    return;
  end

  if (comfort_point) then
    BotActions.ActionMoveToLocation:Call(comfort_point);
  end
  if (not Creeping:isAttackedByCreeps() or GetUnitToUnitDistance(bot, tower) < 700) then
    self.StateMachine.State = self.STATE_WALK_TO_CREEPS;
  end
end
-------------------------------------------------
function M.DangerUnderTower()
  local enemy_tower = DotaBotUtility:GetEnemyFrontTowerAt(UnitHelper:GetUnitLane(bot));
  if (enemy_tower) then
    if (GetUnitToUnitDistance(GetBot(), enemy_tower) < 950) then
      local ally_creeps = enemy_tower:GetNearbyCreeps(950, false);
      local ally_m_creeps = {};
      if (ally_creeps) then
        for k,creep in pairs(ally_creeps)
        do
          local isMelee = (string.find(creep:GetUnitName(), "melee") ~= nil);
          if (isMelee) then
            ally_m_creeps[k] = creep;
          end
        end
        if (#ally_m_creeps < 2) then
          return true;
        end
      else
        return true
      end
    end
  end
  return false
end
-------------------------------------------------
M.StateMachine = {}
M.StateMachine.State = M.STATE_WALK_TO_CREEPS;
M.StateMachine[M.STATE_WALK_TO_CREEPS] = M.StateWalkToCreeps;
M.StateMachine[M.STATE_ATTACK_CREEP] = M.StateAttackCreep;
M.StateMachine[M.STATE_AGRO_OFF] = M.StateAgroOff;
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self.StateMachine[self.StateMachine.State](self, BotInfo, Mode, Strategy);
end

return M;
