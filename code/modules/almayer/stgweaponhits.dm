#define WEAPON_SPGM_MISSILE 1
#define WEAPON_RAILGUN 2

/proc/stgweaponhits(weaponused, location)

	if(WEAPON_SPGM_MISSILE)
		var/datum/cause_data/SpGM_cause_data = create_cause_data("Space-To-Ground Missile")
		cell_explosion(location, 700, 9, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, SpGM_cause_data)
	if(WEAPON_RAILGUN)
		var/datum/cause_data/SpTGRailgun = create_cause_data("Railgun Rod")
		cell_explosion(picked_atom, 600, 600, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, SpTGRailgun_cause_data)

#undef WEAPON_SPGM_MISSILE
#undef WEAPON_RAILGUN
