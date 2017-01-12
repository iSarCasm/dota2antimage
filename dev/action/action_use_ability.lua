local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper")
M.name = "Use Ability";
-------------------------------------------------
function M:Call(ability, second)
  local args = {ability, second};
  self.args = args;
  BotInfo:SetAction(self, args);
end

function M:SetArgs()
  self.ability = self.args[1];
  self.second = self.args[2];
  if (self.second) then
    if (type(self.second) == "number") then
      self.tree = self.second;
    elseif (self.second.GetUnitName) then
      self.target = self.second;
    else  -- this is vector, right?
      self.location = self.second;
    end
  end
  if (self.ability == "item_tango") then
    print("tree set? "..(self.tree and self.tree or "nope"));
    print("target set? "..(self.target and self.target:GetUnitName() or "nope"));
    print("location set? "..(self.location and self.location or "nope"));
  end
end

function M:Run()
  self:SetArgs();
  local bot = GetBot();
  local ability = self.ability;
  if (type(ability) == "string") then
    ability = bot:GetAbilityByName(self.ability) or InventoryHelper:GetItemByName(bot, self.ability, true);
  end
  if (ability) then
    if (self.location) then
      print("Usinig ability ["..self.ability.."] at "..self.location.x.." "..self.location.y);
      bot:Action_UseAbilityOnLocation(ability, self.location);
    elseif (self.target) then
      print("Usinig ability ["..self.ability.."] on entity "..self.target:GetUnitName());
      bot:Action_UseAbilityOnEntity(ability, self.target);
    elseif (self.tree) then
      print("Usinig ability ["..self.ability.."] on tree "..self.tree);
      bot:Action_UseAbilityOnTree(ability, self.tree);
    else
      print("Usinig ability ["..self.ability.."]");
      bot:Action_UseAbility(ability);
    end
  end
end

function M:Finish()
  self.ability = nil;
  self.tree = nil;
  self.location = nil;
  self.target = nil;
  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
