local BotInfo = require(GetScriptDirectory().."/dev/bot_info");
-------------------------------------------
local Hero = BotInfo:new();
-------------------------------------------
Hero = Hero:new();
Hero:Init(Hardlane(), ROLE_OFFLANE);
Hero.projectileSpeed = 0;
Hero.abilities = {
  "magnataur_shockwave",
  "magnataur_empower",
  "magnataur_skewer",
  "magnataur_reverse_polarity"
}
Hero.itemBuild = {
  "item_tango",
  "item_slippers",
  "item_slippers",
  "item_stout_shield",

  "item_boots",
  "item_energy_booster",

  "item_blink",

  "item_sobi_mask",
  "item_quarterstaff",
  "item_robe",
  "item_ogre_axe",

  "item_platemail",
  "item_mystic_staff",
  "item_recipe_shivas_guard",

  "item_ring_of_regen",
  "item_staff_of_wizardry",
  "item_recipe_force_staff",

  "item_ring_of_health",
  "item_void_stone",
  "item_ring_of_health",      
  "item_void_stone",
  "item_recipe_refresher"
}
Hero.abilityBuild = {
  "magnataur_skewer",       -- 1
  "magnataur_shockwave",    -- 2
  "magnataur_shockwave",    -- 3
  "magnataur_empower",      -- 4
  "magnataur_shockwave",    -- 5
  "magnataur_reverse_polarity", -- 6
  "magnataur_shockwave",      -- 7
  "magnataur_empower",     -- 8
  "magnataur_empower",
  "special_bonus_spell_amplify_15",
  "magnataur_empower",
  "magnataur_reverse_polarity",
  "magnataur_skewer",
  "magnataur_skewer",
  "special_bonus_gold_income_15",
  "magnataur_skewer",
  "magnataur_reverse_polarity",
  "special_bonus_unique_magnus_2",
  "special_bonus_unique_magnus"
}
-------------------------------------------
return Hero;