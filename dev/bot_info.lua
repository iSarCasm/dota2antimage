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

  self[name].action = nil;
end

function M:Me()
  return self[GetBot():GetUnitName()];
end

function M:SetAction(action)
  local name = GetBot():GetUnitName();
  if (self[name].action) then
    if (self[name].action ~= action) then
      self[name].action:Finish();
    end
  else
    self[name].action = action;
    action:Run();
  end
end

function M:Act()
  local name = GetBot():GetUnitName();
  if (self[name].action) then
    self[name].action:Run();
  end
end

function M:ClearAction()
  local name = GetBot():GetUnitName();
  self[name].action = nil;
end

function M:ActionName()
  local name = GetBot():GetUnitName();
  if (self[name].action) then
    return self[name].action.name;
  else
    return "nil";
  end
end

function M:GatherData()
  local bot = GetBot();
  local name = bot:GetUnitName();
  if ((DotaTime() - self[name].lastHealthCapture) > 0.75) then
    self[name].lastHealthCapture = DotaTime();
    self[name].lastHealth = self[name].health;
    self[name].health = bot:GetHealth();
    self[name].healthDelta = self[name].health - self[name].lastHealth;
  end
end

return M;
