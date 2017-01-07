local M = {}
local DotaBotUtility  = require(GetScriptDirectory().."/dev/utility");
local BotActions      = require(GetScriptDirectory().."/dev/bot_actions");
-------------------------------------------------
M.STATE_WALK_TO_WAIT = "STATE_WALK_TO_WAIT";
M.STATE_WAIT = "STATE_WAIT"
-------------------------------------------------
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  if (DotaTime() > 0 and DotaTime() < 15) then
    return 10;
  end
  return 0;
end
-------------------------------------------------
-------------------------------------------------
function M.StateWalkToWait(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  local tower = DotaBotUtility:GetFrontTowerAt(BotInfo.LANE);
  if (tower ~= nil) then
    local pos = tower:GetLocation();
    local distance = GetUnitToLocationDistance(bot, pos);
    if (distance > 200) then
      BotActions.ActionMoveToLocation:Call(pos);
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
M.StateMachine[M.STATE_WALK_TO_WAIT] = M.StateWalkToWait;
M.StateMachine[M.STATE_WAIT] = M.StateWait;
-------------------------------------------------
function M:Reset()
  self.StateMachine.State = self.STATE_WALK_TO_WAIT;
end
M:Reset();
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self.StateMachine[self.StateMachine.State](self, BotInfo, Mode, Strategy);
end
-------------------------------------------------
return M;
