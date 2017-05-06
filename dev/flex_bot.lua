local TeamStrategy    = require(GetScriptDirectory().."/dev/team_strategy");
local BotMode         = require(GetScriptDirectory().."/dev/bot_mode");
local BotState        = require(GetScriptDirectory().."/dev/bot_state");
local AbilityItems    = require(GetScriptDirectory().."/dev/abilities/ability_items")
local Creeping        = require(GetScriptDirectory().."/dev/state/state_farming_lane/creeping");
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
    flex_bot.abilityItems = AbilityItems:new();
    GetBot().flex_bot = flex_bot; -- make flexBot accessible from any part of code via GetBot().flex_bot
    return flex_bot;
end
--------------------------------------------------------
function FlexBot:ResetTempVars()
  self.moving_location = nil;
end
--------------------------------------------------------
function FlexBot:Think()
  self.botInfo:GatherData();
  Creeping:UpdateLaningState();
  self:ResetTempVars();
  self.botMode:Update(TeamStrategy.Strategy);

  -- local t = RealTime();
  self.botState:Update(self.botInfo, self.botMode.Mode, TeamStrategy.Strategy);
  -- print("    time spent in self.botState:Update "..(RealTime() - t)*1000); t = RealTime();

  self.abilityItems:InstaUse(self.botInfo, self.botMode.Mode, TeamStrategy.Strategy);
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