local M = {}
----------------------------------------------
local DotaBotUtility  = require(GetScriptDirectory().."/dev/utility");
local Creeping        = require(GetScriptDirectory().."/dev/state/creeping");
local UnitHelper      = require(GetScriptDirectory().."/dev/helper/unit_helper");
local VectorHelper    = require(GetScriptDirectory().."/dev/helper/vector_helper");
----------------------------------------------
----------------------------------------------
M.STATE_WALK_TO_CREEPS = "STATE_WALK_TO_CREEPS";
M.STATE_ATTACK_CREEP = "STATE_ATTACK_CREEP"
M.STATE_AGRO_OFF = "STATE_AGRO_OFF";
----------------------------------------------
-- Some Shitty CONSTANTS I made up
M.TOWER_POWER = 600;
M.SAFETY = 0.2;
M.ENEMY_RANGE_REWARD = 12;
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
M.HEALTH_FACTOR = 1.25;
----------------------------------------------
function M:GetComfortPoint(BotInfo)
  local bot = GetBot();
  local pos = bot:GetLocation();
  local new_pos_x = 0;
  local new_pos_y = 0;
  local allNil = true;

  local range  = bot:GetAttackRange();
  local enemy_creeps = bot:GetNearbyCreeps(self.SEARCH_RANGE, true);
  local ally_creeps = bot:GetNearbyCreeps(self.SEARCH_RANGE, false);
  local tower = DotaBotUtility:GetFrontTowerAt(UnitHelper:GetUnitLane(bot));
  local enemy_tower = DotaBotUtility:GetEnemyFrontTowerAt(UnitHelper:GetUnitLane(bot));
  local positions_count = 0;
  local power_balance = 0;
  local enemy_power = 0;
  local total_power = 0;
  local dangerVector = Vector(0, 0);

  -- Enemy Creep Vector
  for _,creep in pairs(enemy_creeps)
  do
    if (creep:IsAlive()) then
      allNil = false;

      DotaBotUtility:UpdateCreepHealth(creep);
      local creep_pos = creep:GetLocation();
      local creep_distance = GetUnitToLocationDistance(bot, creep_pos);
      local isMelee = (string.find(creep:GetUnitName(), "melee") ~= nil);
      -- base power
      local power = isMelee and self.MELEE_POWER or self.RANGE_POWER;
      -- power is exp-distanced
      power = power * math.pow((1-creep_distance/self.SEARCH_RANGE), self.CREEP_POWER_EXP);
      power_balance = power_balance - power;
      total_power = total_power + power;
      enemy_power = enemy_power + power;
      -- danger vector goes AWAY from its soource
      dangerVector[1] = dangerVector[1] + (pos[1] - creep_pos[1]);
      dangerVector[2] = dangerVector[2] + (pos[2] - creep_pos[2]);
      -- base reward
      local base_reward = isMelee and self.ENEMY_MELEE_REWARD or self.ENEMY_RANGE_REWARD;
      -- reward f(how low it is, how much dps it gets)
      local reward = base_reward * math.pow(2 - (creep:GetHealth() / creep:GetMaxHealth()), self.HEALTH_PERCENTAGE_POWER) * math.abs(DotaBotUtility:GetCreepHealthDeltaPerSec(creep, 1.5))/self.NORMAL_DELTA_DROP;
      -- reward potential (even if creeps not hit)
      reward = reward + base_reward * self.POTENTIAL;
      -- less reward if hero already close enough
      local distance = creep_distance;
      if (distance < range) then
        reward = reward * distance/range;
      end
      -- result
      new_pos_x = new_pos_x + reward * creep_pos[1];
      new_pos_y = new_pos_y + reward * creep_pos[2];
      positions_count = positions_count + reward;
    end
  end
  -- Enemy Tower
  if (enemy_tower ~= nil and (GetUnitToUnitDistance(bot, enemy_tower)) < 700) then
    power_balance = power_balance - self.TOWER_POWER;
  end
  -- Ally Creep Vector
  for _,creep in pairs(ally_creeps)
  do
    if (creep:IsAlive()) then
      allNil = false;

      DotaBotUtility:UpdateCreepHealth(creep);
      local creep_pos = creep:GetLocation();
      local creep_distance = GetUnitToLocationDistance(bot, creep_pos);
      local isMelee = (string.find(creep:GetUnitName(), "melee") ~= nil);
      -- reward for deny this creep
      local base_reward = isMelee and self.ALLY_MELEE_DENY_REWARD or self.ALLY_RANGE_DENY_REWARD;
      -- reward f(how low it is, how much dps it gets)
      local reward = base_reward * math.pow(2 - (creep:GetHealth() / creep:GetMaxHealth()), self.HEALTH_PERCENTAGE_POWER) * math.abs(DotaBotUtility:GetCreepHealthDeltaPerSec(creep, 1.5))/self.NORMAL_DELTA_DROP;
      -- reward potential (even if creeps not hit)
      reward = reward + base_reward * self.POTENTIAL;
      -- creep power
      local power = isMelee and self.MELEE_POWER or self.RANGE_POWER;
      -- creep power is exp-distanced
      power = power * math.pow((1-creep_distance/self.SEARCH_RANGE), self.CREEP_POWER_EXP);
      power_balance = power_balance + power;
      total_power = total_power + power;
      -- less reward if hero already close enough
      local distance = creep_distance;
      if (distance < range) then
        reward = reward * distance/range;
      end
      -- lets stick to our mighty allies
      reward = reward + power;
      -- result
      new_pos_x = new_pos_x + reward * creep_pos[1];
      new_pos_y = new_pos_y + reward * creep_pos[2];
      positions_count = positions_count + reward;
    end
  end
  -- Tower Vector
  if (tower ~= nil) then
    allNil = false;

    local tower_pos = tower:GetLocation();
    -- basic safety
    local reward = self.TOWER_POWER * self.SAFETY;
    -- sefety when shit goes bad
    if (power_balance < 0) then
       reward = reward + self.TOWER_POWER * -1 * (power_balance/total_power);
    end
    -- safety from low hp
    reward = reward + Max(0, self.HEALTH_FACTOR * enemy_power - bot:GetHealth());
    -- result
    new_pos_x = new_pos_x + reward * tower_pos[1];
    new_pos_y = new_pos_y + reward * tower_pos[2];
    positions_count = positions_count + reward;
  end
  -- Danger Vector
  if (power_balance < 0) then
    dangerVector = VectorHelper:Normalize(dangerVector);
    local danger_pos_x = pos[1] + dangerVector[1] * 200;
    local danger_pos_y = pos[2] + dangerVector[2] * 200;
    -- danger is applied when we already near tower but still need to run away
    local reward = power_balance * Max(0, (700 - GetUnitToUnitDistance(bot, tower))/700) * self.DANGER;
    -- result
    new_pos_x = new_pos_x + reward * danger_pos_x;
    new_pos_y = new_pos_y + reward * danger_pos_y;
    positions_count = positions_count + reward;
    DebugDrawLine(pos, Vector(danger_pos_x, danger_pos_y, bot:GetGroundHeight()), 255, 0, 0);
  end
  -- result pos
  local res_x = new_pos_x / positions_count;
  local res_y = new_pos_y / positions_count;
  local res_vec = Vector(res_x, res_y);
  if (allNil) then
    return nil;
  else
    return res_vec;
  end
