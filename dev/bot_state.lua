local M = {}
local DotaBotUtility  = require(GetScriptDirectory().."/dev/utility");
local Creeping        = require(GetScriptDirectory().."/dev/state/creeping");
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
local STATE_EXPING                = "STATE_EXPING";
local STATE_PUSHING_CREEPS        = "STATE_PUSHING_CREEPS";
local STATE_HUMBLE_LH             = "STATE_HUMBLE_LH";
local STATE_LH_D                  = "STATE_LH_D";
local STATE_LH_NOPUSH             = "STATE_LH_NOPUSH";
local STATE_LH_D_NOPUSH           = "STATE_LH_D_NOPUSH";
local STATE_LH_D_PUSH             = "STATE_LH_D_PUSH";
local STATE_LH_PSH                = "STATE_LH_PSH";
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
local STATE_TP_BOTTLERESTORE      = "STATE_TP_BOTTLERESTORE";
--------------------------------------------------------
function M:UpdateState(BotInfo, Mode, Strategy)
  if (DotaTime() < 20) then
    self.State = STATE_WAIT_CREEPS;
  else
    self.State = STATE_LH_D;
  end
end
--------------------------------------------------------
--------------------------------------------------------
function M.StateWaitCreeps(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  local tower = DotaBotUtility:GetFrontTowerAt(BotInfo.LANE);
  bot:Action_MoveToLocation(tower:GetLocation());
end

function M.StateLhD(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  local comfort_point = Creeping:GetComfortPoint(BotInfo);
  Creeping:LastHitAndDeny();
  if (comfort_point ~= nil and bot:GetCurrentActionType() ~= BOT_ACTION_TYPE_ATTACK) then
    bot:Action_MoveToLocation(comfort_point);
    DebugDrawText(25, 200, "Current location: "..bot:GetLocation()[1].." "..bot:GetLocation()[2], 255, 255, 255);
    DebugDrawText(25, 220, "Target location: "..comfort_point[1].." "..comfort_point[2], 255, 255, 255);
    DebugDrawCircle(Vector(comfort_point[1], comfort_point[2], bot:GetGroundHeight()), 20, 0, 255, 0);
    DebugDrawLine(bot:GetLocation(), Vector(comfort_point[1], comfort_point[2], bot:GetGroundHeight()), 0, 255, 0);
  end
end
--------------------------------------------------------
M.State = STATE_IDLE;
M.StateMachine = {};
M.StateMachine.STATE_WAIT_CREEPS  = M.StateWaitCreeps;
M.StateMachine.STATE_LH_D         = M.StateLhD;
--------------------------------------------------------
--------------------------------------------------------
M.PrevState = "none";
function M:DebugStateChange()
  if(self.PrevState ~= self.State) then
      print(GetBot():GetUnitName().." bot CURRENT STATE: "..self.State.." <- "..self.PrevState);
      self.PrevState = self.State;
  end
end
--------------------------------------------------------
function M:Act(BotInfo, Mode, Strategy)
  self:UpdateState(BotInfo, Mode, Strategy);
  self.StateMachine[self.State](self, BotInfo, Mode, Strategy);
  self:DebugStateChange();
end

return M;
