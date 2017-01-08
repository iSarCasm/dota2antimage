local EffortWait = {}
----------------------------------------------------
local Game    = require(GetScriptDirectory().."/dev/game");
----------------------------------------------------
function EffortWait:Rune(Rune)
  return Game:TimeToRune(Rune);
end
----------------------------------------------------
return EffortWait;
