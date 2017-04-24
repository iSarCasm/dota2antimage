local BotInfo = require(GetScriptDirectory().."/dev/bot_info");
-------------------------------------------
local Hero = BotInfo:new();
-------------------------------------------
Hero:Init(LANE_TOP, ROLE_CARRY);
Hero.projectileSpeed = 0;
Hero.abilities = {
  "antimage_blink",
  "antimage_mana_break",
  "antimage_spell_shield",
  "antimage_mana_void"
}
Hero.itemBuild = {
    -- "item_courier", -- wTF?????

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
Hero.abilityBuild = {
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
-------------------------------------------
return Hero;