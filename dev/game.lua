local Game = {};
----------------------------------------------
Game.RuneStates = {}
Game.RuneStates[RUNE_BOUNTY_1] = RUNE_STATUS_MISSING;
Game.RuneStates[RUNE_BOUNTY_2] = RUNE_STATUS_MISSING;
Game.RuneStates[RUNE_BOUNTY_3] = RUNE_STATUS_MISSING;
Game.RuneStates[RUNE_BOUNTY_4] = RUNE_STATUS_MISSING;
Game.RuneStates[RUNE_POWERUP_1] = RUNE_STATUS_MISSING;
Game.RuneStates[RUNE_POWERUP_2] = RUNE_STATUS_MISSING;

Game.JungleStates = {}
Game.JungleStates[JUNGLE_DIRE_MID_BIG] = 0;
Game.JungleStates[JUNGLE_DIRE_MID_MID] = 0;
Game.JungleStates[JUNGLE_DIRE_TOP_MID] = 0;
Game.JungleStates[JUNGLE_DIRE_TOP_SMALL] = 0;
Game.JungleStates[JUNGLE_DIRE_TOP_BIG] = 0;
Game.JungleStates[JUNGLE_DIRE_TOP_ANCIENT] = 0;
Game.JungleStates[JUNGLE_DIRE_BOT_MID] = 0;
Game.JungleStates[JUNGLE_DIRE_BOT_SMALL] = 0;
Game.JungleStates[JUNGLE_DIRE_BOT_ANCIENT] = 0;
Game.JungleStates[JUNGLE_RADIANT_MID_MID] = 0;
Game.JungleStates[JUNGLE_RADIANT_MID_BIG] = 0;
Game.JungleStates[JUNGLE_RADIANT_BOT_MID] = 0;
Game.JungleStates[JUNGLE_RADIANT_BOT_SMALL] = 0;
Game.JungleStates[JUNGLE_RADIANT_BOT_BIG] = 0;
Game.JungleStates[JUNGLE_RADIANT_BOT_ANCIENT] = 0;
Game.JungleStates[JUNGLE_RADIANT_TOP_BIG] = 0;
Game.JungleStates[JUNGLE_RADIANT_TOP_MID] = 0;
Game.JungleStates[JUNGLE_RADIANT_TOP_ANCIENT] = 0;

Game.Towers = {}
Game.Shrines = {}
----------------------------------------------
----------------------------------------------
function Game:TimeToRune(rune)
  if (self.RuneStates[rune] == RUNE_STATUS_MISSING) then
    if (DotaTime() < 0) then
      return -DotaTime();
    else
      return 120 - math.mod(DotaTime(), 120);
    end
  else
    return 0;
  end
end

function Game:TimeToJungle(jungle)
  if (self.JungleStates[jungle] > 0) then
    return 0;
  else
    if (DotaTime() < 30) then
      return 30 - DotaTime();
    else
      return 120 - math.mod(DotaTime()+60, 120)
    end
  end
end

function Game:TimeToCreeps(lane)
  local distance = VectorHelper.Length(GetFront(GetTeam(), lane) - GetFront(GetEnemyTeam(), lane));
  if (distance < 200) then
    return 0;
  else
    return ((DotaTime() < 30) and -DotaTime()+30 or distance/325);
  end
end

function Game:GetTowersForTeam(team)
  local team_towers = {};
  for i = 1, #self.Towers do
    local tower = self.Towers[i];
    if ((not tower:IsNull()) and tower:GetTeam() == team) then
      table.insert(team_towers, tower);
    end
  end
  return team_towers;
end

function Game:GetShrinesForTeam(team)
  local shrines = {};
  local all_shrines = {
    GetShrine(team, SHRINE_BASE_1),
    GetShrine(team, SHRINE_BASE_2),
    GetShrine(team, SHRINE_BASE_3),
    GetShrine(team, SHRINE_BASE_4),
    GetShrine(team, SHRINE_BASE_5),
    GetShrine(team, SHRINE_JUNGLE_1),
    GetShrine(team, SHRINE_JUNGLE_2)
  }
  for i = 1, #all_shrines do 
    if (all_shrines[i] and not all_shrines[i]:IsNull()) then
      table.insert(shrines, all_shrines[i]);
    end
  end
  return shrines;
