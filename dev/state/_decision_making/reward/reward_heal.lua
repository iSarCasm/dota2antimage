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
  return ((hp_max - hp) * self:LowHealthK() + (mp_max - mp)) ;
end

function RewardHeal:Shrine( hShrine )
  return self:Fountain();
end

function RewardHeal:Tango()
  local bot = GetBot();
  return Min(115, bot:GetMaxHealth() - bot:GetHealth()) * self:LowHealthK();
end

function RewardHeal:LowHealthK()
  if (GetBot():GetHealth() < 200) then 
    return 1.75;
  end
  return 1;
end
-----------------------------------------
return RewardHeal;
