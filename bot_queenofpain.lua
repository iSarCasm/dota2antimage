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
BotInfo:Me().projectileSpeed = 1500;
BotInfo:Me().abilities = {
	"queenofpain_shadow_strike",
	"queenofpain_blink",
	"queenofpain_scream_of_pain",
	"queenofpain_sonic_wave"
}
BotInfo:Me().itemBuild = {
		"item_courier", -- wTF?????
		"item_tango",
		"item_mantle",
		"item_circlet",
		"item_recipe_null_talisman",
		"item_bottle",
		"item_boots",
		"item_belt_of_strength",
		"item_gloves"
}
BotInfo:Me().abilityBuild = {
	"queenofpain_shadow_strike",
	"queenofpain_blink",
	"queenofpain_shadow_strike",
	"queenofpain_scream_of_pain",
	"queenofpain_shadow_strike",
	"queenofpain_blink",
	"queenofpain_shadow_strike",
	"queenofpain_blink",
	"queenofpain_blink",
	"special_bonus_attack_damage_20",
	"queenofpain_scream_of_pain",
	"queenofpain_scream_of_pain",
	"queenofpain_scream_of_pain",
	"queenofpain_sonic_wave",
	"special_bonus_cooldown_reduction_12",
	"queenofpain_sonic_wave",
	"queenofpain_sonic_wave",
	"special_bonus_attack_range_100",
	"special_bonus_intelligence_35"
}
--------------------------------------------------------
--------------------------------------------------------
function DebugStatesFields()
  DebugDrawText(25, 100, "Strategy: "..TeamStrategy.Strategy, 255, 255, 255);
  DebugDrawText(25, 120, "Mode: "..BotMode.Mode, 255, 255, 255);
  DebugDrawText(25, 140, "State: "..BotState.State.." "..BotState:ArgumentString(), 255, 255, 255);
  DebugDrawText(25, 160, "Mini-State: "..BotState:MiniState(), 255, 255, 255);
  DebugDrawText(25, 180, "Action: "..BotInfo:ActionName(), 255, 255, 255)
end
--------------------------------------------------------
function Think(  )
	Game:Update();

  TeamStrategy:Update();
  BotMode:Update(TeamStrategy.Strategy);
  BotState:Update(BotMode.Mode, TeamStrategy.Strategy);
	AbilityItems:Think(BotMode.Mode, TeamStrategy.Strategy);

	DebugStatesFields();

	BotInfo:Act();
  BotInfo:GatherData();
end
