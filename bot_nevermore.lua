--------------------------------------------------------
require(GetScriptDirectory().."/dev/constants/generic");
require(GetScriptDirectory().."/dev/constants/roles");
require(GetScriptDirectory().."/dev/constants/runes");
require(GetScriptDirectory().."/dev/constants/shops");
require(GetScriptDirectory().."/dev/constants/fountains");
require(GetScriptDirectory().."/dev/constants/jungle");
require(GetScriptDirectory().."/dev/helper/global_helper");
local Game            = require(GetScriptDirectory().."/dev/game");
local TeamStrategy    = require(GetScriptDirectory().."/dev/team_strategy");
local Heroes          = require(GetScriptDirectory().."/dev/heroes/_heroes");
local FlexBot         = require(GetScriptDirectory().."/dev/flex_bot");
--------------------------------------------------------
flexBot = FlexBot:new(Heroes:GetHero());
Game:InitializeUnits();
--------------------------------------------------------
function Think(  )
  Game:Update();
  TeamStrategy:Update();
  flexBot:Think();
  botInfo:GatherData();
end
--------------------------------------------------------
require(GetScriptDirectory().."/dev/constants/generic");
require(GetScriptDirectory().."/dev/constants/roles");
require(GetScriptDirectory().."/dev/constants/runes");
require(GetScriptDirectory().."/dev/constants/shops");
require(GetScriptDirectory().."/dev/constants/fountains");
require(GetScriptDirectory().."/dev/constants/jungle");
require(GetScriptDirectory().."/dev/helper/global_helper");
local Game            = require(GetScriptDirectory().."/dev/game");
local TeamStrategy    = require(GetScriptDirectory().."/dev/team_strategy");
local Heroes          = require(GetScriptDirectory().."/dev/heroes/_heroes");
local FlexBot         = require(GetScriptDirectory().."/dev/flex_bot");
--------------------------------------------------------
flexBot = FlexBot:new(Heroes:GetHero());
Game:InitializeUnits();
--------------------------------------------------------
function Think(  )
  Game:Update();
  TeamStrategy:Update();
  flexBot:Think();
end
