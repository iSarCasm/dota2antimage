local RewardDamageCreep = {};
-----------------------------------------
function RewardDamageCreep:Creep( hCreep, damage )
  if (hCreep:GetTeam() == TEAM_NEUTRAL) then return 0 end

  if (hCreep:GetHealth() <= damage) then
    local necro = GetBot():GetModifierByName("modifier_nevermore_necromastery");
    if (necro) then
      if (GetBot():GetModifierStackCount(necro) < 10) then
        return 240;
      else
        return 40; -- ~avg creep bounty
      end
    else
      return 40; -- ~avg creep bounty
    end
  else
    return damage * 0.2;
  end
end
-----------------------------------------
return RewardDamageCreep;
