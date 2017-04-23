local M = {}
local DotaBotUtility  = require(GetScriptDirectory().."/dev/utility");
local BotActions      = require(GetScriptDirectory().."/dev/bot_actions");
-------------------------------------------------
M.STATE_WALK_TO_WAIT = "STATE_WALK_TO_WAIT";
M.STATE_WAIT = "STATE_WAIT"
-------------------------------------------------
function M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o:Reset();
    return o
end
--------------------------------------------------------
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
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
M.StateMachine[M.STATE_WALK_TO_WAIT] = M.StateWalkToWait;
M.StateMachine[M.STATE_WAIT] = M.StateWait;
-------------------------------------------------
function M:Reset()
  self.StateMachine.State = self.STATE_WALK_TO_WAIT;
end
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self.StateMachine[self.StateMachine.State](self, BotInfo, Mode, Strategy);
end
-------------------------------------------------
return M;
