local M = {}
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper")
M.name = "Use Combo Ability";
-------------------------------------------------
function M:Call(spells)
  self.combo = {};
  if (not self.state) then self.state = 1 end;
  if (spells) then
    for i = 1, 10 do
      self.combo[i] = {};
      if (spells[i]) then
        self.combo[i].ability = spells[i][1];
        if (spells[i][2]) then
          if (type(spells[i][2]) == "number") then
            self.combo[i].tree = spells[i][2];
          elseif (spells[i][2].GetUnitName) then
            self.combo[i].target = spells[i][2];
          else  -- this is vector, right?
            print("called with location")
            self.combo[i].location = spells[i][2];
          end
        end
      end
    end
  end
  BotInfo:SetAction(self);
end

function M:Run()
  local bot = GetBot();
  print("state is "..self.state);
  local ability = self.combo[self.state].ability;
  if (type(ability) == "string") then
    ability = bot:GetAbilityByName(ability) or InventoryHelper:GetItemByName(bot, ability, true);
  end
  if (ability) then
    print(ability:GetName());
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
          self.state = self.state + 1;
        end
      end
    else
      print("Spell inc Spell incSpell inc Spell incSpell inc Spell incSpell inc Spell incSpell inc Spell inc");
      self.state = self.state + 1; -- next spell
    end
    print("state updated to "..self.state)
  else
    self:Finish();
  end
end

function M:Finish()
  self.combo = {}
  self.state = nil;
  BotInfo:ClearAction();
end
-------------------------------------------------
return M;
