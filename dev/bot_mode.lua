local M = {}
--------------------------------------------------------
MODE_IDLE        = "MODE_IDLE";
MODE_LANING      = "MODE_LANING";
MODE_FARMING     = "MODE_FARMING";
MODE_SPLITTING   = "MODE_SPLITTING";
MODE_PUSHING     = "MODE_PUSHING";
MODE_DEFENDING   = "MODE_DEFENDING";
MODE_COVERING    = "MODE_COVERING";
MODE_GANKING     = "MODE_GANKING";
MODE_INITIATING  = "MODE_INITIATING";
MODE_HELPING     = "MODE_HELPING";
MODE_ROSHING     = "MODE_ROSHING";
--------------------------------------------------------
function M:UpdateState(TeamStrategy)
  if (DotaTime() > 14*60) then
    self.Mode = MODE_FARMING;
  end
  self:DebugStateChange();
end
--------------------------------------------------------
M.Mode = MODE_LANING;
--------------------------------------------------------
--------------------------------------------------------
M.PrevMode = "none";
function M:DebugStateChange()
  if(self.PrevMode ~= self.Mode) then
      print(GetBot():GetUnitName().." bot MODE: "..self.Mode.." <- "..self.PrevMode);
      self.PrevMode = self.Mode;
  end
end
--------------------------------------------------------
function M:Update(TeamStrategy)
  self:UpdateState(TeamStrategy);
end

return M;
