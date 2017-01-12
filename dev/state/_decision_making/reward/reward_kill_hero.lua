local RewardKillHero = {};
-----------------------------------------
function RewardKillHero:Hero(hero)
  local bot = GetBot();
  local gold = 250;
  local exp = 100;
  local space = 100;
  local him_being_dead = 100;
  return gold + exp + space + him_being_dead;
end
-----------------------------------------
return RewardKillHero;
