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
function Think(  )
  TeamStrategy:Update();
  BotMode:Update(BotInfo, TeamStrategy.Strategy);
  BotState:Act(BotInfo, BotMode.Mode, TeamStrategy.Strategy);
end
