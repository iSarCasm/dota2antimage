local M = {}
local BotActions      = require(GetScriptDirectory().."/dev/bot_actions");
local Game            = require(GetScriptDirectory().."/dev/game");
-------------------------------------------------
M.STATE_WALK_TO_RUNE = "STATE_WALK_TO_RUNE";
M.STATE_WAIT_RUNE = "STATE_WAIT_RUNE"
M.STATE_PICK_RUNE = "STATE_PICK_RUNE"
-------------------------------------------------
M.Potential = {};
M.Rune = RUNE_BOUNTY_3;
-------------------------------------------------
function M:ArgumentString()
  return "("..self.Rune..")";
end
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local bot = GetBot();
  local runes = {RUNE_BOUNTY_1, RUNE_BOUNTY_2, RUNE_BOUNTY_3, RUNE_BOUNTY_4};
  local highest = -9999999;
  for i = 1, #runes do
    local rune = runes[i];
    local reward = 60 + self:LaningReward(rune, BotInfo, Mode, Strategy); -- bounty gives ~60 gold

    local walkSpeed = bot:GetCurrentMovementSpeed();
    local walkDistance = GetUnitToLocationDistance(bot, GetRuneSpawnLocation(rune));
    local effortWalk = walkDistance / walkSpeed;

    local effortWait = Game:TimeToRune(rune);

    local effort = effortWait + effortWalk;
    local potential = reward / effort;
    self.Potential[rune] = potential;
    if (potential > highest) then
      self.Rune = rune;
      highest = potential;
    end
  end
  return self.Potential[self.Rune];
end

function M:LaningReward(Rune, BotInfo, Mode, Strategy)
  if (Mode == MODE_LANING) then
    if (GetTeam() == TEAM_RADIANT) then
      if (BotInfo.LANE == LANE_TOP or BotInfo.LANE == LANE_MID) then
        return ((Rune == RUNE_BOUNTY_1) and 100 or 0);
      else
        return ((Rune == RUNE_BOUNTY_2) and 100 or 0);
      end
    else
      if (BotInfo.LANE == LANE_BOT or BotInfo.LANE == LANE_MID) then
        return ((Rune == RUNE_BOUNTY_4) and 100 or 0);
      else
        return ((Rune == RUNE_BOUNTY_3) and 100 or 0);
      end
    end
  else
    return 0;
  end
end
-------------------------------------------------
-------------------------------------------------
function M.StateWalkToRune(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  local loc = GetRuneSpawnLocation(self.Rune);
  if (GetUnitToLocationDistance(bot, loc) < 200) then
    self.StateMachine.State = self.STATE_WAIT_RUNE;
  else
    BotActions.ActionMoveToLocation:Call(loc);
  end
end

function M.StateWaitRune(self, BotInfo, Mode, Strategy)
  if (GetRuneStatus(self.Rune) == 1) then
    self.StateMachine.State = self.STATE_PICK_RUNE;
  end
end

function M.StatePickRune(self, BotInfo, Mode, Strategy)
  BotActions.ActionPickUpRune:Call(self.Rune);
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
