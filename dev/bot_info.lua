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

function M:CanBuyNextItem()
  return (GetBot():GetGold() >= GetItemCost(self[GetBot():GetUnitName()].itemBuild[1]));
end

function M:SetAction(action)
  local name = GetBot():GetUnitName();
  self[name].actionAssigned = true;
  if (self[name].action and self[name].actionWasSet ~= DotaTime()) then
    if (self[name].action ~= action) then
      self[name].action:Finish();
      if (self[name].action == nil) then
        self[name].actionWasSet = DotaTime();
        self[name].action = action;
      end
    end
  else
    self[name].actionWasSet = DotaTime();
    self[name].action = action;
  end
end

function M:Act()
  local name = GetBot():GetUnitName();
  if (self[name].action) then
    if (self[name].actionAssigned) then
      self[name].action:Run();
    else
      self[name].action:Finish();
    end
  end
  self[name].actionAssigned = false;
end

function M:ClearAction()
  local name = GetBot():GetUnitName();
  self[name].action = nil;
end

function M:ActionName()
  local name = GetBot():GetUnitName();
  if (self[name].action and self[name].actionAssigned) then
    return self[name].action.name;
  else
    return "nil";
  end
end

function M:GatherData()
  local bot = GetBot();
  local name = bot:GetUnitName();
  if ((DotaTime() - self[name].lastHealthCapture) > 0.35) then
    self[name].lastHealthCapture = DotaTime();
    self[name].lastHealth = self[name].health;
    self[name].health = bot:GetHealth();
    self[name].healthDelta = self[name].health - self[name].lastHealth;
  end
end

return M;
