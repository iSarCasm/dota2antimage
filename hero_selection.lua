----------------------------------------------------------------------------------------------------
offset = 0;
function Think()
	if ( GetTeam() == TEAM_DIRE )
	then
		print( "selecting dire" )
		SelectHero( 7 + offset, "npc_dota_hero_antimage" );
	end
end
----------------------------------------------------------------------------------------------------
