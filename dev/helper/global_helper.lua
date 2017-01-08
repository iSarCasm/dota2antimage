function GetShop()
  if (GetTeam() == TEAM_RADIANT) then
    return SHOP_RADIANT;
  elseif (GetTeam() == TEAM_DIRE) then
    return SHOP_DIRE;
  end
end
