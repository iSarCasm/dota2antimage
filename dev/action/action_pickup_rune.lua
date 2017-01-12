local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
M.name = "PickUp Rune";
-------------------------------------------------
function M:Call(rune)
  local args = {rune};
  self.args = args;
  BotInfo:SetAction(self, args);
end

function M:SetArgs()
  self.rune = self.args[1];
end

function M:Run()
  self:SetArgs();
  local bot = GetBot();
  bot:Action_PickUpRune(self.rune);
end

function M:Finish()
  self.rune = nil;
  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
