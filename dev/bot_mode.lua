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
function StateIdle(StateMachine, BotInfo)
  M.Mode = STATE_LANING;
end

function UpdateState(BotInfo, M.Mode)
  -- local npcBot = GetBot();
  if (DotaTime() > 14*60) then
    M.Mode = STATE_FARMING;
    -- local tower = DotaBotUtility:GetFrontTowerAt(BotInfo.LANE);
    -- npcBot:Action_MoveToLocation(tower:GetLocation());
  end
end
--------------------------------------------------------
local M.Mode = STATE_LANING;
--------------------------------------------------------
--------------------------------------------------------
local PrevMode = "none";
function DebugStateChange()
  if(PrevMode ~= M.Mode) then
      print("Antimage bot STATE: "..M.Mode.." <- "..PrevMode);
      PrevMode = M.Mode;
  end
end
--------------------------------------------------------
function M:Update(BotInfo, M.Mode)
  UpdateState(BotInfo, M.Mode);
end

return M;
