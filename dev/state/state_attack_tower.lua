local M = {}
local BotActions        = require(GetScriptDirectory().."/dev/bot_actions");
local Game              = require(GetScriptDirectory().."/dev/game")
local RewardKillTower   = require(GetScriptDirectory().."/dev/state/_decision_making/reward/reward_kill_tower");
local EffortWalk        = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_walk");
local EffortDanger      = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_danger");
local EffortKillTower   = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_kill_tower");
-------------------------------------------------
function M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
--------------------------------------------------------
M.Potential = {};
M.Tower = nil;
-------------------------------------------------
function M:ArgumentString()
  return "("..self.Tower:GetUnitName()..")";
end
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local bot = GetBot();
  local highest = VERY_LOW_INT;
  local towers = bot:GetNearbyTowers(1500, true);
  if (#towers ~= 0) then
    for i = 1, #towers do
      local tower = towers[i];
      local reward = RewardKillTower:Tower(tower);
      local effort = EffortWalk:ToLocation(tower:GetLocation()) + EffortDanger:OfLocation(tower:GetLocation()) + EffortKillTower:Tower(tower);
      local potential = reward / effort;

      self.Potential[tower] = potential;
      if (potential > highest) then
        self.Tower = tower;
        highest = potential;
      end
    end
    return self.Potential[self.Tower];
  else
    return -999;
  end
end
-------------------------------------------------
-------------------------------------------------
function M.Fight(self, BotInfo, Mode, Strategy)
  GetBot():Action_AttackUnit(self.Tower, false);
end
-------------------------------------------------
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self:Fight(self, BotInfo, Mode, Strategy);
end
-------------------------------------------------
return M;
