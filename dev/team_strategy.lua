local M = {}
--------------------------------------------------------
local STRATEGY_IDLE        = "STRATEGY_IDLE";
local STRATEGY_LANING      = "STRATEGY_LANING";
local STRATEGY_FARMING     = "STRATEGY_FARMING";
local STRATEGY_SPLITTING   = "STRATEGY_SPLITTING";
local STRATEGY_PUSHING     = "STRATEGY_PUSHING";
local STRATEGY_GANKING     = "STRATEGY_GANKING";
--------------------------------------------------------
function M:UpdateState(StateMachine)
  if (DotaTime() > 14*60) then
    M.Strategy = STATE_FARMING;
  end
end
--------------------------------------------------------
M.LastCalled = {};
M.LastCalled[TEAM_RADIANT]  = math.floor(DotaTime());
M.LastCalled[TEAM_DIRE]     = math.floor(DotaTime());
M.Strategy = STATE_IDLE;
--------------------------------------------------------
--------------------------------------------------------
M.PrevState = "none";
function M:DebugStateChange()
  if(self.PrevState ~= M.Strategy) then
      print("Team "..GetTeam().." state: "..M.Strategy.." <- "..self.PrevState);
      self.PrevState = M.Strategy;
  end
end

function M:DebugCallTimes()
  print("Team State Machine Called at "..DotaTime());
  print("Team is "..GetTeam());
end
--------------------------------------------------------
function M:Update()
  if (self.LastCalled[GetTeam()] != DotaTime()) then
    self.LastCalled[GetTeam()] = DotaTime();
    self.UpdateState(StateMachine);
    self.DebugCallTimes();
  end
  self.DebugStateChange();
end

return M;
