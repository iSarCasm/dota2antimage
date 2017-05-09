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

function Safelane()
  return ((GetTeam() == TEAM_RADIANT) and LANE_BOT or LANE_TOP);
end

function Hardlane()
  return ((GetTeam() == TEAM_RADIANT) and LANE_TOP or LANE_BOT);
end

function fprint(msg)
  local mils = DotaTime() % 1;
  local mins = math.floor(DotaTime() / 60);
  if (mins < 0) then mins = mins + 1 end;
  local secs = math.floor(DotaTime() % 60);
  mils = math.floor(mils * 1000);
  print("[F "..mins..":"..secs.."."..mils.." "..GetBot():GetUnitName().."]\t"..msg);
end

