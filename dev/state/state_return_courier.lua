local M = {}
local BotActions = require(GetScriptDirectory().."/dev/bot_actions");
-------------------------------------------------
M.StateMachine = {}
-------------------------------------------------
function M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
--------------------------------------------------------
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  self.courier = GetCourier(0);
  return (self:ShouldReturn() and 100000 or -999);
end

function M:ShouldReturn()
  local courier_state = GetCourierState(self.courier);
  return (courier_state ~= COURIER_STATE_DELIVERING_ITEMS and courier_state ~= COURIER_STATE_RETURNING_TO_BASE and self:DistantFromFountain());
end

function M:DistantFromFountain()
  return GetUnitToLocationDistance(self.courier, FOUNTAIN[GetTeam()]) > 500;
end
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  GetBot():ActionImmediate_Courier(self.courier, COURIER_ACTION_RETURN);
end
-------------------------------------------------
return M;
