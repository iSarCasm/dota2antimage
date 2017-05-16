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
  local bot = GetBot();
  return ((self:HasItemsWorthToDeliver(bot) and GetCourierState(GetCourier(0)) == COURIER_STATE_AT_BASE) and 100000 or -999);
end

function M:HasItemsWorthToDeliver(bot)
  return (bot:GetStashValue() + bot:GetCourierValue()) > 500 or (bot.botInfo.ROLE == ROLE_MID and (bot:GetStashValue() + bot:GetCourierValue()) > 0)
end
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  GetBot():ActionImmediate_Courier(GetCourier(0), COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS);
end
-------------------------------------------------
return M;