end
----------------------------------------------
----------------------------------------------
function Game:UpdateRunes()
  local runes = { RUNE_BOUNTY_1, RUNE_BOUNTY_2, RUNE_BOUNTY_3, RUNE_BOUNTY_4, RUNE_POWERUP_1, RUNE_POWERUP_2 }
  for i = 1, #runes do
    local rune = runes[i];
    local isBounty =  (rune ~= RUNE_POWERUP_1 and rune ~= RUNE_POWERUP_2);

    if (((isBounty or DotaTime() >= 120) and DotaTime() >=0) and (math.mod(math.floor(DotaTime()), 120) == 0)) then
      self.RuneStates[rune] = RUNE_STATUS_UNKNOWN;
    end

    local status = GetRuneStatus(rune);
    if (status ~= RUNE_STATUS_UNKNOWN) then
      self.RuneStates[rune] = status;
    end

    -- DebugDrawText(25, 700 + i*20, "Rune "..rune.." status is: "..self.RuneStates[rune].."("..GetRuneStatus(rune)..")", 255, 255, 255);
  end
end

function Game:UpdateJungle()
  local bot = GetBot();
  for jungle = 1, JUNGLE_TOTAL do
    local jungle_location = JUNGLE_CAMP[jungle].Location;
    if (GetUnitToLocationDistance(bot, jungle_location) < 300) then
      local creeps = FGetNearbyCreeps(600, true);
      -- print("creeps "..#creeps);
      if (#creeps == 0) then
        self.JungleStates[jungle] = 0;
      else
        self.JungleStates[jungle] = 1; --bad, no stacks
      end
    end
    -- print("jungle "..JUNGLE_CAMP[jungle].Name.." "..self.JungleStates[jungle]);
  end

  if (math.floor(DotaTime()) == 30 or math.floor((120 - math.mod(DotaTime()+60, 120))) == 0) then
    for jungle = 1, JUNGLE_TOTAL do
      self.JungleStates[jungle] = 1; -- bad, no stacks
    end
  end
end

function Game:InitializeUnits()
  self.Towers = {};
  -- local units = GetUnitList(UNIT_LIST_ALL);
  -- for i = 1, #units do
  --   local unit = units[i];
  --   if (unit:IsTower()) then
  --     table.insert(self.Towers, unit);
  --   end
  -- end
  table.insert(self.Towers, GetTower(TEAM_RADIANT, TOWER_TOP_1));
  table.insert(self.Towers, GetTower(TEAM_RADIANT, TOWER_MID_1));
  table.insert(self.Towers, GetTower(TEAM_RADIANT, TOWER_BOT_1));
  table.insert(self.Towers, GetTower(TEAM_RADIANT, TOWER_TOP_2));
  table.insert(self.Towers, GetTower(TEAM_RADIANT, TOWER_MID_2));
  table.insert(self.Towers, GetTower(TEAM_RADIANT, TOWER_BOT_2));
  table.insert(self.Towers, GetTower(TEAM_RADIANT, TOWER_TOP_3));
  table.insert(self.Towers, GetTower(TEAM_RADIANT, TOWER_MID_3));
  table.insert(self.Towers, GetTower(TEAM_RADIANT, TOWER_BOT_3));
  table.insert(self.Towers, GetTower(TEAM_RADIANT, TOWER_BASE_1));
  table.insert(self.Towers, GetTower(TEAM_RADIANT, TOWER_BASE_2));

  table.insert(self.Towers, GetTower(TEAM_DIRE, TOWER_TOP_1));
  table.insert(self.Towers, GetTower(TEAM_DIRE, TOWER_MID_1));
  table.insert(self.Towers, GetTower(TEAM_DIRE, TOWER_BOT_1));
  table.insert(self.Towers, GetTower(TEAM_DIRE, TOWER_TOP_2));
  table.insert(self.Towers, GetTower(TEAM_DIRE, TOWER_MID_2));
  table.insert(self.Towers, GetTower(TEAM_DIRE, TOWER_BOT_2));
  table.insert(self.Towers, GetTower(TEAM_DIRE, TOWER_TOP_3));
  table.insert(self.Towers, GetTower(TEAM_DIRE, TOWER_MID_3));
  table.insert(self.Towers, GetTower(TEAM_DIRE, TOWER_BOT_3));
  table.insert(self.Towers, GetTower(TEAM_DIRE, TOWER_BASE_1));
  table.insert(self.Towers, GetTower(TEAM_DIRE, TOWER_BASE_2));
end
----------------------------------------------
function Game:Update()
  self:UpdateRunes();
  self:UpdateJungle();
end
----------------------------------------------
----------------------------------------------
return Game;
