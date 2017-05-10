local Shadowraze = {}
------------------------------------
local BotActions  = require(GetScriptDirectory().."/dev/bot_actions");
local BotInfo     = require(GetScriptDirectory().."/dev/bot_info")
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper")
local UnitHelper = require(GetScriptDirectory().."/dev/helper/unit_helper")
local Creeping   = require(GetScriptDirectory().."/dev/state/state_farming_lane/creeping");
-------------------------------------
local RewardDamageHero   = require(GetScriptDirectory().."/dev/state/_decision_making/reward/reward_damage_hero");
local RewardDamageCreep  = require(GetScriptDirectory().."/dev/state/_decision_making/reward/reward_damage_creep");
local EffortWalk        = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_walk");
local EffortSpendMana   = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_spend_mana");
local EffortCooldown    = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_cooldown");
local EffortDanger      = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_danger");
-------------------------------------
function Shadowraze:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.Potential = {};
    o.Unit = nil;
    return o
end

function Shadowraze:Ability()
  return GetBot():GetAbilityByName(self.name);
end
-----------------------------------
function Shadowraze:ArgumentString()
  return ((self.Unit and not self.Unit:IsNull()) and self.Unit:GetUnitName() or "");
end

function Shadowraze:EvaluatePotential()
  if (not self:Ability():IsFullyCastable()) then return -999 end;

  local bot = GetBot();
  local highest = VERY_LOW_INT;
  local units = bot:GetNearbyHeroes(1500, true, BOT_MODE_NONE);
  local creeps = Creeping:GetNearbyCreeps(bot, 1500, true);
  for k,v in pairs(creeps) do units[k] = v end -- merge creeps into untis
  local reward = 0;
  if (#units ~= 0) then
    for i = 1, #units do
      local unit = units[i];
      if (unit:IsHero()) then
        reward = RewardDamageHero:Hero(unit, self:Ability():GetAbilityDamage());
      elseif (unit:IsCreep()) then
        reward = RewardDamageCreep:Creep(unit, self:Ability():GetAbilityDamage());
      end
      if (GetUnitToUnitDistance(bot, unit) < (self.range-125+64)) then reward = 0; end;
      local effort = EffortWalk:IntoRange(unit:GetLocation(), self.range) + EffortDanger:OfLocation(unit:GetLocation()) 
                        + EffortSpendMana:Mana(90) + EffortCooldown:Cooldown(10) + self.base_effort;
      local potential = reward / effort;

      self.Potential[unit] = potential;
      if (potential > highest) then
        self.Unit = unit;
        highest = potential;
      end
    end
    return self.Potential[self.Unit];
  else
    return -999;
  end
end
------------------------------------
function Shadowraze:Run(BotInfo, Mode, Strategy)
  if (not self.Unit or self.Unit:IsNull()) then return end;

  local bot = GetBot();
  local distance = GetUnitToUnitDistance(bot, self.Unit);
  if (distance > (self.range+64)) then
    BotActions.MoveToLocation:Call(self.Unit:GetLocation());
  else
    if (not UnitHelper:IsFacingEntity(bot, self.Unit, 10)) then
      BotActions.RotateTowards:Call(self.Unit:GetLocation());
    end
  end

  if (UnitHelper:IsFacingEntity(bot, self.Unit, 10) and distance <= (self.range+64)) then
    bot:Action_UseAbility(self:Ability());
  elseif (bot:IsCastingAbility() and (not UnitHelper:IsFacingEntity(bot, self.Unit, 10) or distance > (self.range+125+64) or distance < (self.range-125+64))) then
    bot:Action_ClearActions(true);
  end
end
------------------------------------
return Shadowraze;
