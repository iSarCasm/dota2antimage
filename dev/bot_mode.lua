local M = {}
--------------------------------------------------------
local MODE_IDLE        = "MODE_IDLE";
local MODE_LANING      = "MODE_LANING";
local MODE_FARMING     = "MODE_FARMING";
local MODE_SPLITTING   = "MODE_SPLITTING";
local MODE_PUSHING     = "MODE_PUSHING";
local MODE_DEFENDING   = "MODE_DEFENDING";
local MODE_COVERING    = "MODE_COVERING";
local MODE_GANKING     = "MODE_GANKING";
local MODE_INITIATING  = "MODE_INITIATING";
local MODE_HELPING     = "MODE_HELPING";
local MODE_ROSHING     = "MODE_ROSHING";
--------------------------------------------------------
function M:UpdateState(TeamStrategy)
  if (DotaTime() > 14*60) then
    self.Mode = MODE_FARMING;
  end
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
  self:DebugStateChange();
end

return M;
