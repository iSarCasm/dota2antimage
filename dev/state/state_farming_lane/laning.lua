local Laning = {};
---------------------------------------------
local Creeping        = require(GetScriptDirectory().."/dev/state/state_farming_lane/creeping");
local BotActions      = require(GetScriptDirectory().."/dev/bot_actions");
local Danger         	= require(GetScriptDirectory().."/dev/danger/danger");
local VectorHelper    = require(GetScriptDirectory().."/dev/helper/vector_helper");
local HeroHelper      = require(GetScriptDirectory().."/dev/helper/hero_helper");
local UnitHelper      = require(GetScriptDirectory().."/dev/helper/unit_helper");
local DotaBotUtility  = require(GetScriptDirectory().."/dev/utility");
---------------------------------------------
function Laning:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
--------------------------------------------------------
-- float 0..1 where 0 is closest to creeps to get best LH and 1 is EXP-only range
function Laning:GetHeroBalance()
  local myself = GetBot();
  local my_power = HeroHelper:LaningDefensivePower(myself);
  local enemy_power = 0;
  local enemy_heroes = myself:GetNearbyHeroes(1500, true, BOT_MODE_NONE);
  for _, hero in pairs(enemy_heroes) do
    enemy_power = enemy_power +  HeroHelper:LaningOffensivePower(hero, myself);
  end
  local total_power = my_power + enemy_power;
  return 1 - (my_power / (enemy_power + my_power));
end

function Laning:WorthWaitingForLhThere(vec)
  return true;
end

function Laning:PrepareForLhVector()
  local bot = GetBot();
  local start_range = 200;                        -- 200 -> 200, 700 -> 200
  local end_range = bot:GetAttackRange() + 400;   -- 200 -> 600, 700 -> 1100
  for try_range = start_range, end_range, 100 do
    local reward_vec = self.weak:GetLocation() + VectorHelper:Normalize(Danger:SafestLocation(bot) - self.weak:GetLocation()) * try_range;
    if (self:WorthWaitingForLhThere(reward_vec)) then
      return reward_vec;
    end
  end
  return nil;
end

function Laning:ClosestAllyToVector(vec)
  local closest_range = VERY_HIGH_INT;
  local closest = nil;
  for i = 1, #Creeping.ally_creeps do
    local creep = Creeping.ally_creeps[i];
    local dist = GetUnitToLocationDistance(creep, vec);
    if (dist < closest_range) then
      closest_range = dist;
      closest = creep;
    end
  end
  return closest;
end

function Laning:GetComfortPoint(BotInfo)
  local bot = GetBot();
  -- DebugDrawText(500, 100, "Balance is "..hero_balance, 255, 255, 255);
  if (Creeping.allyVector and self.weak and self.weak:IsAlive() and self.weak:GetHealth() < self:PrepareForLhHealth(bot, self.weak)) then -- time to get really close and wait for that juicy lash hit
    print("really low! "..self:PrepareForLhHealth(bot, self.weak));
    local prepare_for_lh_vec = self:PrepareForLhVector(); 
    if (prepare_for_lh_vec) then
      DebugDrawCircle(prepare_for_lh_vec, 25, 0, 0 ,255);
      return prepare_for_lh_vec;
    end
  end

  if (Creeping.enemyVector and Creeping.allyVector) then -- chilling behind creeps
    local middleVector = (Creeping.enemyVector + Creeping.allyVector) / 2;
    local closest_to_middle_ally_vector = self:ClosestAllyToVector(middleVector):GetLocation();
    local closest_range = 250;
    local exp_only_range = 1200;
    local delta_range = exp_only_range - closest_range;
    local middle_to_safest_vec = VectorHelper:Normalize(Danger:SafestLocation(bot) - closest_to_middle_ally_vector);
    -- print("m is "..(closest_range + delta_range * hero_balance));
    local hero_balance = self:GetHeroBalance();
    local result_vector = closest_to_middle_ally_vector + middle_to_safest_vec * (closest_range + delta_range * hero_balance);
    DebugDrawCircle(closest_to_middle_ally_vector, 25, 0, 255 ,255);
    DebugDrawLine(closest_to_middle_ally_vector, result_vector, 0, 255 ,255);
    return result_vector;
  elseif (Creeping.enemyVector) then    -- run from creeps!
    return Danger:SafestLocation(bot);
  elseif (Creeping.allyVector) then     -- follow allies!
    return Creeping.allyVector;
  else
    return GetFront(GetTeam(), self.Lane);  -- go to lane's front
  end
end

function Laning:PrepareForLhHealth(bot, creep)
  local time_to_get_in_range = UnitHelper:TimeToGetInRange(bot, creep)
  local creep_health_delta = DotaBotUtility:GetCreepHealthDeltaPerSec(creep, 2);
  local single_hit_damage = Creeping:GetPhysDamageToCreep(bot, creep);
  return single_hit_damage * 2 + (time_to_get_in_range + 1) * creep_health_delta; -- we want to get close 1 SECOND + 1 hit earlier it requires for last hit
end
---------------------------------------------
function Laning.EvaluateHarassing(self)
  return 0;
end

function Laning.EvaluateBackoff(self)
  if (GetBot():TimeSinceDamagedByTower() < 1) then
    return 10;
  elseif (GetBot():TimeSinceDamagedByCreep() < 0.25) then
    return 5;
  end
  return 0;
end

function Laning.EvaluateLastHit(self)
  return 1; -- default
end

function Laning.EvaluateAttackTower(self)
  return 0;
end

function Laning.EvaluateLaneBalance(self)
  return 0;
end

