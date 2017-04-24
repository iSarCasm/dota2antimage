local M = {}
----------------------------------------------
local Game       = require(GetScriptDirectory().."/dev/game");
local BotActions = require(GetScriptDirectory().."/dev/bot_actions");
local MapHelper  = require(GetScriptDirectory().."/dev/helper/map_helper");
local RewardFarmCreepwave   = require(GetScriptDirectory().."/dev/state/_decision_making/reward/reward_farm_creepwave");
local EffortWalk            = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_walk");
local EffortWait            = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_wait");
local EffortKillCreepwave   = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_kill_creepwave");
local EffortDanger          = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_danger");
----------------------------------------------
local FarmingLhD = require(GetScriptDirectory().."/dev/state/state_farming_lane/farming_lh_d");
local Laning = require(GetScriptDirectory().."/dev/state/state_farming_lane/laning");
----------------------------------------------
M.STATE_WALK_TO_LANE = "STATE_WALK_TO_LANE";
M.STATE_FARMING      = "STATE_FARMING";
----------------------------------------------
M.FARMING_LH_D  = "FARMING_LH_D";
M.LANING        = "LANING";
----------------------------------------------
M.Lane = LANE_TOP;
M.Potential = {};
----------------------------------------------
function M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.FarmingType = {}
    o.FarmingType.FARMING_LH_D  = FarmingLhD;
    o.FarmingType.LANING        = Laning:new();
    o:Reset();
    return o
end
--------------------------------------------------------
function M:ArgumentString()
  return "("..self.Lane..")";
end
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local bot = GetBot();
  local lanes = { LANE_TOP, LANE_MID, LANE_BOT };
  local highest = VERY_LOW_INT;
  -- print("Lanes:");
  for i = 1, #lanes do
    local lane = lanes[i];

    local reward = RewardFarmCreepwave:Generic(lane, BotInfo, Mode);
    local lane_location = MapHelper:LaneFrontLocation(GetTeam(), lane, false);
    local effort = EffortWalk:ToLocation(lane_location) + EffortDanger:OfLocation(lane_location) + EffortWait:Creeps(lane) + EffortKillCreepwave:Generic();
    local potential = reward / effort;

    -- print("Lane: .."..lane);
    -- print("Reward: "..reward);
    -- print("Kill: "..EffortKillCreepwave:Generic());
    -- print("Wait: "..EffortWait:Creeps(lane));
    -- print("Walk: "..EffortWalk:ToLocation(lane_location));
    -- print("Danger: "..EffortDanger:OfLocation(lane_location));
    -- print("P: "..potential);

    self.Potential[lane] = potential;
    if (potential > highest) then
      self.Lane = lane;
      highest = potential;
    end
  end
  return self.Potential[self.Lane];
end
----------------------------------------------
----------------------------------------------
function M.StateWalkToLane(self, BotInfo, Mode, Strategy)
  local lane_location = MapHelper:LaneFrontLocation(GetTeam(), self.Lane, false);
  if (GetUnitToLocationDistance(GetBot(), lane_location) < 1000) then
    self.StateMachine.State = self.STATE_FARMING;
  else
    BotActions.MoveToLocation:Call(lane_location);
  end
end

function M.StateFarming(self, BotInfo, Mode, Strategy)
  self.FarmingType[self.FarmingType.Type]:Run(self, BotInfo, Mode, Strategy);
end
----------------------------------------------
----------------------------------------------
M.StateMachine = {}
M.StateMachine[M.STATE_WALK_TO_LANE]  = M.StateWalkToLane;
M.StateMachine[M.STATE_FARMING]       = M.StateFarming;
-------------------------------------------------
function M:Reset()
  self.StateMachine.State = self.STATE_WALK_TO_LANE;
  self.FarmingType.Type   = self.LANING;
end
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self.StateMachine[self.StateMachine.State](self, BotInfo, Mode, Strategy);
end

return M;
