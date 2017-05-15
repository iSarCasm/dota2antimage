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
  if (mins < 0) then secs = 60 - secs end;
  mils = math.floor(mils * 1000);
  print("[F "..mins..":"..secs.."."..mils.." "..GetBot():GetUnitName().."]\t"..msg);
end

function FGetNearbyHeroes(range, bEnemies)
  if (range > 1599) then
    return GetBot():GetNearbyHeroes(1599, bEnemies, BOT_MODE_NONE);
  else
    local botInfo = GetBot().flex_bot.botInfo;
    local result_heroes = {};
    local heroes = (bEnemies and botInfo.enemy_heroes or botInfo.ally_heroes);
    for i = 1, #heroes do
      if (GetUnitToUnitDistance(bot, heroes[i]) < range) then
        table.insert(result_heroes, heroes[i]);
      end
    end
    return result_heroes;
  end
end

function FGetNearbyCreeps(range, bEnemy)
  if (range > 1599) then
    return GetBot():GetNearbyCreeps(range, bEnemy);
  else
    local botInfo = GetBot().flex_bot.botInfo;
    local result_creeps = {};
    local creeps = (bEnemy and botInfo.enemy_creeps or botInfo.ally_creeps);
    for i = 1, #creeps do
      if (GetUnitToUnitDistance(bot, creeps[i]) < range) then
        table.insert(result_creeps, creeps[i]);
      end
    end
    return result_creeps;
  end
 end