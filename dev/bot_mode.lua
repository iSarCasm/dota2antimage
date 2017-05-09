local BotMode = {}
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
function BotMode:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
--------------------------------------------------------
function BotMode:UpdateState(TeamStrategy)
  if (DotaTime() > 14*60) then
    self.Mode = MODE_FARMING;
  end
  self:DebugStateChange();
end
--------------------------------------------------------
BotMode.Mode = MODE_LANING;
--------------------------------------------------------
--------------------------------------------------------
BotMode.PrevMode = "none";
function BotMode:DebugStateChange()
  if(self.PrevMode ~= self.Mode) then
      fprint(GetBot():GetUnitName().." bot MODE: "..self.Mode.." <- "..self.PrevMode);
      self.PrevMode = self.Mode;
  end
end
--------------------------------------------------------
function BotMode:Update(TeamStrategy)
  self:UpdateState(TeamStrategy);
end
--------------------------------------------------------
return BotMode;
