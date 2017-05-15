local RewardHeal = {};
-----------------------------------------
RewardHeal.Multiplayer = 0.075;
-----------------------------------------
function RewardHeal:Fountain()
  local bot = GetBot();
  local hp = bot:GetHealth();
  local hp_max = bot:GetMaxHealth();
  local mp = bot:GetMana();
  local mp_max = bot:GetMaxMana();
  local low_health_multy = 1;
  if (hp < 200) then 
    low_health_multy = 4;
  end
  return ((hp_max - hp) + (mp_max - mp)) * low_health_multy * self.Multiplayer;
end

function RewardHeal:Shrine( hShrine )
  return self:Fountain();
end

function RewardHeal:Tango()
  local bot = GetBot();
  return Min(115, bot:GetMaxHealth() - bot:GetHealth()) * self.Multiplayer;
end
-----------------------------------------
return RewardHeal;
