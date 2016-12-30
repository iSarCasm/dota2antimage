local M = {}

local STATE_IDLE    = "STATE_IDLE";
local STATE_FARMING = "STATE_FARMING";
--------------------------------------------------------
function StateIdle(StateMachine)
  -- TODO
  StateMachine.State = STATE_FARMING;
end

function StateFarming(StateMachine)
  local npcBot = GetBot();

  if (DotaTime() < 0) then
    local tower = DotaBotUtility:GetFrontTowerAt(LANE);
    npcBot:Action_MoveToLocation(tower:GetLocation());
  else
    print("actual farming goes here ");
  end
end
--------------------------------------------------------
local StateMachine = {};
StateMachine["State"]       = STATE_IDLE;
StateMachine[STATE_IDLE]    = StateIdle;
StateMachine[STATE_FARMING] = StateFarming;
--------------------------------------------------------
--------------------------------------------------------
local PrevState = "none";
function DebugStateChange()
  if(PrevState ~= StateMachine.State) then
      print("Antimage bot STATE: "..StateMachine.State.." <- "..PrevState);
      PrevState = StateMachine.State;
  end
end
--------------------------------------------------------
function M:Run()
  StateMachine[StateMachine.State](StateMachine);
end
