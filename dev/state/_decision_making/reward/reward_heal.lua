local RewardHeal = {};
-----------------------------------------
RewardHeal.Multiplayer = 0.025;
-----------------------------------------
function RewardHeal:Fountain()
  local bot = GetBot();
  local hp = bot:GetHealth();
  local hp_max = bot:GetMaxHealth();
  local mp = bot:GetMana();
  local mp_max = bot:GetMaxMana();
  return ((hp_max - hp) + (mp_max - mp)) * self.Multiplayer;
end
-----------------------------------------
return RewardHeal;
