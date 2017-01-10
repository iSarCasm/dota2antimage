local EffortWait = {}
----------------------------------------------------
local Game    = require(GetScriptDirectory().."/dev/game");
----------------------------------------------------
EffortWait.Multiplayer = 4;
----------------------------------------------------
function EffortWait:Rune(Rune)
  return Game:TimeToRune(Rune) * self.Multiplayer;
end

function EffortWait:Jungle(Jungle)
  return Game:TimeToJungle(Jungle) * self.Multiplayer;
end

function EffortWait:Creeps(Lane)
  return Game:TimeToCreeps(Lane) * self.Multiplayer;
end
----------------------------------------------------
return EffortWait;
