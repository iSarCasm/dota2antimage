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
    return 18;
  else
    if (GetBot():TimeSinceDamagedByTower() < 1) then
      return 29;
    elseif (GetBot():TimeSinceDamagedByTower() < 2) then
      return 24;
    elseif (GetBot():TimeSinceDamagedByCreep() < 0.75) then
      return 19;
    elseif (GetBot():WasRecentlyDamagedByAnyHero(0.15)) then
      return 10;
    elseif (GetBot():TimeSinceDamagedByCreep() < 1) then
      return 7;
    end
  end
  return 0;
end
-------------------------------------------------
-------------------------------------------------
function M.Escape(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  local location = Danger:SafestLocation(bot);
  DebugDrawCircle(location, 55, 0, 0 ,255);
  BotActions.MoveToLocation:Call(location);
end
-------------------------------------------------
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self:Escape(self, BotInfo, Mode, Strategy);
end
-------------------------------------------------
return M;
