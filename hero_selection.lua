----------------------------------------------------------------------------------------------------
offset = 0;
function Think()
	if ( GetTeam() == TEAM_DIRE )
	then
		SelectHero( 7 + offset, "npc_dota_hero_antimage" );
	else
		SelectHero( 2 + offset, "npc_dota_hero_dragon_knight");
	end
end
----------------------------------------------------------------------------------------------------
