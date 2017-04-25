--------------------------------------------------------
require(GetScriptDirectory().."/dev/constants/generic");
require(GetScriptDirectory().."/dev/constants/roles");
require(GetScriptDirectory().."/dev/constants/runes");
require(GetScriptDirectory().."/dev/constants/shops");
require(GetScriptDirectory().."/dev/constants/fountains");
require(GetScriptDirectory().."/dev/constants/jungle");
require(GetScriptDirectory().."/dev/helper/global_helper");
--------------------------------------------------------
InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper");
HeroHelper      = require(GetScriptDirectory().."/dev/helper/hero_helper");
MapHelper       = require(GetScriptDirectory().."/dev/helper/map_helper");
UnitHelper      = require(GetScriptDirectory().."/dev/helper/unit_helper");
VectorHelper    = require(GetScriptDirectory().."/dev/helper/vector_helper");
--------------------------------------------------------
Game            = require(GetScriptDirectory().."/dev/game");
TeamStrategy    = require(GetScriptDirectory().."/dev/team_strategy");
Heroes          = require(GetScriptDirectory().."/dev/heroes/_heroes");
FlexBot         = require(GetScriptDirectory().."/dev/flex_bot");
--------------------------------------------------------
flexBot = FlexBot:new(Heroes:GetHero());
Game:InitializeUnits();
--------------------------------------------------------
function Think(  )
  Game:Update();
  TeamStrategy:Update();
  flexBot:Think();
end
