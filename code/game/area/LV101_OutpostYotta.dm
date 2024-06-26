//yay, groundmapping!
//ambience_exterior = AMBIENCE_SHIP
//Lets make areas!
//Outside Areas
/area/lv101_OutpostYotta
	name = "\improper Outpost Yotta Jungle"
	//base_lighting_alpha = 255
	icon_state = "lv-west"
	can_build_special = TRUE
	powernet_name = "ground"
	requires_power = TRUE
	unlimited_power = TRUE
	ambience_exterior = AMBIENCE_JUNGLE
	minimap_color = MINIMAP_AREA_COLONY
	ceiling = CEILING_NONE

/area/lv101_OutpostYotta/landingzone
	name = "\improper Outpost Yotta Landing Zone"
	icon_state = "green"
	is_landing_zone = TRUE



/area/lv101_OutpostYotta/facility
	name = "\improper Outpost Yotta"
	icon_state = "red"
	ceiling = CEILING_METAL
