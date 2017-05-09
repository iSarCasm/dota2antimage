local M = {}
local BotActions        = require(GetScriptDirectory().."/dev/bot_actions");
local Game              = require(GetScriptDirectory().."/dev/game")
local RewardHeal        = require(GetScriptDirectory().."/dev/state/_decision_making/reward/reward_heal");
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
M.Shrine = nil;
-------------------------------------------------
function M:ArgumentString()
  return ((self.Shrine and not self.Shrine:IsNull()) and self.Shrine:GetUnitName() or "");
end
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local bot = GetBot();
  local highest = VERY_LOW_INT;
  local shrines = Game:GetShrinesForTeam(GetTeam());
  if (#shrines ~= 0) then
    for i = 1, #shrines do
      local shrine = shrines[i];
      local reward = RewardHeal:Shrine(shrine);
      local effort = EffortWalk:ToLocation(shrine:GetLocation()) + EffortDanger:OfLocation(shrine:GetLocation()) + EffortWait:Shrine(shrine);
      local potential = reward / effort;

      self.Potential[shrine] = potential;
      if (potential > highest) then
        self.Shrine = shrine;
        highest = potential;
      end
    end
    return self.Potential[self.Shrine];
  else
    return -999;
  end
end
-------------------------------------------------
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  GetBot():Action_UseShrine(self.Shrine);
end
-------------------------------------------------
return M;
