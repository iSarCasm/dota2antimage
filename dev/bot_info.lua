local M = {}

function M:Init(lane, role)
  self.LANE = lane;
  self.ROLE = role;

  self.lastHealth = 0;
  self.health = 0;
  self.lastHealthCapture = DotaTime();
  self.healthDelta = 0;
end

function M:CanBuyNextItem()
  return (GetBot():GetGold() >= GetItemCost(self.itemBuild[1]));
end

function M:GatherData()
  local bot = GetBot();
  if ((DotaTime() - self.lastHealthCapture) > 0.35) then
    self.lastHealthCapture = DotaTime();
    self.lastHealth = self.health;
    self.health = bot:GetHealth();
    self.healthDelta = self.health - self.lastHealth;
  end
end

return M;
