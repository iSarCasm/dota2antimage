local RewardHarassHero = {};
-----------------------------------------
function RewardHarassHero:Hero( hHero, damage )
  return 1 * (damage - hHero:GetHealthRegen() * 3);
end
-----------------------------------------
return RewardHarassHero;
