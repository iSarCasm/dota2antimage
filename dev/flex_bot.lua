local TeamStrategy    = require(GetScriptDirectory().."/dev/team_strategy");
local BotMode         = require(GetScriptDirectory().."/dev/bot_mode");
local BotState        = require(GetScriptDirectory().."/dev/bot_state");
local AbilityItems    = require(GetScriptDirectory().."/dev/abilities/ability_items")
--------------------------------------------------------
local FlexBot = {};
--------------------------------------------------------

function FlexBot:new(BotInfo)
    local flex_bot = {};
    setmetatable(flex_bot, self);
    self.__index = self;
    flex_bot.botInfo = BotInfo;
    flex_bot.botMode = BotMode:new();
    flex_bot.botState = BotState:new();
    GetBot().flexBot = flex_bot; -- make flexBot accessible from any part of code via GetBot().flexBot
    return flex_bot;
end
--------------------------------------------------------
function FlexBot:Think()
  TeamStrategy:Update();
  self.botMode:Update(TeamStrategy.Strategy);
  self.botState:Update(self.botInfo, self.botMode.Mode, TeamStrategy.Strategy);
end
--------------------------------------------------------
--------------------------------------------------------
function DebugStatesFields()
  DebugDrawText(25, 100, "Strategy: "..TeamStrategy.Strategy, 255, 255, 255);
  DebugDrawText(25, 120, "Mode: "..BotMode.Mode, 255, 255, 255);
  DebugDrawText(25, 140, "State: "..BotState.State.." "..BotState:ArgumentString(), 255, 255, 255);
end

function DebugStats()
  DebugDrawText(25, 50, "LH/D = "..GetBot():GetLastHits().."/"..GetBot():GetDenies(), 255, 255, 255);
end
--------------------------------------------------------
return FlexBot;