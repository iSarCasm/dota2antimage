local M = {}
local BotActions      = require(GetScriptDirectory().."/dev/bot_actions");
local RewardHeal      = require(GetScriptDirectory().."/dev/state/_decision_making/reward/reward_heal");
local EffortWalk      = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_walk");
local EffortDanger    = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_danger");
-------------------------------------------------
M.STATE_WALK_TO_FOUNTAIN  = "STATE_WALK_TO_FOUNTAIN";
M.STATE_HEAL              = "STATE_HEAL"
-------------------------------------------------
function M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o:Reset()
    return o
end
--------------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local location = FOUNTAIN[GetTeam()];
  local reward = RewardHeal:Fountain();
  local effort = EffortWalk:ToLocation(location) + EffortDanger:OfLocation(location);
  return reward / effort;
end
-------------------------------------------------
-------------------------------------------------
function M.StateWalkToFountain(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  local loc = FOUNTAIN[GetTeam()];
  if (bot:DistanceFromFountain() == 0) then
    self.StateMachine.State = self.STATE_HEAL;
  else
    BotActions.MoveToLocation:Call(loc);
  end
end

function M.StateHeal(self, BotInfo, Mode, Strategy)
  -- idle
end
-------------------------------------------------
M.StateMachine = {}
M.StateMachine[M.STATE_WALK_TO_FOUNTAIN]  = M.StateWalkToFountain;
M.StateMachine[M.STATE_HEAL]              = M.StateHeal;
-------------------------------------------------
function M:Reset()
  self.StateMachine.State = self.STATE_WALK_TO_FOUNTAIN;
end
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self.StateMachine[self.StateMachine.State](self, BotInfo, Mode, Strategy);
end
-------------------------------------------------
return M;
