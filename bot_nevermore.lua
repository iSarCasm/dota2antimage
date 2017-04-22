--------------------------------------------------------
require(GetScriptDirectory().."/dev/constants/generic");
require(GetScriptDirectory().."/dev/constants/roles");
require(GetScriptDirectory().."/dev/constants/runes");
require(GetScriptDirectory().."/dev/constants/shops");
require(GetScriptDirectory().."/dev/constants/fountains");
require(GetScriptDirectory().."/dev/constants/jungle");
require(GetScriptDirectory().."/dev/helper/global_helper");
local TeamStrategy    = require(GetScriptDirectory().."/dev/team_strategy");
local BotMode         = require(GetScriptDirectory().."/dev/bot_mode");
local BotState        = require(GetScriptDirectory().."/dev/bot_state");
local BotInfo         = require(GetScriptDirectory().."/dev/bot_info")
local AbilityItems    = require(GetScriptDirectory().."/dev/abilities/ability_items")
local Game         		= require(GetScriptDirectory().."/dev/game")
--------------------------------------------------------
--------------------------------------------------------
BotInfo:Init(LANE_MID, ROLE_CARRY);
BotInfo.projectileSpeed = 1200;
BotInfo.abilities = {
	"nevermore_shadowraze1",
	"nevermore_shadowraze2",
	"nevermore_shadowraze3",
	"nevermore_requiem"
}
BotInfo.itemBuild = {
		"item_courier", -- wTF?????
		"item_tango",
		"item_slippers",
		"item_circlet",
		"item_recipe_wraith_band",
		"item_bottle",
		"item_boots",
		"item_belt_of_strength",
		"item_gloves",

		"item_branches"
}
BotInfo.abilityBuild = {
	"nevermore_necromastery",
	"nevermore_shadowraze1",
	"nevermore_shadowraze1",
	"nevermore_necromastery",
	"nevermore_shadowraze1",
	"nevermore_necromastery",
	"nevermore_shadowraze1",
	"nevermore_necromastery",
	"nevermore_dark_lord",
	"special_bonus_attack_speed_20",
	"nevermore_dark_lord",
	"nevermore_requiem",
	"nevermore_requiem",
	"nevermore_dark_lord",
	"special_bonus_hp_175",
	"nevermore_dark_lord",
	"nevermore_requiem",
	"special_bonus_evasion_15",
	"special_bonus_unique_nevermore_2"
}
--------------------------------------------------------
--------------------------------------------------------
function DebugStatesFields()
  DebugDrawText(25, 100, "Strategy: "..TeamStrategy.Strategy, 255, 255, 255);
  DebugDrawText(25, 120, "Mode: "..BotMode.Mode, 255, 255, 255);
  DebugDrawText(25, 140, "State: "..BotState.State.." "..BotState:ArgumentString(), 255, 255, 255);
end

function DebugStats()
  DebugDrawText(25, 50, "LH/D = "..GetBot():GetLastHits().."/"..GetBot():GetDenies(), 255, 255, 255);
end
--------------------------------------------------------
function Think(  )
	Game:Update();

  TeamStrategy:Update();
  BotMode:Update(TeamStrategy.Strategy);
  BotState:Update(BotMode.Mode, TeamStrategy.Strategy);

	DebugDrawText(250, 350, "height is"..GetBot():GetGroundHeight(), 255, 255, 255);

	DebugStatesFields();
	DebugStats();

  BotInfo:GatherData();

  AbilityItems:Think(BotMode.Mode, TeamStrategy.Strategy);
end
