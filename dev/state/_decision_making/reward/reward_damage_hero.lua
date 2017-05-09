local RewardDamageHero = {};
-----------------------------------------
function RewardDamageHero:Hero( hHero, damage )
  return 1 * (damage - hHero:GetHealthRegen() * 3);
end
-----------------------------------------
return RewardDamageHero;
