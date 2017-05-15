local M = {}
local BotActions        = require(GetScriptDirectory().."/dev/bot_actions");
local Game              = require(GetScriptDirectory().."/dev/game")
local RewardHarassHero  = require(GetScriptDirectory().."/dev/state/_decision_making/reward/reward_harass_hero");
local EffortWalk        = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_walk");
local EffortWait        = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_wait");
local EffortDanger      = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_danger");
-------------------------------------------------
function M:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end
-------------------------------------------------
M.Potential = {};
M.Hero = nil;
-------------------------------------------------
function M:ArgumentString()
  return "("..self.Hero:GetUnitName()..")";
end
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local bot = GetBot();
  local highest = VERY_LOW_INT;
  local heroes = FGetNearbyHeroes(1500, true);
  if (#heroes ~= 0) then
    for i = 1, #heroes do
      local hero = heroes[i];
      local reward = RewardHarassHero:Hero(hero, heroes);
      local effort = EffortWalk:IntoRange(hero:GetLocation(), bot:GetAttackRange()) + 1;
      local potential = reward / effort;

      self.Potential[hero] = potential;
      if (potential > highest) then
        self.Hero = hero;
        highest = potential;
      end
    end
    return self.Potential[self.Hero];
  else
    return -999;
  end
end
-------------------------------------------------
-------------------------------------------------
function M.Fight(self, BotInfo, Mode, Strategy)
  if (GetUnitToUnitDistance(GetBot(), self.Hero) > (GetBot():GetAttackRange() - 50) and GetBot():GetCurrentActionType() ~= BOT_ACTION_TYPE_ATTACK) then
    BotActions.MoveToLocation:Call(self.Hero:GetLocation());
  else
    GetBot():Action_AttackUnit(self.Hero, false);
    if ((GameTime() - GetBot():GetLastAttackTime()) < 0.1) then
      GetBot().flex_bot.backoff = DotaTime() + 0.5;
    end 
  end
end
-------------------------------------------------
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self:Fight(self, BotInfo, Mode, Strategy);
end
-------------------------------------------------
return M;
