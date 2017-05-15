local Laning = {};
---------------------------------------------
local Creeping        = require(GetScriptDirectory().."/dev/state/state_farming_lane/creeping");
local BotActions      = require(GetScriptDirectory().."/dev/bot_actions");
local Danger         	= require(GetScriptDirectory().."/dev/danger/danger");
local VectorHelper    = require(GetScriptDirectory().."/dev/helper/vector_helper");
local HeroHelper      = require(GetScriptDirectory().."/dev/helper/hero_helper");
local UnitHelper      = require(GetScriptDirectory().."/dev/helper/unit_helper");
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
  local enemy_heroes = FGetNearbyHeroes(1500, true);
  for _, hero in pairs(enemy_heroes) do
    enemy_power = enemy_power +  HeroHelper:LaningOffensivePower(hero, myself);
  end
  local total_power = my_power + enemy_power;
  return 1 - (my_power / (enemy_power + my_power));
end

function Laning:TryRange(min, max)
  local bot = GetBot();
  return min + (bot:GetMaxHealth() - bot:GetHealth()) / bot:GetMaxHealth() * (max-min);
end

function Laning:PrepareForLhVector()
  local bot = GetBot();
  local start_range = 200;                        -- 200 -> 200, 700 -> 200
  local end_range = bot:GetAttackRange() + 400;   -- 200 -> 600, 700 -> 1100
  local reward_vec = nil;
  local try_range = self:TryRange(200, 1100);
  return self.weak:GetLocation() + VectorHelper:Normalize(Danger:SafestLocation(bot) - self.weak:GetLocation()) * try_range;
end

function Laning:ClosestAllyToVector(vec)
  local botInfo = GetBot().botInfo;
  local closest_range = VERY_HIGH_INT;
  local closest = nil;
  for i = 1, #botInfo.ally_creeps do
    local creep = botInfo.ally_creeps[i];
    local dist = GetUnitToLocationDistance(creep, vec);
    if (dist < closest_range) then
      closest_range = dist;
      closest = creep;
    end
  end
  return closest;
end

function Laning:EnemyHeroAttackBackoffRange(loc)
  local heroes = GetBot().botInfo.enemy_heroes;
  local backoff_range = 0;
  for i = 1, #heroes do
    local hero = heroes[i];
    backoff_range = Max(backoff_range, hero:GetAttackRange() - GetUnitToLocationDistance(hero, loc))
  end
  return backoff_range;
end

function Laning:GetComfortPoint(BotInfo)
  local bot = GetBot();
  local botInfo = GetBot().botInfo;
  -- DebugDrawText(500, 100, "Balance is "..hero_balance, 255, 255, 255);
  if (botInfo.allyVector and self.weak and self.weak:IsAlive() and self.weak:GetHealth() < self:PrepareForLhHealth(bot, self.weak)) then -- time to get really close and wait for that juicy lash hit
    -- fprint("really low! "..self:PrepareForLhHealth(bot, self.weak));
    local prepare_for_lh_vec = self:PrepareForLhVector(); 
    if (prepare_for_lh_vec) then
      DebugDrawCircle(prepare_for_lh_vec, 25, 0, 0, 255);
      -- fprint("prepare for lh "..self:PrepareForLhHealth(bot, self.weak));
      return prepare_for_lh_vec;
    end
  end

  if (botInfo.enemyVector and botInfo.allyVector) then -- chilling behind creeps
    local middleVector = (botInfo.enemyVector + botInfo.allyVector) / 2;
    local closest_to_enemy_ally_vector = self:ClosestAllyToVector(botInfo.enemyVector):GetLocation();
    local closest_range = 250;
    local middle_to_safest_vec = VectorHelper:Normalize(Danger:SafestLocation(bot) - closest_to_enemy_ally_vector);
    -- local hero_balance = self:GetHeroBalance();
    -- fprint("m is "..(closest_range + delta_range * hero_balance));
    local backoff_range = self:EnemyHeroAttackBackoffRange(closest_to_enemy_ally_vector) + closest_range;
    local result_vector = closest_to_enemy_ally_vector + middle_to_safest_vec * backoff_range;
    fprint("backoff range "..backoff_range);
    DebugDrawCircle(closest_to_enemy_ally_vector,  35, 0, 255 ,255);
    DebugDrawLine(closest_to_enemy_ally_vector, result_vector, 0, 255 ,255);

    DebugDrawCircle(botInfo.enemyVector, 35, 255, 0 ,0);
    DebugDrawCircle(botInfo.allyVector, 35, 0, 255 ,0);
    return result_vector;
  elseif (botInfo.enemyVector) then    -- run from creeps!
    return Danger:SafestLocation(bot);
  elseif (botInfo.allyVector) then     -- follow allies!
    return botInfo.allyVector;
  else
    return GetFront(GetTeam(), self.Lane);  -- go to lane's front
  end
