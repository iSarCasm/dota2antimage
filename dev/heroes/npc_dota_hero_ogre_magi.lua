local BotInfo = require(GetScriptDirectory().."/dev/bot_info");
-------------------------------------------
local Hero = BotInfo:new();
-------------------------------------------
Hero:Init(Safelane(), ROLE_SUPPORT);
Hero.projectileSpeed = 1000; -- ??
Hero.abilities = {
  "ogre_magi_fireblast",
  "ogre_magi_ignite",
  "ogre_magi_bloodlust",
  "ogre_magi_unrefined_fireblast"
}
Hero.itemBuild = {
  "item_tango",
  "item_flask",
  "item_clarity",
  "item_orb_of_venom",

  "item_magic_stick",
  "item_boots",
  "item_branches",
  "item_branches",
  "item_circlet",

  "item_energy_booster",

  "item_sobi_mask",
  "item_gauntlets",
  "item_gauntlets",
  "item_recipe_urn_of_shadows",

  "item_gauntlets",
  "item_circlet",
  "item_recipe_bracer",
  "item_sobi_mask",
  "item_wind_lace",
  "item_recipe_ancient_janggo",

  "item_cloak",
  "item_shadow_amulet",

  "item_ring_of_regen",
  "item_staff_of_wizardry",
  "item_recipe_force_staff",

  "item_point_booster",
  "item_ogre_axe",
  "item_staff_of_wizardry",
  "item_blade_of_alacrity"
}
Hero.abilityBuild = {
  "ogre_magi_ignite",
  "ogre_magi_fireblast",
  "ogre_magi_bloodlust",
  "ogre_magi_bloodlust",
  "ogre_magi_bloodlust",
  "ogre_magi_multicast",
  "ogre_magi_bloodlust",
  "ogre_magi_fireblast",
  "ogre_magi_ignite",
  "special_bonus_gold_income_10",
  "ogre_magi_ignite",
  "ogre_magi_multicast",
  "ogre_magi_fireblast",
  "ogre_magi_ignite",
  "special_bonus_magic_resistance_8",
  "ogre_magi_fireblast",
  "ogre_magi_multicast",
  "special_bonus_hp_250",
  "special_bonus_unique_ogre_magi"
}
-------------------------------------------
return Hero;