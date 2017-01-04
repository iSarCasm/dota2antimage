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
  print("cancel attack");
  if (self.attackMoment == nil) then
    print("didnt attack");
    self.attackMoment = DotaTime();
    bot:Action_AttackUnit(self.target, true);
  else
    print("waiting "..(DotaTime() - self.attackMoment));
    if ((DotaTime() - self.attackMoment) > bot:GetAttackPoint()*0.5) then
      self:Finish();
    end
  end
end

function M:Finish()
  print("finish");
  local bot = GetBot();
  self.attackMoment = nil;
  bot:Action_ClearActions(true);

  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
