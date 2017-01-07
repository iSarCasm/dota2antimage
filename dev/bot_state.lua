local M = {}
local BotInfo         = require(GetScriptDirectory().."/dev/bot_info")
local DotaBotUtility  = require(GetScriptDirectory().."/dev/utility");
--------------------------------------------------------
local StateWaitCreeps = require(GetScriptDirectory().."/dev/state/state_wait_creeps");
local StateFarmingLane = require(GetScriptDirectory().."/dev/state/state_farming_lane");
local StateBuyItems    = require(GetScriptDirectory().."/dev/state/state_buy_items");
local StateControlBountyRune = require(GetScriptDirectory().."/dev/state/state_control_bounty_rune");
local StateLearningAbilities = require(GetScriptDirectory().."/dev/state/state_learning_abilities");
--------------------------------------------------------
local STATE_ESCAPE                = "STATE_ESCAPE";
local STATE_JUKE                  = "STATE_JUKE";
local STATE_HIDING                = "STATE_HIDING";

local STATE_ATTACK                = "STATE_ATTACK";

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
local STATE_FARM_NEUTRALS         = "STATE_FARM_NEUTRALS";
local STATE_CREEP_SKIP            = "STATE_CREEP_SKIP";

local STATE_ATTACK_FORT           = "STATE_ATTACK_FORT";

local STATE_BUY_ITEMS             = "STATE_BUY_ITEMS";
local STATE_DELIVER_ITEMS         = "STATE_DELIVER_ITEMS";
local STATE_LEARNING_ABILITIES    = "STATE_LEARNING_ABILITIES";

local STATE_BODYBLOCK_CREEPS      = "STATE_BODYBLOCK_CREEPS";
local STATE_BODYBLOCK_ENEMY       = "STATE_BODYBLOCK_ENEMY";
local STATE_LETTING_PASS          = "STATE_LETTING_PASS";

local STATE_CONTROL_POWERRUNE     = "STATE_CONTROL_POWERRUNE";
local STATE_CONTROL_BOUNTYRUNE    = "STATE_CONTROL_BOUNTYRUNE";

local STATE_HEAL_FOUNTAIN         = "STATE_HEAL_FOUNTAIN";
local STATE_HEAL_SHRINE           = "STATE_HEAL_SHRINE";
local STATE_ACCEPT_HELP           = "STATE_ACCEPT_HELP";
local STATE_HELPING               = "STATE_HELPING";

local STATE_SNIPE_COURIER         = "STATE_SNIPE_COURIER";
local STATE_LH_TOWER              = "STATE_LH_TOWER";
local STATE_D_TOWER               = "STATE_D_TOWER";

local STATE_HELP_FARM             = "STATE_HELP_FARM";
local STATE_BUY_TP                = "STATE_BUY_TP";
local STATE_BUYBACK               = "STATE_BUYBACK";

local STATE_TP_BOTTLE             = "STATE_TP_BOTTLE";
local STATE_TP_BOTTLE_REFILL      = "STATE_TP_BOTTLE_REFILL";
--------------------------------------------------------
M.ScanStates = {
  STATE_LEARNING_ABILITIES,
  STATE_BUY_ITEMS,
  STATE_CONTROL_BOUNTYRUNE,
  STATE_WAIT_CREEPS,
  STATE_FARMING_LANE,
}
--------------------------------------------------------
function M:SetState(State)
  if (self.State ~= STATE_IDLE and self.State ~= State) then
    -- print(State.." ~= "..self.State);
    self.StateMachine[self.State]:Reset();
  end
  self.State = State;
end

function M:UpdateState(BotInfo, Mode, Strategy)
  local highestPotential = -999999;
  local highestState = self.State;
  for i = 1, #self.ScanStates do
    local state = self.ScanStates[i];
    local potential = self.StateMachine[state]:EvaluatePotential(BotInfo, Mode, Strategy);
    -- print("Evaluate "..state.." as "..potential);
    DebugDrawText(25, 500 + i * 20, "Evaluate "..state.." as "..potential, 255, 255, 255);
    if (potential > highestPotential) then
      highestPotential = potential;
      highestState = state;
    end
  end
  self:SetState(highestState);
  self:DebugStateChange();
end
--------------------------------------------------------
M.State = STATE_IDLE;
M.StateMachine = {};
M.StateMachine.STATE_WAIT_CREEPS  = StateWaitCreeps;
M.StateMachine.STATE_FARMING_LANE = StateFarmingLane;
M.StateMachine.STATE_BUY_ITEMS    = StateBuyItems;
M.StateMachine.STATE_CONTROL_BOUNTYRUNE = StateControlBountyRune;
M.StateMachine.STATE_LEARNING_ABILITIES = StateLearningAbilities;
--------------------------------------------------------
--------------------------------------------------------
M.PrevState = "none";
function M:DebugStateChange()
  if(self.PrevState ~= self.State) then
      print(GetBot():GetUnitName().." bot CURRENT STATE: "..self.State.." <- "..self.PrevState);
      self.PrevState = self.State;
  end
end
function M:ArgumentString()
  if (self.StateMachine[self.State].ArgumentString) then
    return self.StateMachine[self.State]:ArgumentString();
  end
  return "";
end
--------------------------------------------------------
function M:Act(Mode, Strategy)
  self:UpdateState(BotInfo:Me(), Mode, Strategy);
  self.StateMachine[self.State]:Run(BotInfo:Me(), Mode, Strategy);
end

function M:MiniState()
  return self.StateMachine[self.State].StateMachine.State;
end

return M;
