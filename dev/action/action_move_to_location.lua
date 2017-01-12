local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
M.name = "Move to Location";
-------------------------------------------------
function M:Call(location)
  local args = {location};
  self.args = args;
  BotInfo:SetAction(self, args);
end

function M:SetArgs()
  self.location = self.args[1];
end

function M:Run()
  self:SetArgs();
  local bot = GetBot();
  bot:Action_MoveToLocation(self.location);
end

function M:Finish()
  self.location = nil;
  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
