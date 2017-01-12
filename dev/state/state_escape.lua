local M = {}
local BotActions        = require(GetScriptDirectory().."/dev/bot_actions");
local Game         		  = require(GetScriptDirectory().."/dev/game")
local HeroHelper        = require(GetScriptDirectory().."/dev/helper/hero_helper")
local Danger         	  = require(GetScriptDirectory().."/dev/danger/danger")
-------------------------------------------------
M.Potential = {};
-------------------------------------------------
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
  self.Location = Danger:SafestLocation(GetBot());
  BotActions.ActionMoveToLocation:Call(self.Location);
end
-------------------------------------------------
-------------------------------------------------
function M:Reset()
  -- wat?
end
M:Reset();
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self:Escape(self, BotInfo, Mode, Strategy);
end
-------------------------------------------------
return M;
