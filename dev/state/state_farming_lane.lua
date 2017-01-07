local M = {}
----------------------------------------------
local BotActions = require(GetScriptDirectory().."/dev/bot_actions");
local MapHelper  = require(GetScriptDirectory().."/dev/helper/map_helper");
----------------------------------------------
local FarmingLhD = require(GetScriptDirectory().."/dev/state/state_farming_lane/farming_lh_d");
----------------------------------------------
M.STATE_WALK_TO_LANE = "STATE_WALK_TO_LANE";
M.STATE_FARMING      = "STATE_FARMING";
----------------------------------------------
M.FARMING_LH_D = "FARMING_LH_D";
----------------------------------------------
M.Lane = LANE_TOP;
M.Potential = {};
M.FarmingType = {}
M.FarmingType.FARMING_LH_D = FarmingLhD;
----------------------------------------------
function M:ArgumentString()
  return "("..self.Lane..")";
end
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local bot = GetBot();
  local lanes = { LANE_TOP, LANE_MID, LANE_BOT };
  local highest = -9999999;
  for i = 1, #lanes do
    local lane = lanes[i];
    local reward = ((DotaTime()-15) > 0 and 200 + (self:LaningReward(lane, BotInfo, Mode)) or 0); -- approx creep wave gold? creep swapn time 15
    local walkSpeed = bot:GetCurrentMovementSpeed();
    local lane_location = MapHelper:LaneFrontLocation(GetTeam(), self.Lane, false);
    local walkDistance = GetUnitToLocationDistance(bot, lane_location);
    local effortWalk = walkDistance / walkSpeed;

    local creep_health = 2000; -- approx creep wave health
    local dps = bot:GetBaseDamage();
    local effortFarming = creep_health / dps;

    local effort = effortWalk + effortFarming;
    local potential = reward / effort;
    self.Potential[lane] = potential;
    if (potential > highest) then
      self.Lane = lane;
      highest = potential;
    end
  end
  return self.Potential[self.Lane];
end

function M:LaningReward(Lane, BotInfo, Mode)
  if (Mode == MODE_LANING) then
    if (Lane == BotInfo.LANE) then
      return 100;
    end
  end
  return 0;
end
----------------------------------------------
----------------------------------------------
function M.StateWalkToLane(self, BotInfo, Mode, Strategy)
  local lane_location = MapHelper:LaneFrontLocation(GetTeam(), self.Lane, false);
  if (GetUnitToLocationDistance(GetBot(), lane_location) < 100) then
    self.StateMachine.State = self.STATE_FARMING;
  else
    BotActions.ActionMoveToLocation:Call(lane_location);
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
  self.FarmingType.Type   = self.FARMING_LH_D;
end
M:Reset();
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self.StateMachine[self.StateMachine.State](self, BotInfo, Mode, Strategy);
end

return M;
