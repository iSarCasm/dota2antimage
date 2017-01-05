--------------------------------------------------------
require(GetScriptDirectory().."/dev/constants/roles");
local TeamStrategy    = require(GetScriptDirectory().."/dev/team_strategy");
local BotMode         = require(GetScriptDirectory().."/dev/bot_mode");
local BotState        = require(GetScriptDirectory().."/dev/bot_state");
local BotInfo         = require(GetScriptDirectory().."/dev/bot_info")
--------------------------------------------------------
--------------------------------------------------------
BotInfo:Init(LANE_TOP, ROLE_CARRY);
BotInfo:Me().projectileSpeed = 0;
BotInfo:Me().itemBuild = {
		"item_tango",
		"item_tango",
		"item_flask",
		"item_quelling_blade",
    "item_branches",

		"item_ring_of_health",
		"item_ring_of_regen",

		"item_boots",
		"item_boots_of_elves",
		"item_gloves",

		"item_claymore",
		"item_broadsword",
		"item_void_stone",

    "item_quelling_blade",

		"item_ring_of_protection",
		"item_sobi_mask",
		"item_recipe_headdress",
		"item_lifesteal",

		"item_blade_of_alacrity",
		"item_boots_of_elves",
		"item_recipe_yasha",
		"item_ultimate_orb",
		"item_recipe_manta",

    "item_belt_of_strength",
    "item_javelin",
    "item_recipe_basher",

    "item_reaver",
    "item_vitality_booster",
    "item_recipe_heart",

    "item_eagle",
    "item_quarterstaff",
    "item_talisman_of_evasion",

    "item_boots",
    "item_recipe_travel_boots",

    "item_hyperstone",
    "item_hyperstone",

    "item_recipe_travel_boots"
}
--------------------------------------------------------
--------------------------------------------------------
function DebugStatesFields()
  DebugDrawText(25, 100, "Strategy: "..TeamStrategy.Strategy, 255, 255, 255);
  DebugDrawText(25, 120, "Mode: "..BotMode.Mode, 255, 255, 255);
  DebugDrawText(25, 140, "State: "..BotState.State, 255, 255, 255);
  DebugDrawText(25, 160, "Mini-State: "..BotState:MiniState(), 255, 255, 255);
  DebugDrawText(25, 180, "Action: "..BotInfo:ActionName(), 255, 255, 255)
end
--------------------------------------------------------
function Think(  )
  TeamStrategy:Update();
  BotMode:Update(TeamStrategy.Strategy);
  BotState:Act(BotMode.Mode, TeamStrategy.Strategy);
  BotInfo:Act();

  BotInfo:GatherData();
  DebugStatesFields();
end