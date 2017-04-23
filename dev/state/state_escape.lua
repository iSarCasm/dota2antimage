local M = {}
local BotActions        = require(GetScriptDirectory().."/dev/bot_actions");
local Game         		  = require(GetScriptDirectory().."/dev/game")
local HeroHelper        = require(GetScriptDirectory().."/dev/helper/hero_helper")
local Danger         	  = require(GetScriptDirectory().."/dev/danger/danger")
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
  if (HeroHelper:TooDangerous(bot)) then
    return 999;
  else
    return 0;
  end
end
-------------------------------------------------
-------------------------------------------------
function M.Escape(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  local location = Danger:SafestLocation(bot);
  bot:Action_MoveToLocation(location);
end
-------------------------------------------------
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self:Escape(self, BotInfo, Mode, Strategy);
end
-------------------------------------------------
return M;
