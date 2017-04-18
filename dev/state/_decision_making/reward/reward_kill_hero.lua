local RewardKillHero = {};
-----------------------------------------
function RewardKillHero:Hero(hero)
  local bot = GetBot();
  local gold = 250;
  local exp = 100;
  local space = 100;
  local him_being_dead = 100;
  local canKillHim = false;
  if (canKillHim) then
    return gold + exp + space + him_being_dead;
  else
    return 0;
  end
end
-----------------------------------------
return RewardKillHero;
