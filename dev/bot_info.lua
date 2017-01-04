local M = {}

function M:Init(lane, role)
  local name = GetBot():GetUnitName();
  self[name] = {};
  self[name].LANE = lane;
  self[name].ROLE = role;
  self[name].lastHealth = 0;
  self[name].health = 0;
  self[name].lastHealthCapture = DotaTime();
  self[name].healthDelta = 0;
end

function M:GatherData()
  local bot = GetBot();
  local name = bot:GetUnitName();
  if ((DotaTime() - self[name].lastHealthCapture) > 0.25) then
    self[name].lastHealthCapture = DotaTime();
    self[name].lastHealth = self[name].health;
    self[name].health = bot:GetHealth();
    self[name].healthDelta = self[name].health - self[name].lastHealth;
  end
end

return M;
