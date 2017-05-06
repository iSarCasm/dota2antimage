local EffortSpendMana = {}
----------------------------------------------------
function EffortSpendMana:Mana( mana )
  local bot = GetBot();
  local mana_regen = bot:GetManaRegen();
  return Max(0, 0.03 * (mana - mana_regen * 15));
end
----------------------------------------------------
return EffortSpendMana;
