local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper")
M.name = "PT Switch Ability";
-------------------------------------------------
function M:Call(ability, second)
  local args = {ability, second};
  self.args = args;
  BotInfo:SetAction(self, {ability, second});
end

function M:SetArgs()
  self.combo = {};
  if (not self.state) then self.state = 1 end;
  self.ability = self.args[1];
  self.second = self.args[2];
  for i = 1, 4 do
    self.combo[i] = {};
    if (i == 2) then  -- if its STR -> INT
      self.combo[i].ability = self.ability;
      if (self.second) then
        if (type(self.second) == "number") then
          self.combo[i].tree = self.second;
        elseif (self.second.GetUnitName) then
          self.combo[i].target = self.second;
        else  -- this is vector, right?
          self.combo[i].location = self.second;
        end
      end
    else
      self.combo[i].ability = "item_power_treads";
    end
  end
end

function M:UseAbility(ability)
  local bot = GetBot();
  if (ability:IsFullyCastable()) then -- wtf
    if (self.combo[self.state].location) then
      print("Usinig ability ["..ability:GetName().."] at "..self.combo[self.state].location.x.." "..self.combo[self.state].location.y);
      bot:Action_UseAbilityOnLocation(ability, self.combo[self.state].location);
    elseif (self.combo[self.state].target) then
      print("Usinig ability ["..ability:GetName().."] on entity "..self.combo[self.state].target:GetUnitName());
      bot:Action_UseAbilityOnEntity(ability, self.combo[self.state].target);
    elseif (self.combo[self.state].tree) then
      print("Usinig ability ["..ability:GetName().."] on tree "..self.combo[self.state].tree);
      bot:Action_UseAbilityOnTree(ability, self.combo[self.state].tree);
    else
      print("Usinig ability ["..ability:GetName().."]");
      bot:Action_UseAbility(ability);
      if (ability:IsItem()) then
        print("stat is "..ability:GetPowerTreadsStat());
        self.state = self.state + 1;
      end
    end
  else
    self.state = self.state + 1; -- next spell
  end
end

function M:Run()
  self:SetArgs();
  local bot = GetBot();
  local ability = self.combo[self.state].ability;
  if (type(ability) == "string") then
    ability = bot:GetAbilityByName(ability) or InventoryHelper:GetItemByName(bot, ability, true);
  end
  if (ability and self.state <= 2) then  -- if its STR -> INT
    self:UseAbility(ability)
  else
    self:Finish();
  end
end



function M:Finish()
  if (self.state >= 5) then
    self.combo = {}
    self.ability = nil;
    self.second = nil
    self.state = nil;
    BotInfo:ClearAction();
  else
    local bot = GetBot();
    local ability = self.combo[self.state].ability;
    if (type(ability) == "string") then
      ability = bot:GetAbilityByName(ability) or InventoryHelper:GetItemByName(bot, ability, true);
    end
    self:UseAbility(ability)
  end
end
-------------------------------------------------
return M;
