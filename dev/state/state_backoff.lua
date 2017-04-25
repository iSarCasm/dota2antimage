local M = {}
local BotActions        = require(GetScriptDirectory().."/dev/bot_actions");
local Danger            = require(GetScriptDirectory().."/dev/danger/danger")
-------------------------------------------------
M.Potential = {};
-------------------------------------------------
function M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
--------------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local bot = GetBot();
  if (bot.flex_bot.backoff and bot.flex_bot.backoff > DotaTime()) then
    return 10;
  else
    if (GetBot():TimeSinceDamagedByTower() < 0.5) then
      return 20;
    elseif (GetBot():TimeSinceDamagedByTower() < 1) then
      return 15;
    elseif (GetBot():TimeSinceDamagedByCreep() < 0.5) then
      return 14;
    end
  end
  return 0;
end
-------------------------------------------------
-------------------------------------------------
function M.Escape(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  local location = Danger:SafestLocation(bot);
  BotActions.MoveToLocation:Call(location);
end
-------------------------------------------------
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self:Escape(self, BotInfo, Mode, Strategy);
end
-------------------------------------------------
return M;
