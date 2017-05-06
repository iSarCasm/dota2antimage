function GetShop()
  if (GetTeam() == TEAM_RADIANT) then
    return SHOP_RADIANT;
  elseif (GetTeam() == TEAM_DIRE) then
    return SHOP_DIRE;
  end
end

function GetEnemyTeam()
  if (GetTeam() == TEAM_RADIANT) then
    return TEAM_DIRE;
  elseif (GetTeam() == TEAM_DIRE) then
    return TEAM_RADIANT;
  end
end

function GetFront(Team, Lane)
  return GetLaneFrontLocation(Team, Lane, GetLaneFrontAmount(Team, Lane, true));
end

function Lerp(a, b, t)
  return a + (b - a) * t;
end