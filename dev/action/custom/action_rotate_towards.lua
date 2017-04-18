local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
local VectorHelper = require(GetScriptDirectory().."/dev/helper/vector_helper")
M.name = "Rotate Towards";
-------------------------------------------------
function M:Call(point)
  local args = {point}
  self.args = args;
  BotInfo:SetAction(self, args);
end

function M:SetArgs()
  self.point = self.args[1];
end

function M:Run()
  self:SetArgs();
  local bot = GetBot();
  local towards_vector = VectorHelper:Normalize(self.point - bot:GetLocation());
  bot:Action_MoveToLocation(bot:GetLocation() + towards_vector);
end

function M:Finish()
  self.point = nil;
  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
