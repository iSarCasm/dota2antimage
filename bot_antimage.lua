--------------------------------------------------------
require(GetScriptDirectory().."/dev/constants/roles");
local TeamStrategy    = require(GetScriptDirectory().."/dev/team_strategy");
local BotMode         = require(GetScriptDirectory().."/dev/bot_mode");
local BotState        = require(GetScriptDirectory().."/dev/bot_state");
--------------------------------------------------------
--------------------------------------------------------
local BotInfo = {};
      BotInfo.LANE = LANE_TOP;
      BotInfo.ROLE = ROLE_CARRY;
--------------------------------------------------------
--------------------------------------------------------
function DebugStatesFields()
  DebugDrawText(25, 100, "Strategy: "..TeamStrategy.Strategy, 255, 255, 255);
  DebugDrawText(25, 120, "Mode: "..BotMode.Mode, 255, 255, 255);
  DebugDrawText(25, 140, "State: "..BotState.State, 255, 255, 255);
end
--------------------------------------------------------
function Think(  )
  TeamStrategy:Update();
  BotMode:Update(BotInfo, TeamStrategy.Strategy);
  BotState:Act(BotInfo, BotMode.Mode, TeamStrategy.Strategy);
  DebugStatesFields();
end
