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
function BotInfo:TryTravel( vLocation )
  
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
end
--------------------------------------------------------
return BotInfo;
