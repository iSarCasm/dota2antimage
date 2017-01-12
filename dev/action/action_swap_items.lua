local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
M.name = "Swap Items";
-------------------------------------------------
function M:Call(slot_1, slot_2)
  local args = {slot_1, slot_2};
  self.args = args;
  BotInfo:SetAction(self, args);
end

function M:SetArgs()
  self.slot_1 = self.args[1];
  self.slot_2 = self.args[2];
end

function M:Run()
  self:SetArgs();
  local bot = GetBot();
  bot:Action_SwapItems(self.slot_1, self.slot_2);
end

function M:Finish()
  self.slot_1 = nil;
  self.slot_2 = nil;
  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
