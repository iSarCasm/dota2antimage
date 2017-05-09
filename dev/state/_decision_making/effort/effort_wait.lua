local EffortWait = {}
----------------------------------------------------
local Game    = require(GetScriptDirectory().."/dev/game");
----------------------------------------------------
----------------------------------------------------
function EffortWait:Rune(Rune)
  return Game:TimeToRune(Rune);
end

function EffortWait:Jungle(Jungle)
  return Game:TimeToJungle(Jungle);
end

function EffortWait:Creeps(Lane)
  return Game:TimeToCreeps(Lane);
end

function EffortWait:Shrine( hShrine )
  if (IsShrineHealing(hShrine)) then
    return 0;
  else
    return GetShrineCooldown(hShrine);
  end
end
----------------------------------------------------
return EffortWait;