end
--------------------------------------------------
function M.StateWalkToCreeps(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  local comfort_point = self:GetComfortPoint(BotInfo);
  if (comfort_point ~= nil) then
    target = Creeping:CreepWithNHitsOfHealth(1000, true, true, 1);
    if (target ~= nil) then
      self.StateMachine.State = self.STATE_ATTACK_CREEP;
    else
      if (Creeping:isAttackedByCreeps(BotInfo)) then
        self.StateMachine.State = self.STATE_AGRO_OFF;
      else
        bot:Action_MoveToLocation(comfort_point); -- stick to creeps
        -- Debug
        DebugDrawCircle(Vector(comfort_point[1], comfort_point[2], bot:GetGroundHeight()), 20, 0, 255, 0);
        DebugDrawLine(bot:GetLocation(), Vector(comfort_point[1], comfort_point[2], bot:GetGroundHeight()), 0, 255, 0);
      end
    end
  end
end

function M.StateAttackCreep(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  target = Creeping:CreepWithNHitsOfHealth(1000, true, true, 1)
  if (target ~= nil) then
    bot:Action_AttackUnit(target, false);
  else
    self.StateMachine.State = self.STATE_WALK_TO_CREEPS;
  end
end

function M.StateAgroOff(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  local comfort_point = Creeping:AgroOffVec(BotInfo);
  if (comfort_point ~= nil) then
    bot:Action_MoveToLocation(comfort_point); -- stick to creeps
  end
  if (not Creeping:isAttackedByCreeps(BotInfo)) then
    self.StateMachine.State = self.STATE_WALK_TO_CREEPS;
  end
end
-------------------------------------------------
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