end

function Laning:PrepareForLhHealth(bot, creep)
  local time_to_get_in_range = UnitHelper:TimeToGetInRange(bot, creep)
  local single_hit_damage = Creeping:GetPhysDamageToCreep(bot, creep);
  return single_hit_damage * 4; -- we want to get close 4 hit earlier it requires for last hit
end
---------------------------------------------
function Laning.EvaluateLastHit(self)
  return 1; -- default
end

function Laning.EvaluateLaneBalance(self)
  return 0;
end

function Laning.EvaluateAgroCreeps(self)
  return 0;
end
---------------------------------------------
function Laning.LastHit(self, BotInfo)
  local bot = GetBot();
  local position = self:GetComfortPoint(BotInfo);
  local dist = GetUnitToLocationDistance(bot, position);
  local no_heroes_near = true; -- TODO

  DebugDrawCircle(position, 40, 255, 255, 255);

  -- if (self.kinda_low_creep) then
  --   DebugDrawCircle(self.kinda_low_creep:GetLocation(), 20, 255, 0, 0);
  -- end

  -- if (self.weak) then
  --   DebugDrawCircle(self.weak:GetLocation(), 20, 255, 255, 0);
  -- end

  -- fprint(self.kinda_low_creep and "low" or "no low")

  DebugDrawCircle(position, 20, 0, 255 ,255);
  if (dist > 800) then
    fprint("really far from comfort");
    BotActions.MoveToLocation:Call(position);
  elseif (self.very_low_creep) then
    fprint("last hit!");
    bot:Action_AttackUnit(self.very_low_creep, false);
  elseif (self.kinda_low_creep and no_heroes_near) then
    fprint("kinda low");
    bot:Action_AttackUnit(self.kinda_low_creep, false);
  elseif (dist > 250) then
    fprint("get a bit closer");
    BotActions.MoveToLocation:Call(position);
  elseif (self.weak and self.weak:GetHealth() < 150) then
    fprint("rotate");
    if (not UnitHelper:IsFacingEntity(bot, self.weak, 10)) then
      BotActions.RotateTowards:Call(self.weak:GetLocation());
    end
  -- else
  --   BotActions.Dance:Call(position, 50, 1);
  end
end

function Laning.LaneBalance(self)

end

function Laning.AgroCreeps(self)

end
---------------------------------------------
Laning.LASTHIT      = "LASTHIT";
Laning.LANE_BALANCE = "LANE_BALANCE";
Laning.AGRO_CREEPS  = "AGRO_CREEPS";
Laning.StateMachine = {}
Laning.StateMachine[Laning.LASTHIT]       = Laning.LastHit;
Laning.StateMachine[Laning.LANE_BALANCE]  = Laning.LaneBalance;
Laning.StateMachine[Laning.AGRO_CREEPS]   = Laning.AgroCreeps;
Laning.StateMachine.State = Laning.LASTHIT;
---------------------------------------------
function Laning:UpdateLaningState()
  self.very_low_creep = Creeping:CreepWithNHitsOfHealth(1000, true, true, 1);
  self.kinda_low_creep = Creeping:CreepWithNHitsOfHealth(1000, true, true, 3);
  self.weak = Creeping:WeakestCreep(1000, false);
end

function Laning:UpdateState()
  local bot = GetBot();
  local evals = {};
  local table = { self.LASTHIT, self.LANE_BALANCE, self.AGRO_CREEPS };
  evals[self.LASTHIT] = self.EvaluateLastHit(self);
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
  self:UpdateLaningState();
  self:UpdateState();
  self.StateMachine[self.StateMachine.State](self, BotInfo, Mode, Strategy);
end
---------------------------------------------
return Laning;
