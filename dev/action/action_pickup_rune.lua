local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
M.name = "PickUp Rune";
-------------------------------------------------
function M:Call(rune)
  self.rune = rune;
  BotInfo:SetAction(self);
end

function M:Run()
  local bot = GetBot();
  bot:Action_PickUpRune(self.rune);
end

function M:Finish()
  self.rune = nil;
  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
