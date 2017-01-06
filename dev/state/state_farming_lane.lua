local M = {}
local FarmingLhD = require(GetScriptDirectory().."/dev/state/state_farming_lane/farming_lh_d");
----------------------------------------------
M.FARMING_LH_D = "FARMING_LH_D";
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  if (DotaTime() > 15) then
    return 10;
  else
    return 0
  end
end
-------------------------------------------------
----------------------------------------------
M.StateMachine = {}
M.StateMachine[M.FARMING_LH_D] = FarmingLhD;
-------------------------------------------------
function M:Reset()
  self.StateMachine.State = self.FARMING_LH_D;
end
M:Reset();
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self.StateMachine[self.StateMachine.State]:Run(self, BotInfo, Mode, Strategy);
end

return M;
