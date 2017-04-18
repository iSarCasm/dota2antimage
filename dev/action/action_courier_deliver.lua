local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
M.name = "Courier Deliver";
-------------------------------------------------
function M:Call()
  BotInfo:SetAction(self, {});
end

function M:Run()
  GetBot():ActionImmediate_Courier(GetCourier(0), 6 );
end

function M:Finish()
  GetBot():ActionImmediate_Courier(GetCourier(0), COURIER_ACTION_BURST );
  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
