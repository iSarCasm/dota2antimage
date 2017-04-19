local M = {}
local BotActions        = require(GetScriptDirectory().."/dev/bot_actions");
local RewardRune        = require(GetScriptDirectory().."/dev/state/_decision_making/reward/reward_rune");
local EffortWalk        = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_walk");
local EffortWait        = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_wait");
local EffortDanger      = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_danger");
-------------------------------------------------
M.STATE_WALK_TO_RUNE = "STATE_WALK_TO_RUNE";
M.STATE_WAIT_RUNE = "STATE_WAIT_RUNE"
M.STATE_PICK_RUNE = "STATE_PICK_RUNE"
-------------------------------------------------
M.Potential = {};
M.Rune = nil;
-------------------------------------------------
function M:ArgumentString()
  return "("..self.Rune..")";
end
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local bot = GetBot();
  local runes = {RUNE_BOUNTY_1, RUNE_BOUNTY_2, RUNE_BOUNTY_3, RUNE_BOUNTY_4, RUNE_POWERUP_1, RUNE_POWERUP_2};
  local highest = VERY_LOW_INT;
  for i = 1, #runes do
    local rune = runes[i];

    local reward = RewardRune:Generic(rune, Mode);
    local rune_location = GetRuneSpawnLocation(rune);
    local effort = EffortWait:Rune(rune) + EffortWalk:ToLocation(rune_location) + EffortDanger:OfLocation(rune_location);
    local potential = reward / effort;

    self.Potential[rune] = potential;
    if (potential > highest) then
      self.Rune = rune;
      highest = potential;
    end
  end
  return self.Potential[self.Rune];
end
-------------------------------------------------
-------------------------------------------------
function M.StateWalkToRune(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  local loc = GetRuneSpawnLocation(self.Rune);
  if (GetUnitToLocationDistance(bot, loc) < 200) then
    self.StateMachine.State = self.STATE_WAIT_RUNE;
  else
    bot:Action_MoveToLocation(loc);
  end
end

function M.StateWaitRune(self, BotInfo, Mode, Strategy)
  if (GetRuneStatus(self.Rune) == 1) then
    self.StateMachine.State = self.STATE_PICK_RUNE;
  end
end

function M.StatePickRune(self, BotInfo, Mode, Strategy)
  GetBot():Action_PickUpRune(self.Rune);
end
-------------------------------------------------
-------------------------------------------------
M.StateMachine = {}
M.StateMachine[M.STATE_WALK_TO_RUNE] = M.StateWalkToRune;
M.StateMachine[M.STATE_WAIT_RUNE]    = M.StateWaitRune;
M.StateMachine[M.STATE_PICK_RUNE]    = M.StatePickRune;
-------------------------------------------------
function M:Reset()
  self.StateMachine.State = self.STATE_WALK_TO_RUNE;
end
M:Reset();
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self.StateMachine[self.StateMachine.State](self, BotInfo, Mode, Strategy);
end
-------------------------------------------------
return M;
