local M = {}
local BotActions        = require(GetScriptDirectory().."/dev/bot_actions");
local Game         		  = require(GetScriptDirectory().."/dev/game")
local RewardFarmJungle  = require(GetScriptDirectory().."/dev/state/_decision_making/reward/reward_farm_jungle");
local EffortWalk        = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_walk");
local EffortWait        = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_wait");
local EffortDanger      = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_danger");
local EffortKillJungle  = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_kill_jungle");
-------------------------------------------------
M.STATE_WALK_TO_CAMP = "STATE_WALK_TO_CAMP";
M.STATE_WAIT_CAMP = "STATE_WAIT_CAMP"
M.STATE_KILL_CAMP = "STATE_KILL_CAMP"
-------------------------------------------------
M.Potential = {};
M.Jungle = nil;
-------------------------------------------------
function M:ArgumentString()
  return "("..JUNGLE_CAMP[self.Jungle].Name..")";
end
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local bot = GetBot();
  local highest = VERY_LOW_INT;
  -- print("Jungle: ");
  for jungle = 1, JUNGLE_TOTAL do
    local reward = RewardFarmJungle:Camp(jungle, Mode);
    local jungle_location = JUNGLE_CAMP[jungle].Location;
    local effort = EffortKillJungle:Camp(jungle) + EffortWait:Jungle(jungle) + EffortWalk:ToLocation(jungle_location) + EffortDanger:OfLocation(jungle_location);
    -- print("Camp: .."..JUNGLE_CAMP[jungle].Name);
    -- print("Kill: "..EffortKillJungle:Camp(jungle));
    -- print("Wait: "..EffortWait:Jungle(jungle));
    -- print("Walk: "..EffortWalk:ToLocation(jungle_location));
    -- print("Danger: "..EffortDanger:OfLocation(jungle_location));
    local potential = reward / effort;

    self.Potential[jungle] = potential;
    if (potential > highest) then
      self.Jungle = jungle;
      highest = potential;
    end
  end
  return self.Potential[self.Jungle];
end
-------------------------------------------------
-------------------------------------------------
function M.StateWalkToCamp(self, BotInfo, Mode, Strategy)
  -- print("walk!!");
  local bot = GetBot();
  local loc = JUNGLE_CAMP[self.Jungle].Location;
  if (GetUnitToLocationDistance(bot, loc) < 500) then
    if (Game:TimeToJungle(self.Jungle) > 0) then
      self.StateMachine.State = self.STATE_WAIT_CAMP;
    else
      self.StateMachine.State = self.STATE_KILL_CAMP;
    end
  else
    bot:Action_MoveToLocation(loc);
  end
end

function M.StateWaitCamp(self, BotInfo, Mode, Strategy)
  if (Game:TimeToJungle(self.Jungle) == 0) then
    self.StateMachine.State = self.STATE_KILL_CAMP;
  end
end

function M.StateKillCamp(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  local creeps = bot:GetNearbyCreeps(700, true);
  if (#creeps > 0) then
    bot:Action_AttackUnit(creeps[1], false);
  else
    self.StateMachine.State = self.STATE_WALK_TO_CAMP;
  end
end
-------------------------------------------------
-------------------------------------------------
M.StateMachine = {}
M.StateMachine[M.STATE_WALK_TO_CAMP] = M.StateWalkToCamp;
M.StateMachine[M.STATE_WAIT_CAMP] = M.StateWaitCamp;
M.StateMachine[M.STATE_KILL_CAMP] = M.StateKillCamp;
-------------------------------------------------
function M:Reset()
  -- print("============== RESET ==========");
  self.StateMachine.State = self.STATE_WALK_TO_CAMP;
end
M:Reset();
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self.StateMachine[self.StateMachine.State](self, BotInfo, Mode, Strategy);
end
-------------------------------------------------
return M;
