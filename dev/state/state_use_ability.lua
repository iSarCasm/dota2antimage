local M = {}
local BotActions        = require(GetScriptDirectory().."/dev/bot_actions");
local Game              = require(GetScriptDirectory().."/dev/game")
local RewardKillHero    = require(GetScriptDirectory().."/dev/state/_decision_making/reward/reward_kill_hero");
local EffortWalk        = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_walk");
local EffortWait        = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_wait");
local EffortDanger      = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_danger");
local EffortKillHero    = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_kill_hero");
-------------------------------------------------
function M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
--------------------------------------------------------
M.Potential = {};
M.Hero = nil;
-------------------------------------------------
function M:ArgumentString()
  return "("..self.Ability.." "..self.Argument..")";
end
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local bot = GetBot();
  local AbilityItems = bot.flex_bot.abilityItems;
  local highestPotential = VERY_LOW_INT;
  local highestAbility = self.Ability;
  for i = 1, #AbilityItems:List(bot) do
    local ability = AbilityItems:List(bot)[i];
    if (AbilityItems.ability[ability] and AbilityItems.ability[ability].EvaluatePotential) then
      local potential = AbilityItems.ability[ability]:EvaluatePotential();
      if (potential > highestPotential) then
        highestPotential = potential;
        highestAbility = ability;
      end
    end
  end
  if (highestAbility) then self:SetState(highestAbility) end;
  return highestPotential;
end
-------------------------------------------------
function M:SetState(Ability)
  local bot = GetBot();
  local AbilityItems = bot.flex_bot.abilityItems;
  if (self.Ability ~= nil and (self.Ability ~= Ability or self.Argument ~= self:StateArgument(Ability))) then
    if (AbilityItems.ability[self.Ability].Reset) then
      AbilityItems.ability[self.Ability]:Reset();
    end
  end
  self.Ability = Ability;
  self.Argument = self:StateArgument(Ability);
end

function M:StateArgument(Ability)
  local bot = GetBot();
  local AbilityItems = bot.flex_bot.abilityItems;
  if (AbilityItems.ability[Ability].ArgumentString) then
    return AbilityItems.ability[Ability]:ArgumentString();
  end
  return "";
end
-------------------------------------------------
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  local AbilityItems = GetBot().flex_bot.abilityItems;
  AbilityItems.ability[self.Ability]:Run(BotInfo, Mode, Strategy);
end
-------------------------------------------------
return M;
