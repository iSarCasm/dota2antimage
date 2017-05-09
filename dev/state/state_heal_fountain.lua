local M = {}
local BotActions      = require(GetScriptDirectory().."/dev/bot_actions");
local RewardHeal      = require(GetScriptDirectory().."/dev/state/_decision_making/reward/reward_heal");
local EffortWalk      = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_walk");
local EffortWait      = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_wait");
local EffortDanger    = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_danger");
-------------------------------------------------
M.STATE_WALK_TO_FOUNTAIN  = "STATE_WALK_TO_FOUNTAIN";
M.STATE_HEAL              = "STATE_HEAL"
-------------------------------------------------
function M:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end
--------------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local location = FOUNTAIN[GetTeam()];
  local reward = RewardHeal:Fountain();
  local effort = 1 + EffortWalk:ToLocationWithRange(location, 500) + EffortDanger:OfLocation(location);
  return reward / effort;
end
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  local bot = GetBot();
  local loc = FOUNTAIN[GetTeam()];
  if (bot:DistanceFromFountain() > 0) then
    BotActions.MoveToLocation:Call(loc);
  end
end
-------------------------------------------------
return M;
