--------------------------------------------------------
local DotaBotUtility  = require(GetScriptDirectory().."/dev/utility");
local StateMachine    = require(GetScriptDirectory().."/dev/state_machine");
--------------------------------------------------------
--------------------------------------------------------
local BotInfo = {};
      BotInfo.LANE = LANE_TOP;
--------------------------------------------------------
function Think(  )
  DotaBotUtility:CourierThink();
  StateMachine:Run(BotInfo);
  DebugStateChange();
end
