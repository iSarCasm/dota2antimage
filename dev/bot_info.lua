local MapHelper   = require(GetScriptDirectory().."/dev/helper/map_helper");
local UnitHelper  = require(GetScriptDirectory().."/dev/helper/unit_helper");
--------------------------------------------------------
local BotInfo = {}
--------------------------------------------------------
function BotInfo:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function BotInfo:Init(lane, role)
  self.LANE = lane;
  self.ROLE = role;

  self.lastHealth = 0;
  self.health = 0;
  self.lastHealthCapture = DotaTime();
  self.healthDelta = 0;
end
--------------------------------------------------------
function BotInfo:CanBuyNextItem()
  return (GetBot():GetGold() >= GetItemCost(self.itemBuild[1]));
end
--------------------------------------------------------
function BotInfo:GatherData()
  self:ResetTempVars();
  local bot = GetBot();
  local pos = bot:GetLocation();

  if ((DotaTime() - self.lastHealthCapture) > 0.35) then
    self.lastHealthCapture = DotaTime();
    self.lastHealth = self.health;
    self.health = bot:GetHealth();
    self.healthDelta = self.health - self.lastHealth;
  end

  self.enemy_heroes = bot:GetNearbyHeroes(1599, true, BOT_MODE_NONE);
  self.ally_heroes = bot:GetNearbyHeroes(1599, false, BOT_MODE_NONE);
  self.enemy_creeps = bot:GetNearbyCreeps(1599, true);
  self.ally_creeps = bot:GetNearbyCreeps(1599, false);
  self.nearby_ally_creeps = bot:GetNearbyCreeps(500, false);
  self.tower = MapHelper:GetFrontTowerAt(UnitHelper:GetUnitLane(bot));
  self.enemy_tower = MapHelper:GetEnemyFrontTowerAt(UnitHelper:GetUnitLane(bot));
  self.enemyVector = Vector(0, 0);
  self.allyVector = Vector(0, 0);
  self.nearbyAllyVector = Vector(0, 0);
  self.towerVector = Vector(0, 0);

  -- Enemy Creep Vector
  local positions_count = 0;
  for _,creep in pairs(self.enemy_creeps)
  do
    if (creep:IsAlive()) then
      local creep_pos = creep:GetLocation();
      -- result
      self.enemyVector[1] = self.enemyVector[1] + creep_pos[1];
      self.enemyVector[2] = self.enemyVector[2] + creep_pos[2];
      positions_count = positions_count + 1;
    end
  end
  if (positions_count > 0) then
    self.enemyVector[1] = self.enemyVector[1] / positions_count;
    self.enemyVector[2] = self.enemyVector[2] / positions_count;
  else
    self.enemyVector = nil;
  end
  -- Ally Creep Vector
  positions_count = 0;
  for _,creep in pairs(self.ally_creeps)
  do
    if (creep:IsAlive()) then
      local creep_pos = creep:GetLocation();
      -- result
      self.allyVector[1] = self.allyVector[1] + creep_pos[1];
      self.allyVector[2] = self.allyVector[2] + creep_pos[2];
      positions_count = positions_count + 1;
    end
  end
  if (positions_count > 0) then
    self.allyVector[1] = self.allyVector[1] / positions_count;
    self.allyVector[2] = self.allyVector[2] / positions_count;
  else
    self.allyVector = nil;
  end
   -- Nearby Ally Creep Vector
  positions_count = 0;
  for _,creep in pairs(self.nearby_ally_creeps)
  do
    if (creep:IsAlive()) then
      local creep_pos = creep:GetLocation();
      -- result
      self.nearbyAllyVector[1] = self.nearbyAllyVector[1] + creep_pos[1];
      self.nearbyAllyVector[2] = self.nearbyAllyVector[2] + creep_pos[2];
      positions_count = positions_count + 1;
    end
  end
  if (positions_count > 0) then
    self.nearbyAllyVector[1] = self.nearbyAllyVector[1] / positions_count;
    self.nearbyAllyVector[2] = self.nearbyAllyVector[2] / positions_count;
  else
    self.nearbyAllyVector = nil;
  end
  -- Tower Vector
  if (self.tower) then
    self.towerVector = self.tower:GetLocation();
  end
end

function BotInfo:ResetTempVars()
  self.enemy_heroes = {};
  self.ally_heroes = {};
  self.enemy_creeps = {};
  self.ally_creeps = {};
  self.nearby_ally_creeps = {};
  self.tower = nil;
  self.enemy_tower = nil;
  self.enemyVector = nil;
  self.nearbyAllyVector = nil;
  self.allyVector = nil
  self.towerVector = nil;
end
--------------------------------------------------------
return BotInfo;
