local M = {}
local BotActions      = require(GetScriptDirectory().."/dev/bot_actions");
-------------------------------------------------
M.STATE_WALK_TO_RUNE = "STATE_WALK_TO_RUNE";
M.STATE_WAIT_RUNE = "STATE_WAIT_RUNE"
M.STATE_PICK_RUNE = "STATE_PICK_RUNE"
M.RUNE = RUNE_BOUNTY_3;
-------------------------------------------------
-------------------------------------------------
function M.StateWalkToRune(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  local loc = BOUNTY_RUNES[self.RUNE];
  if (GetUnitToLocationDistance(bot, loc) < 200) then
    self.StateMachine.State = self.STATE_WAIT_RUNE;
  else
    BotActions.ActionMoveToLocation:Call(loc);
  end
end

function M.StateWaitRune(self, BotInfo, Mode, Strategy)
  print("xxxxx")
  print("status"..GetRuneStatus(RUNE_BOUNTY_1));
  print("status"..GetRuneStatus(RUNE_BOUNTY_2));
  print("status"..GetRuneStatus(RUNE_BOUNTY_3));
  print("status"..GetRuneStatus(RUNE_BOUNTY_4));
  if (GetRuneStatus(self.RUNE) == 1) then
    self.StateMachine.State = self.STATE_PICK_RUNE;
  end
end

function M.StatePickRune(self, BotInfo, Mode, Strategy)
  BotActions.ActionPickUpRune:Call(self.RUNE);
end
-------------------------------------------------
-------------------------------------------------
M.StateMachine = {}
M.StateMachine.State = M.STATE_WALK_TO_RUNE;
M.StateMachine[M.STATE_WALK_TO_RUNE] = M.StateWalkToRune;
M.StateMachine[M.STATE_WAIT_RUNE]    = M.StateWaitRune;
M.StateMachine[M.STATE_PICK_RUNE]    = M.StatePickRune;
-------------------------------------------------
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self.StateMachine[self.StateMachine.State](self, BotInfo, Mode, Strategy);
end
-------------------------------------------------
return M;