function Laning.EvaluateAgroCreeps(self)
  return 0;
end
---------------------------------------------
function Laning.Harassing(self)

end

function Laning.Backoff(self)
  local bot = GetBot();
  bot:Action_MoveToLocation(Danger:SafestLocation(bot));
end

function Laning.LastHit(self, BotInfo)
  local bot = GetBot();
  local position = self:GetComfortPoint(BotInfo);
  local back_vector = VectorHelper:Normalize(Danger:SafestLocation(bot) - bot:GetLocation()) * 25;
  local dist = GetUnitToLocationDistance(bot, position);
  self.very_low_creep = Creeping:CreepWithNHitsOfHealth(1000, true, true, 1);
  self.kinda_low_creep = Creeping:CreepWithNHitsOfHealth(1000, true, true, 3);
  self.weak = Creeping:WeakestCreep(1000, false, true);
  local no_heroes_near = true; -- TODO

  if (self.kinda_low_creep) then
    -- print("kinda delta "..DotaBotUtility:GetCreepHealthDeltaPerSec(self.kinda_low_creep, 2));
    DebugDrawCircle(self.kinda_low_creep:GetLocation(), 20, 255, 0, 0);
  end

  if (self.weak) then
    -- print("self.weak delta "..DotaBotUtility:GetCreepHealthDeltaPerSec(self.weak, 2));
    DebugDrawCircle(self.weak:GetLocation(), 20, 255, 255, 0);
  end

  DebugDrawCircle(position + back_vector, 10, 244, 244 ,244);
  if (dist > 800) then
    print("really far from comfort");
    bot:Action_MoveToLocation(position + back_vector);
  elseif (self.very_low_creep) then
    print("last hit!");
    bot:Action_AttackUnit(self.very_low_creep, false);
  elseif (self.kinda_low_creep and DotaBotUtility:GetCreepHealthDeltaPerSec(kinda_low_creep, 2) == 0 and no_heroes_near) then
    print("kinda low");
    bot:Action_AttackUnit(self.kinda_low_creep, false);
  elseif (dist > 150) then
    print("get a bit closer");
    bot:Action_MoveToLocation(position + back_vector);
  elseif (self.weak and self.weak:GetHealth() < 250 and DotaBotUtility:GetCreepHealthDeltaPerSec(self.weak, 2) > 0 and (not UnitHelper:IsFacingEntity(bot, self.weak, 10))) then
    print("rotate");
    BotActions.RotateTowards:Call(self.weak:GetLocation());
  end
end

function Laning.AttackTower(self)

end

function Laning.LaneBalance(self)

end

function Laning.AgroCreeps(self)

end
---------------------------------------------
Laning.HARASSING    = "HARASSING";
Laning.BACKOFF      = "BACKOFF";
Laning.LASTHIT      = "LASTHIT";
Laning.ATTACK_TOWER = "ATTACK_TOWER";
Laning.LANE_BALANCE = "LANE_BALANCE";
Laning.AGRO_CREEPS  = "AGRO_CREEPS";
Laning.StateMachine = {}
Laning.StateMachine[Laning.HARASSING]     = Laning.Harassing;
Laning.StateMachine[Laning.BACKOFF]       = Laning.Backoff;
Laning.StateMachine[Laning.LASTHIT]       = Laning.LastHit;
Laning.StateMachine[Laning.ATTACK_TOWER]  = Laning.AttackTower;
Laning.StateMachine[Laning.LANE_BALANCE]  = Laning.LaneBalance;
Laning.StateMachine[Laning.AGRO_CREEPS]   = Laning.AgroCreeps;
Laning.StateMachine.State = Laning.LASTHIT;
---------------------------------------------
function Laning:UpdateState()
  local bot = GetBot();
  local evals = {};
  local table = { self.HARASSING, self.BACKOFF, self.LASTHIT, self.ATTACK_TOWER, self.LANE_BALANCE, self.AGRO_CREEPS };
  evals[self.HARASSING] = self.EvaluateHarassing(self);
  evals[self.BACKOFF] = self.EvaluateBackoff(self);
  evals[self.LASTHIT] = self.EvaluateLastHit(self);
  evals[self.ATTACK_TOWER] = self.EvaluateAttackTower(self);
  evals[self.LANE_BALANCE] = self.EvaluateLaneBalance(self);
  evals[self.AGRO_CREEPS] = self.EvaluateAgroCreeps(self);
  local highest_eval = VERY_LOW_INT;
  local highest = nil;
  for i = 1, #table do
    local eval = table[i];
    if (evals[eval] > highest_eval) then
      highest_eval = evals[eval];
      highest = eval;
    end
  end
  self.StateMachine.State = highest;
end
---------------------------------------------
function Laning:Run(Farming, BotInfo, Mode, Strategy)
  self.Lane = Farming.Lane;
  Creeping:UpdateLaningState();
  self:UpdateState();
  self.StateMachine[self.StateMachine.State](self, BotInfo, Mode, Strategy);

  -- if (Creeping.enemyVector) then DebugDrawCircle(Creeping.enemyVector, 15, 255, 0, 0) end;
  -- if (Creeping.allyVector) then DebugDrawCircle(Creeping.allyVector, 15, 0, 255, 0) end;
  -- DebugDrawLine(GetBot():GetLocation(), Danger:SafestLocation(GetBot()), 0, 0, 255);
  -- DebugDrawCircle(Danger:SafestLocation(GetBot()), 15, 0, 0 ,255);
  -- DebugDrawCircle(GetFront(GetTeam(), BotInfo.LANE), 15, 255, 255 ,255);
end
---------------------------------------------
return Laning;
