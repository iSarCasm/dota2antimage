----------------------------------------------------------------------------------------------------
offset = 5;
function Think()
	if ( GetTeam() == TEAM_DIRE )
	then
		-- SelectHero( 0 + offset, "npc_dota_hero_nevermore" );
		-- SelectHero( 1 + offset, "npc_dota_hero_nevermore" );
		SelectHero( 1 + offset, "npc_dota_hero_antimage");					
		-- SelectHero( 2 + offset, "npc_dota_hero_nevermore" );
	else
		-- SelectHero( 2 + offset, "npc_dota_hero_nevermore" );
		-- SelectHero( 3 + offset, "npc_dota_hero_nevermore" );
		-- SelectHero( 4 + offset, "npc_dota_hero_nevermore" );
		-- SelectHero( 2 + offset, "npc_dota_hero_antimage");
		-- SelectHero( 2 + offset, "npc_dota_hero_dragon_knight");
	end
end
----------------------------------------------------------------------------------------------------
