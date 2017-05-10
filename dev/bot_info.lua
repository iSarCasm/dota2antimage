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
  local bot = GetBot();
  if ((DotaTime() - self.lastHealthCapture) > 0.35) then
    self.lastHealthCapture = DotaTime();
    self.lastHealth = self.health;
    self.health = bot:GetHealth();
    self.healthDelta = self.health - self.lastHealth;
  end
  self.enemy_heroes = bot:GetNearbyHeroes(1599, true, BOT_MODE_NONE);
  self.ally_heroes = bot:GetNearbyHeroes(1599, false, BOT_MODE_NONE);
end

function BotInfo:ResetTempVars()
  self.enemy_heroes = {};
  self.ally_heroes = {};
end
--------------------------------------------------------
function BotInfo:GetNearbyHeroes(range, bEnemies, mode)
  if (range > 1599) then
    return GetBot():GetNearbyHeroes(1599, bEnemies, BOT_MODE_NONE);
  else
    if (bEnemies) then
      local heroes = self.enemy_heroes;
      local result_heroes = {};
      for i = 1, #heroes do
        if (GetUnitToUnitDistance(bot, heroes[i]) < range) then
          table.insert(result_heroes, heroes[i]);
        end
      end
      return result_heroes;
    else
      local heroes = self.ally_heroes;
      local result_heroes = {};
      for i = 1, #heroes do
        if (GetUnitToUnitDistance(bot, heroes[i]) < range) then
          table.insert(result_heroes, heroes[i]);
        end
      end
      return result_heroes;
    end
  end
end
--------------------------------------------------------
return BotInfo;
