local BotState = {}
--------------------------------------------------------
local StateWaitCreeps = require(GetScriptDirectory().."/dev/state/state_wait_creeps");
local StateFarmingLane = require(GetScriptDirectory().."/dev/state/state_farming_lane");
local StateFarmJungle = require(GetScriptDirectory().."/dev/state/state_farming_jungle");
local StateBuyItems    = require(GetScriptDirectory().."/dev/state/state_buy_items");
local StateControlRune = require(GetScriptDirectory().."/dev/state/state_control_rune");
local StateLearningAbilities = require(GetScriptDirectory().."/dev/state/state_learning_abilities");
local StateDeliverItems      = require(GetScriptDirectory().."/dev/state/state_deliver_items");
local StateReturnCourier     = require(GetScriptDirectory().."/dev/state/state_return_courier");
local StateHealFountain      = require(GetScriptDirectory().."/dev/state/state_heal_fountain");
local StateAttackHero        = require(GetScriptDirectory().."/dev/state/state_attack_hero");
local StateEscape            = require(GetScriptDirectory().."/dev/state/state_escape");
local StateSwapItems         = require(GetScriptDirectory().."/dev/state/state_swap_items");
local StateHarassHero        = require(GetScriptDirectory().."/dev/state/state_harass_hero");
local StateBackoff           = require(GetScriptDirectory().."/dev/state/state_backoff");
local StateAttackTower       = require(GetScriptDirectory().."/dev/state/state_attack_tower");
local StateUseAbility        = require(GetScriptDirectory().."/dev/state/state_use_ability");
--------------------------------------------------------
local STATE_USE_ABILITY           = "STATE_USE_ABILITY";

local STATE_ESCAPE                = "STATE_ESCAPE";
local STATE_JUKE                  = "STATE_JUKE";
local STATE_HIDING                = "STATE_HIDING";

local STATE_ATTACK_HERO           = "STATE_ATTACK_HERO";
local STATE_HARASS_HERO           = "STATE_HARASS_HERO";
local STATE_ATTACK_TOWER          = "STATE_ATTACK_TOWER";
local STATE_BACKOFF               = "STATE_BACKOFF";

local STATE_WAIT_FIGHT            = "STATE_WAIT_FIGHT";
local STATE_WAIT_INITIATE         = "STATE_WAIT_INITIATE";
local STATE_WAIT_CREEPS           = "STATE_WAIT_CREEPS";
-- creeping states
local STATE_OUTPUSH               = "STATE_OUTPUSH";
local STATE_STACK                 = "STATE_STACK";
local STATE_FARMING_LANE          = "STATE_FARMING_LANE";
-- local STATE_EXPING                = "STATE_EXPING";
-- local STATE_PUSHING_CREEPS        = "STATE_PUSHING_CREEPS";
-- local STATE_HUMBLE_LH             = "STATE_HUMBLE_LH";
-- local STATE_LH_D                  = "STATE_LH_D";
-- local STATE_LH_NOPUSH             = "STATE_LH_NOPUSH";
-- local STATE_LH_D_NOPUSH           = "STATE_LH_D_NOPUSH";
-- local STATE_LH_D_PUSH             = "STATE_LH_D_PUSH";
-- local STATE_LH_PSH                = "STATE_LH_PSH";
local STATE_FARM_JUNGLE           = "STATE_FARM_JUNGLE";
local STATE_CREEP_SKIP            = "STATE_CREEP_SKIP";

local STATE_ATTACK_FORT           = "STATE_ATTACK_FORT";

local STATE_BUY_ITEMS             = "STATE_BUY_ITEMS";
local STATE_DELIVER_ITEMS         = "STATE_DELIVER_ITEMS";
local STATE_RETURN_COURIER        = "STATE_RETURN_COURIER";
local STATE_LEARNING_ABILITIES    = "STATE_LEARNING_ABILITIES";

local STATE_BODYBLOCK_CREEPS      = "STATE_BODYBLOCK_CREEPS";
local STATE_BODYBLOCK_ENEMY       = "STATE_BODYBLOCK_ENEMY";
local STATE_LETTING_PASS          = "STATE_LETTING_PASS";

local STATE_CONTROL_POWERRUNE     = "STATE_CONTROL_POWERRUNE";
local STATE_CONTROL_RUNE          = "STATE_CONTROL_RUNE";

local STATE_HEAL_FOUNTAIN         = "STATE_HEAL_FOUNTAIN";
local STATE_HEAL_SHRINE           = "STATE_HEAL_SHRINE";
local STATE_ACCEPT_HELP           = "STATE_ACCEPT_HELP";
local STATE_HELPING               = "STATE_HELPING";

local STATE_SNIPE_COURIER         = "STATE_SNIPE_COURIER";
local STATE_LH_TOWER              = "STATE_LH_TOWER";
local STATE_D_TOWER               = "STATE_D_TOWER";

local STATE_HELP_FARM             = "STATE_HELP_FARM";
local STATE_SWAP_ITEMS            = "STATE_SWAP_ITEMS";
local STATE_BUYBACK               = "STATE_BUYBACK";

