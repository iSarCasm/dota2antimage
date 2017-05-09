local BotInfo = require(GetScriptDirectory().."/dev/bot_info");
-------------------------------------------
local Hero = BotInfo:new();
-------------------------------------------
Hero = Hero:new();
Hero:Init(LANE_MID, ROLE_CARRY);
Hero.projectileSpeed = 1200;
Hero.abilities = {
  "nevermore_shadowraze1",
  "nevermore_shadowraze2",
  "nevermore_shadowraze3",
  "nevermore_requiem"
}
Hero.itemBuild = {
  "item_faerie_fire",
  "item_slippers",
  "item_circlet",
  "item_recipe_wraith_band",
  "item_tango",

  "item_bottle",

  "item_boots",
  "item_belt_of_strength",
  "item_gloves",

  "item_shadow_amulet",
  "item_claymore",

  "item_ogre_axe",
  "item_boots_of_elves",
  "item_boots_of_elves",

  "item_blade_of_alacrity",
  "item_boots_of_elves",
  "item_recipe_yasha",
  "item_ogre_axe",
  "item_belt_of_strength",
  "item_recipe_sange",

  "item_ogre_axe",
  "item_mithril_hammer",
  "item_recipe_black_king_bar",

  "item_eagle",
  "item_quarterstaff",
  "item_talisman_of_evasion"
}
Hero.abilityBuild = {
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
-------------------------------------------
return Hero;