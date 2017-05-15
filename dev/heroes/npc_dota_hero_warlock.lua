local BotInfo = require(GetScriptDirectory().."/dev/bot_info");
-------------------------------------------
local Hero = BotInfo:new();
-------------------------------------------
Hero:Init(Safelane(), ROLE_FULLSUP);
Hero.projectileSpeed = 1000; -- ??
Hero.abilities = {
  "warlock_fatal_bonds",
  "warlock_shadow_word",
  "warlock_upheaval",
  "warlock_rain_of_chaos"
}
Hero.itemBuild = {
  "item_courier",
  "item_tango",
  "item_flask",
  "item_clarity",
  "item_clarity",

  "item_magic_stick",
  "item_boots",
  "item_branches",
  "item_branches",
  "item_circlet",

  "item_energy_booster",

  "item_ring_of_regen",
  "item_branches",
  "item_recipe_headdress",

  "item_chainmail",
  "item_branches",
  "item_recipe_buckler",

  "item_point_booster",
  "item_ogre_axe",
  "item_staff_of_wizardry",
  "item_blade_of_alacrity",

  "item_ring_of_regen",
  "item_staff_of_wizardry",
  "item_recipe_force_staff",

  "item_cloak",
  "item_shadow_amulet",

  "item_ring_of_health",
  "item_void_stone",
  "item_ring_of_health",      
  "item_void_stone",
  "item_recipe_refresher"
}
Hero.abilityBuild = {
  "warlock_shadow_word",
  "warlock_fatal_bonds",
  "warlock_shadow_word",
  "warlock_fatal_bonds",
  "warlock_shadow_word",
  "warlock_rain_of_chaos",
  "warlock_shadow_word",
  "warlock_fatal_bonds",
  "warlock_fatal_bonds",
  "special_bonus_all_stats_6",
  "warlock_upheaval",
  "warlock_rain_of_chaos",
  "warlock_upheaval",
  "warlock_upheaval",
  "special_bonus_unique_warlock_3",
  "warlock_upheaval",
  "warlock_rain_of_chaos",
  "special_bonus_unique_warlock_1",
  "special_bonus_agility_25"
}
-------------------------------------------
return Hero;