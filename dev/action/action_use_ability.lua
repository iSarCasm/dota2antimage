local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper")
M.name = "Use Ability";
-------------------------------------------------
function M:Call(ability, second)
  self.ability = ability;
  if (second) then
    if (type(second) == "number") then
      self.tree = second;
    elseif (second.GetUnitName) then
      self.target = second;
    else  -- this is vector, right?
      self.location = second;
    end
  end
  if (ability == "item_tango") then
    print("second is "..second);
    print("tree set? "..(self.tree and self.tree or "nope"));
    print("target set? "..(self.target and self.target or "nope"));
    print("location set? "..(self.location and self.location or "nope"));
  end
  BotInfo:SetAction(self);
end

function M:Run()
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
