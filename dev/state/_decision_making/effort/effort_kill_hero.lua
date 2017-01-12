local EffortKillHero = {}
----------------------------------------------------
local UnitHelper      = require(GetScriptDirectory().."/dev/helper/unit_helper");
----------------------------------------------------
EffortKillHero.Multiplayer = 5;
----------------------------------------------------
function EffortKillHero:Hero(Hero)
  local bot = GetBot();
  local my_power = self:Power(bot);
  local his_power = self:Power(Hero);
  return Max(self.Multiplayer * (his_power - my_power), 0);
end
----------------------------------------------------
function EffortKillHero:Power(Hero)
  return UnitHelper:NetWorth(Hero) + Hero:GetHealth();
end
----------------------------------------------------
return EffortKillHero;
