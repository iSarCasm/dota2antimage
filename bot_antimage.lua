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
local Game            = require(GetScriptDirectory().."/dev/game")
--------------------------------------------------------
--------------------------------------------------------
BotInfo:Init(LANE_TOP, ROLE_CARRY);
BotInfo:Me().projectileSpeed = 0;
BotInfo:Me().abilities = {
  "antimage_blink",
  "antimage_mana_break",
  "antimage_spell_shield",
  "antimage_mana_void"
}
BotInfo:Me().itemBuild = {
    "item_courier", -- wTF?????
    "item_branches",
    "item_branches",
    "item_branches",

    "item_tango",
    "item_tango",
    "item_flask",
    "item_quelling_blade",

    "item_stout_shield",
    "item_slippers",
    "item_slippers",

    "item_ring_of_health",
    -- "item_ring_of_regen",

    "item_boots",
    "item_belt_of_strength",
    "item_gloves",

    "item_claymore",
    "item_broadsword",
    "item_void_stone",

    "item_quelling_blade",
    --
    -- "item_ring_of_protection",
    -- "item_sobi_mask",
    -- "item_recipe_headdress",
    -- "item_lifesteal",

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
BotInfo:Me().abilityBuild = {
  "antimage_blink",
  "antimage_mana_break",
  "antimage_spell_shield",
  "antimage_mana_break",
  "antimage_mana_break",
  "antimage_mana_void",
  "antimage_mana_break",
  "antimage_blink",
  "antimage_blink",
  "special_bonus_attack_damage_20",
  "antimage_blink",
  "antimage_mana_void",
  "antimage_spell_shield",
  "antimage_spell_shield",
  "special_bonus_attack_speed_20",
  "antimage_spell_shield",
  "antimage_mana_void",
  "special_bonus_all_stats_10",
  "special_bonus_agility_25"
}
--------------------------------------------------------
--------------------------------------------------------
function DebugStatesFields()
  DebugDrawText(25, 100, "Strategy: "..TeamStrategy.Strategy, 255, 255, 255);
  DebugDrawText(25, 120, "Mode: "..BotMode.Mode, 255, 255, 255);
  DebugDrawText(25, 140, "State: "..BotState.State.." "..BotState:ArgumentString(), 255, 255, 255);
  if (BotState:MiniState()) then
    DebugDrawText(25, 160, "Mini-State: "..BotState:MiniState(), 255, 255, 255);
  end
  DebugDrawText(25, 180, "Action: "..BotInfo:ActionName(), 255, 255, 255)
end
--------------------------------------------------------
Game:InitializeUnits();
--------------------------------------------------------
function Think(  )
  Game:Update();

  TeamStrategy:Update();
  BotMode:Update(TeamStrategy.Strategy);
  BotState:Update(BotMode.Mode, TeamStrategy.Strategy);

  DebugStatesFields();

  BotInfo:Act();
  BotInfo:GatherData();

  AbilityItems:Think(BotMode.Mode, TeamStrategy.Strategy);
end
