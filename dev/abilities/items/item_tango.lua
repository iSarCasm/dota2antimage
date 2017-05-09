local ItemTango = {}
      ItemTango.name = "item_tango";
------------------------------------
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper");
local RewardHeal        = require(GetScriptDirectory().."/dev/state/_decision_making/reward/reward_heal");
local EffortWalk        = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_walk");
local EffortDanger      = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_danger");
------------------------------------
function ItemTango:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.Potential = {};
    return o
end

function ItemTango:Ability()
  return InventoryHelper:GetItemByName(GetBot(), self.name, true);
end
------------------------------------
function ItemTango:InstaUse(Mode, Strategy)
  local bot = GetBot();
  if (not bot:HasModifier("modifier_tango_heal")) then
    if ((bot:GetMaxHealth()-bot:GetHealth()) > 200) then
      local trees = bot:GetNearbyTrees(250);
      if (trees and trees[1]) then
        fprint("insta use");
        bot:Action_UseAbilityOnTree(self:Ability(), trees[1]);
      end
    end
  end
end
------------------------------------
function ItemTango:ArgumentString()
  return self.Tree;
end

function ItemTango:EvaluatePotential()
  if (not self:Ability():IsFullyCastable()) then return -999 end;

  local bot = GetBot();
  local highest = VERY_LOW_INT;
  local trees = bot:GetNearbyTrees(1500);
  if (#trees ~= 0) then
    for i = 1, #trees do
      local tree = trees[i];
      local reward = (bot:HasModifier("modifier_tango_heal") and 0 or RewardHeal:Tango());
      local effort = EffortWalk:ToLocation(GetTreeLocation(tree)) + EffortDanger:OfLocation(GetTreeLocation(tree));
      local potential = reward / effort;

      self.Potential[tree] = potential;
      if (potential > highest) then
        self.Tree = tree;
        highest = potential;
      end
    end
    return self.Potential[self.Tree];
  else
    return -999;
  end
end
------------------------------------
function ItemTango:Run(BotInfo, Mode, Strategy)
  fprint("eval use");
  GetBot():Action_UseAbilityOnTree(self:Ability(), self.Tree);
end
------------------------------------
return ItemTango;
