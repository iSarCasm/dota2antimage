--------------------------------------------------------
require(GetScriptDirectory().."/dev/constants/roles");
local TeamStrategy    = require(GetScriptDirectory().."/dev/team_strategy");
local BotMode         = require(GetScriptDirectory().."/dev/bot_mode");
local BotState        = require(GetScriptDirectory().."/dev/bot_state");
local BotInfo         = require(GetScriptDirectory().."/dev/bot_info")
--------------------------------------------------------
--------------------------------------------------------
BotInfo:Init(LANE_TOP, ROLE_CARRY);
--------------------------------------------------------
--------------------------------------------------------
function DebugStatesFields()
  DebugDrawText(25, 100, "Strategy: "..TeamStrategy.Strategy, 255, 255, 255);
  DebugDrawText(25, 120, "Mode: "..BotMode.Mode, 255, 255, 255);
  DebugDrawText(25, 140, "State: "..BotState.State, 255, 255, 255);
  DebugDrawText(25, 160, "Mini-State: "..BotState:MiniState(), 255, 255, 255);
  DebugDrawText(25, 180, "Action: "..BotInfo:ActionName(), 255, 255, 255)
end
--------------------------------------------------------
function Think(  )
  local MyInfo = BotInfo[GetBot():GetUnitName()];

  TeamStrategy:Update();
  BotMode:Update(MyInfo, TeamStrategy.Strategy);
  BotState:Act(MyInfo, BotMode.Mode, TeamStrategy.Strategy);
  BotInfo:Act();

  BotInfo:GatherData();
  DebugStatesFields();
end
