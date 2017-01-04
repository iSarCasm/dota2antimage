local M = {}
-------------------------------------------------
function M:Run(target)
  local bot = GetBot();
  if (self.attackMoment == nil) then
    self.attackMoment = DotaTime();
    print('attack attack attack attack attack');
    bot:Action_AttackUnit(target, true);
  else
    print("x  "..(DotaTime() - self.attackMoment));
    if ((DotaTime() - self.attackMoment) > 0.25) then
      self:Finish();
    end
  end
end

function M:Finish()
  print('cancel cancel cancel cancel cancel');
  local bot = GetBot();
  self.attackMoment = nil;
  bot:Action_ClearActions(true);
end
-------------------------------------------------
return M;
