----------------------------------------------------------------------------------------------------
offset = 5;
function Think()
	if ( GetTeam() == TEAM_DIRE )
	then
		SelectHero( 2 + offset, "npc_dota_hero_antimage");					
		SelectHero( 3 + offset, "npc_dota_hero_nevermore" );
		SelectHero( 4 + offset, "npc_dota_hero_warlock" );
		SelectHero( 5 + offset, "npc_dota_hero_ogre_magi" );
		SelectHero( 6 + offset, "npc_dota_hero_magnataur" );
	else
		-- SelectHero( 2 + offset, "npc_dota_hero_nevermore" );
		-- SelectHero( 3 + offset, "npc_dota_hero_nevermore" );
		-- SelectHero( 4 + offset, "npc_dota_hero_nevermore" );
		-- SelectHero( 2 + offset, "npc_dota_hero_antimage");
		-- SelectHero( 2 + offset, "npc_dota_hero_dragon_knight");
	end
end

function GetBotNames()
	return { 	
		"SarCasm", "ANDROIDp", "Smile", "LightOfHeaven", 
		"Artstyle", "ChuaN", "PGG", "Vigoss", "DreadIsBack", 
		"YaphetS", "NS", "Maelk", "XBOCT", "PlaymatE" 
	};
end
----------------------------------------------------------------------------------------------------
