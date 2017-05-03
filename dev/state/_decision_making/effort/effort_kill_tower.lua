local EffortKillTower = {}
---------------------------------------------
local Creeping        = require(GetScriptDirectory().."/dev/state/state_farming_lane/creeping");
----------------------------------------------------
function EffortKillTower:Tower( hTower )
  return (hTower:GetHealth()) * 0.35 + self:Tanking(hTower);
end

function EffortKillTower:Tanking( hTower )
  local tower_creeps = {};
  local ally_creeps = Creeping.ally_creeps;
  for i = 1, #ally_creeps do
    local creep = ally_creeps[i];
    if (GetUnitToLocationDistance(creep, hTower:GetLocation()) < 500) then
      table.insert(tower_creeps, creep);
    end
  end
  if (#tower_creeps > 2) then
    return 0;
  elseif (#tower_creeps > 0) then
    return 800;
  end
  return 1500;
end
----------------------------------------------------
return EffortKillTower;
