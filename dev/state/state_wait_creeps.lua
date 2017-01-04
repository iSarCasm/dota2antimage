local M = {}
local DotaBotUtility  = require(GetScriptDirectory().."/dev/utility");
-------------------------------------------------
M.STATE_WALK_TO_WAIT = "STATE_WALK_TO_WAIT";
M.STATE_WAIT = "STATE_WAIT"
-------------------------------------------------
-------------------------------------------------
function M.StateWalkToWait(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  local tower = DotaBotUtility:GetFrontTowerAt(BotInfo.LANE);
  if (tower ~= nil) then
    local pos = tower:GetLocation();
    local distance = GetUnitToLocationDistance(bot, pos);
    if (distance > 200) then
      bot:Action_MoveToLocation(pos);
    else
      self.StateMachine.State = self.STATE_WAIT;
    end
  else
    print("error state_wait_creeps (lane: "..BotInfo.LANE..")");
  end
end

function M.StateWait(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  local tower = DotaBotUtility:GetFrontTowerAt(BotInfo.LANE);
  local pos = tower:GetLocation();
  local distance = GetUnitToLocationDistance(bot, pos);
  if (distance > 200) then
    self.StateMachine.State = self.STATE_WALK_TO_WAIT;
  end
end
-------------------------------------------------
-------------------------------------------------
M.StateMachine = {}
M.StateMachine.State = M.STATE_WALK_TO_WAIT;
M.StateMachine[M.STATE_WALK_TO_WAIT] = M.StateWalkToWait;
M.StateMachine[M.STATE_WAIT] = M.StateWait;
-------------------------------------------------
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self.StateMachine[self.StateMachine.State](self, BotInfo, Mode, Strategy);
end
-------------------------------------------------
return M;