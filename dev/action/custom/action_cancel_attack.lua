local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
M.name = "Cancel Attack";
-------------------------------------------------
function M:Call(target)
  self.target = target;
  BotInfo:SetAction(self);
end

function M:Run()
  local bot = GetBot();
  if (self.attackMoment == nil) then
    self.attackMoment = DotaTime();
    bot:Action_AttackUnit(self.target, true);
  else
    if ((DotaTime() - self.attackMoment) > bot:GetAttackPoint()*0.5) then
      self:Finish();
    end
  end
end

function M:Finish()
  local bot = GetBot();
  self.attackMoment = nil;
  bot:Action_ClearActions(true);

  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
