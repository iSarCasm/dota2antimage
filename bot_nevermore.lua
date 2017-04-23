--------------------------------------------------------
require(GetScriptDirectory().."/dev/constants/generic");
require(GetScriptDirectory().."/dev/constants/roles");
require(GetScriptDirectory().."/dev/constants/runes");
require(GetScriptDirectory().."/dev/constants/shops");
require(GetScriptDirectory().."/dev/constants/fountains");
require(GetScriptDirectory().."/dev/constants/jungle");
require(GetScriptDirectory().."/dev/helper/global_helper");
local Game            = require(GetScriptDirectory().."/dev/game");
local BotInfo         = require(GetScriptDirectory().."/dev/bot_info");
local FlexBot         = require(GetScriptDirectory().."/dev/flex_bot");
--------------------------------------------------------
--------------------------------------------------------
botInfo = BotInfo:new();
botInfo:Init(LANE_MID, ROLE_CARRY);
botInfo.projectileSpeed = 1200;
botInfo.abilities = {
	"nevermore_shadowraze1",
	"nevermore_shadowraze2",
	"nevermore_shadowraze3",
	"nevermore_requiem"
}
botInfo.itemBuild = {
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
botInfo.abilityBuild = {
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
flexBot = FlexBot:new(botInfo);
Game:InitializeUnits();
--------------------------------------------------------
function Think(  )
	Game:Update();
  flexBot:Think();
  botInfo:GatherData();
end