local STATE_TP_BOTTLE             = "STATE_TP_BOTTLE";
local STATE_TP_BOTTLE_REFILL      = "STATE_TP_BOTTLE_REFILL";
--------------------------------------------------------
function BotState:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.State = STATE_IDLE;
    o.StateMachine = {};
    o.StateMachine.STATE_WAIT_CREEPS  = StateWaitCreeps:new();
    o.StateMachine.STATE_FARMING_LANE = StateFarmingLane:new();
    o.StateMachine.STATE_FARM_JUNGLE  = StateFarmJungle:new();
    o.StateMachine.STATE_BUY_ITEMS    = StateBuyItems:new();
    o.StateMachine.STATE_CONTROL_RUNE = StateControlRune:new();
    o.StateMachine.STATE_LEARNING_ABILITIES = StateLearningAbilities:new();
    o.StateMachine.STATE_DELIVER_ITEMS      = StateDeliverItems:new();
    o.StateMachine.STATE_RETURN_COURIER     = StateReturnCourier:new();
    o.StateMachine.STATE_HEAL_FOUNTAIN      = StateHealFountain:new();
    o.StateMachine.STATE_ATTACK_HERO        = StateAttackHero:new();
    o.StateMachine.STATE_HARASS_HERO        = StateHarassHero:new();
    o.StateMachine.STATE_ESCAPE             = StateEscape:new();
    o.StateMachine.STATE_SWAP_ITEMS         = StateSwapItems:new();
    o.StateMachine.STATE_BACKOFF            = StateBackoff:new();
    o.StateMachine.STATE_ATTACK_TOWER       = StateAttackTower:new();
    o.StateMachine.STATE_USE_ABILITY        = StateUseAbility:new();
    return o
end
--------------------------------------------------------
BotState.ScanStates = {
  STATE_FARMING_LANE,
  STATE_FARM_JUNGLE,
  STATE_CONTROL_RUNE,
  STATE_HEAL_FOUNTAIN,
  STATE_ATTACK_HERO,
  STATE_HARASS_HERO,
  STATE_USE_ABILITY,
  STATE_ESCAPE,
  STATE_SWAP_ITEMS,
  STATE_DELIVER_ITEMS,
  STATE_BUY_ITEMS,
  STATE_LEARNING_ABILITIES,
  STATE_WAIT_CREEPS,
  STATE_BACKOFF,
  STATE_ATTACK_TOWER,
  STATE_RETURN_COURIER
}
--------------------------------------------------------
function BotState:SetState(State)
  if (self.State ~= STATE_IDLE and (self.State ~= State or self.Argument ~= self:StateArgument(State))) then
    print("state "..self.State.." ~= "..State);
    print("or args "..self.Argument.." ~= "..self:StateArgument(State));
    if (self.StateMachine[self.State].Reset) then
      print("reset");
      self.StateMachine[self.State]:Reset();
    end
  end
  self.State = State;
  self.Argument = self:StateArgument(State);
end

function BotState:UpdateState(BotInfo, Mode, Strategy)
  local highestPotential = VERY_LOW_INT;
  local highestState = self.State;
  -- print(GetBot():GetUnitName().." states");
  -- local t = RealTime();
  for i = 1, #self.ScanStates do
    local state = self.ScanStates[i];
    local potential = self.StateMachine[state]:EvaluatePotential(BotInfo, Mode, Strategy);
    -- print("        time spent in self.StateMachine["..state.."]:EvaluatePotential "..(RealTime() - t)*1000); t = RealTime();
    -- print("Evaluate "..state.." as "..potential);
    if (GetBot():GetUnitName() == "npc_dota_hero_nevermore") then
      DebugDrawText(25, 500 + i * 20, "Evaluate "..state.." as "..potential, 255, 255, 255);
    end
    if (potential > highestPotential) then
      highestPotential = potential;
      highestState = state;
    end
  end
  self:SetState(highestState);
  -- print("        time spent in self:SetState"..(RealTime() - t)*1000); t = RealTime();
  self:DebugStateChange();
  -- print("        time spent in self:DebugStateChange "..(RealTime() - t)*1000); t = RealTime();
end
--------------------------------------------------------
--------------------------------------------------------
BotState.PrevState = "none";
function BotState:DebugStateChange()
  if(self.PrevState ~= self.State) then
      -- print(GetBot():GetUnitName().." bot CURRENT STATE: "..self.State.." <- "..self.PrevState);
      self.PrevState = self.State;
  end
end
function BotState:ArgumentString()
  return self:StateArgument(self.State);
end
function BotState:StateArgument(State)
  if (self.StateMachine[State].ArgumentString) then
    return self.StateMachine[State]:ArgumentString();
  end
  return "";
end
--------------------------------------------------------
function BotState:Update(BotInfo, Mode, Strategy)
  -- local t = RealTime();
  self:UpdateState(BotInfo, Mode, Strategy);
  -- print("      time spent in self:UpdateState "..(RealTime() - t)*1000); t = RealTime();
  self.StateMachine[self.State]:Run(BotInfo, Mode, Strategy);
  -- print("      time spent in self.StateMachine[self.State]:Run "..(RealTime() - t)*1000); t = RealTime();
end
--------------------------------------------------------
return BotState;
