local M = {}
local BotActions        = require(GetScriptDirectory().."/dev/bot_actions");
local Game         		  = require(GetScriptDirectory().."/dev/game")
local RewardKillHero    = require(GetScriptDirectory().."/dev/state/_decision_making/reward/reward_kill_hero");
local EffortWalk        = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_walk");
local EffortWait        = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_wait");
local EffortDanger      = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_danger");
local EffortKillHero    = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_kill_hero");
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
  local heroes = bot:GetNearbyHeroes(1500, true, BOT_MODE_NONE);
  if (#heroes ~= 0) then
    for i = 1, #heroes do
      local hero = heroes[i];
      local reward = RewardKillHero:Hero(hero);
      local effort = EffortWalk:ToLocation(hero:GetLocation()) + EffortDanger:OfLocation(hero:GetLocation()) + EffortKillHero:Hero(hero);
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
  GetBot():Action_AttackUnit(self.Hero, false);
end
-------------------------------------------------
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self:Fight(self, BotInfo, Mode, Strategy);
end
-------------------------------------------------
return M;
