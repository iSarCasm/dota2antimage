local M = {}
local BotActions = require(GetScriptDirectory().."/dev/bot_actions");
-------------------------------------------------
M.StateMachine = {}
-------------------------------------------------
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local bot = GetBot();
  local courier = GetCourier(0);
  return (self:ShouldReturn(courier) and 100000 or -999);
end

function M:ShouldReturn(courier)
  return (GetCourierState(courier) ~= COURIER_STATE_DELIVERING_ITEMS and GetCourierState(courier) ~= COURIER_STATE_RETURNING_TO_BASE and self:DistantFromFountain(courier));
end

function M:DistantFromFountain(courier)
  return GetUnitToLocationDistance(courier, FOUNTAIN[GetTeam()]) > 500;
end
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  GetBot():ActionImmediate_Courier(GetCourier(0), COURIER_ACTION_RETURN);
end
-------------------------------------------------
return M;
