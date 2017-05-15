--------------------------------------------------------
require(GetScriptDirectory().."/dev/constants/generic");
require(GetScriptDirectory().."/dev/constants/roles");
require(GetScriptDirectory().."/dev/constants/runes");
require(GetScriptDirectory().."/dev/constants/shops");
require(GetScriptDirectory().."/dev/constants/fountains");
require(GetScriptDirectory().."/dev/constants/jungle");
require(GetScriptDirectory().."/dev/helper/global_helper");
--------------------------------------------------------
Game          = require(GetScriptDirectory().."/dev/game");
TeamStrategy  = require(GetScriptDirectory().."/dev/team_strategy");
Heroes        = require(GetScriptDirectory().."/dev/heroes/_heroes");
FlexBot       = require(GetScriptDirectory().."/dev/flex_bot");
--------------------------------------------------------
flexBot = FlexBot:new(Heroes:GetHero());
Game:InitializeUnits();
--------------------------------------------------------
function Think(  )
  -- print(GetBot():GetUnitName());
  -- local t = RealTime();
  Game:Update();
  -- print("  time spent in Game:Update "..(RealTime() - t)*1000); t = RealTime();
  TeamStrategy:Update();
  -- print("  time spent in TeamStrategy:Update "..(RealTime() - t)*1000); t = RealTime();
  flexBot:Think();
  -- print("  time spent in flexBot:Think "..(RealTime() - t)*1000); t = RealTime();
end
