local M = {}
--------------------------------------------------------
local STRATEGY_IDLE        = "STRATEGY_IDLE";
local STRATEGY_LANING      = "STRATEGY_LANING";
local STRATEGY_FARMING     = "STRATEGY_FARMING";
local STRATEGY_SPLITTING   = "STRATEGY_SPLITTING";
local STRATEGY_PUSHING     = "STRATEGY_PUSHING";
local STRATEGY_GANKING     = "STRATEGY_GANKING";
--------------------------------------------------------
M.LastCalled = {};
M.LastCalled[TEAM_DIRE]    = nil;
M.LastCalled[TEAM_RADIANT] = nil;
M.Strategy = STRATEGY_IDLE;
--------------------------------------------------------
--------------------------------------------------------
function M:UpdateState()
  self.Strategy = STRATEGY_LANING;
  if (DotaTime() > 14*60) then
    self.Strategy = STRATEGY_FARMING;
  end
end

--------------------------------------------------------
M.PrevStrategy = "none";
function M:DebugStateChange()
  if(self.PrevStrategy ~= self.Strategy) then
      print("Team "..GetTeam().." STRATEGY: "..self.Strategy.." <- "..self.PrevStrategy);
      self.PrevStrategy = self.Strategy;
  end
end

function M:DebugCallTimes()
  print("Team State Machine Called at "..DotaTime());
  print("Team is "..GetTeam());
end
--------------------------------------------------------
function M:Update()
  if (self.LastCalled[GetTeam()] ~= math.floor(DotaTime())) then
    self.LastCalled[GetTeam()] = math.floor(DotaTime());
    self:UpdateState();
  end
  self:DebugStateChange();
end

return M;
