#define WEAPON_MISSILE 1
#define WEAPON_RAILGUN 2
#define WEAPON_ODC 3
#define WEAPON_AABOILER 4
#define HIT_CHANCE_CHEAT 100
#define HIT_CHANCE_STANDARD 70
/**
 * Proc called to hit the ship with weapons
 *
 * Hits the ship with the weapon of choice
 * Calling Shakeship acoording to the weapon used
 * All sounds that should happen when they hit are in here already.
 * Probably doesn't work in other shipmaps.
 * Arguments:
 * * weaponused - chooses the weapon through a switchcase. 1 for missiles, 2 for railguns, 3 for particle cannons.
 * * location - location in the ship where the explosion will be created.
 * * point_defense - If you want the Almayer to attempt taking down the incoming fire
 * * salvo - identifies it as a salvo or not.
 */
/proc/weaponhits(weaponused, location, point_defense = FALSE, salvo = FALSE)
	var/logtotalhits


	switch(weaponused)

		if(WEAPON_MISSILE)
			var/datum/cause_data/ashm_cause_data = create_cause_data("Anti-Ship missile")
			if(point_defense == FALSE)
				if(salvo == TRUE)
					var/shotspacing
					for(var/turf/picked_atom in location)
						addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), picked_atom, 700, 10, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, ashm_cause_data), shotspacing SECONDS)
						GLOB.ship_health_vars["ship_hull_health"] = GLOB.ship_health_vars["ship_hull_health"] - 10
						shotspacing += 1
						shakeship(10, 10, TRUE, FALSE)
						GLOB.ship_hits_tally["times_hit_missile"] += 1
						logtotalhits += 1
					weaponhits_effects(WEAPON_MISSILE)
				else
					cell_explosion(location, 700, 9, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, ashm_cause_data)
					GLOB.ship_health_vars["ship_hull_health"] = GLOB.ship_health_vars["ship_hull_health"] - 10
					shakeship(10, 10, TRUE, FALSE)
					weaponhits_effects(WEAPON_MISSILE)
					GLOB.ship_hits_tally["times_hit_missile"] += 1
					logtotalhits +=1
			if(point_defense == TRUE)
				var/hitchance = HIT_CHANCE_STANDARD
				if(salvo == TRUE)
					var/confirmedhit
					var/shotspacing
					for(var/turf/picked_atom in location)
						if(prob(hitchance))
							addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), picked_atom, 700, 9, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, ashm_cause_data), shotspacing SECONDS)
							GLOB.ship_health_vars["ship_hull_health"] = GLOB.ship_health_vars["ship_hull_health"] - 10
							shakeship(10, 10, TRUE, FALSE)
							confirmedhit += 1
							logtotalhits += 1
						else
							weaponhits_effects(WEAPON_MISSILE, TRUE, shotspacing)

						shotspacing += 1
					if(confirmedhit > 0)
						weaponhits_effects(WEAPON_MISSILE, FALSE)
					GLOB.ship_hits_tally["times_hit_missile"] += confirmedhit
					confirmedhit = 0
				else
					if(prob(hitchance))
						cell_explosion(location, 700, 9, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, ashm_cause_data)
						GLOB.ship_health_vars["ship_hull_health"] = GLOB.ship_health_vars["ship_hull_health"] - 10
						shakeship(10, 10, TRUE, FALSE)
						weaponhits_effects(WEAPON_MISSILE, FALSE)
						GLOB.ship_hits_tally["times_hit_missile"] += 1
						logtotalhits += 1
					else
						weaponhits_effects(WEAPON_MISSILE, TRUE)

		if(WEAPON_RAILGUN)
			var/datum/cause_data/antishiprailgun_cause_data = create_cause_data("Railgun shot")
			var/hitchance = HIT_CHANCE_CHEAT
			if(point_defense == TRUE)
				hitchance = HIT_CHANCE_STANDARD
			if(salvo == TRUE)
				var/confirmedhit
				for(var/turf/picked_atom in location)
					if(prob(hitchance))
						cell_explosion(picked_atom, 600, 600, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, antishiprailgun_cause_data)
						GLOB.ship_health_vars["ship_hull_health"] = GLOB.ship_health_vars["ship_hull_health"] - 2
						shakeship(5, 5, FALSE, FALSE)
						confirmedhit += 1
						logtotalhits += 1
				if(confirmedhit > 0)
					weaponhits_effects(WEAPON_RAILGUN)
				if(confirmedhit < 1)
					weaponhits_effects(WEAPON_RAILGUN, TRUE)
				GLOB.ship_hits_tally["times_hit_railgun"] += confirmedhit

			else if(salvo == FALSE)
				if(prob(hitchance))
					cell_explosion(location, 600, 600, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, antishiprailgun_cause_data)
					GLOB.ship_health_vars["ship_hull_health"] = GLOB.ship_health_vars["ship_hull_health"] - 2
					shakeship(5, 5, FALSE, FALSE)
					weaponhits_effects(WEAPON_RAILGUN)
					GLOB.ship_hits_tally["times_hit_railgun"] += 1
					logtotalhits += 1
				else
					weaponhits_effects(WEAPON_RAILGUN, TRUE)

		if(WEAPON_ODC)
			var/datum/cause_data/orbitaldefensecannon_cause_data = create_cause_data("Orbital Defense Shell")
			var/hitchance = HIT_CHANCE_CHEAT
			if(point_defense == TRUE)
				hitchance = HIT_CHANCE_STANDARD
			if(salvo == TRUE)
				var/confirmedhit
				for(var/turf/picked_atom in location)
					if(prob(hitchance))
						cell_explosion(picked_atom, 850, 6, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, orbitaldefensecannon_cause_data)
						GLOB.ship_health_vars["ship_hull_health"] = GLOB.ship_health_vars["ship_hull_health"] - 10
						shakeship(10, 10, TRUE, FALSE)
						confirmedhit += 1
						logtotalhits += 1
				if(confirmedhit > 0)
					weaponhits_effects(WEAPON_ODC)
				if(confirmedhit < 1)
					weaponhits_effects(WEAPON_ODC, TRUE)
				GLOB.ship_hits_tally["times_hit_odc"] += confirmedhit

			else if(salvo == FALSE)
				if(prob(hitchance))
					cell_explosion(location, 850, 6, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, orbitaldefensecannon_cause_data)
					GLOB.ship_health_vars["ship_hull_health"] = GLOB.ship_health_vars["ship_hull_health"] - 10
					shakeship(10, 10, TRUE, FALSE)
					weaponhits_effects(WEAPON_ODC)
					GLOB.ship_hits_tally["times_hit_odc"] += 1
					logtotalhits += 1
				else
					weaponhits_effects(WEAPON_ODC, TRUE)

		if(WEAPON_AABOILER)
			var/datum/cause_data/aaboiler_cause_data = create_cause_data("AA Boiler Shot")
			var/hitchance = HIT_CHANCE_CHEAT
			if(point_defense == TRUE)
				hitchance = HIT_CHANCE_STANDARD
			if(salvo == TRUE)
				var/confirmedhit
				for(var/turf/picked_atom in location)
					if(prob(hitchance))
						cell_explosion(picked_atom, 700, 9, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, aaboiler_cause_data)
						GLOB.ship_health_vars["ship_hull_health"] = GLOB.ship_health_vars["ship_hull_health"] - 20
						shakeship(10, 10, FALSE, FALSE)
						confirmedhit += 1
						logtotalhits += 1
				if(confirmedhit > 0)
					weaponhits_effects(WEAPON_AABOILER)
				if(confirmedhit < 1)
					weaponhits_effects(WEAPON_AABOILER, TRUE)
				GLOB.ship_hits_tally["times_hit_aaboiler"] += confirmedhit

			else if(salvo == FALSE)
				if(prob(hitchance))
					cell_explosion(location, 700, 9, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, aaboiler_cause_data)
					GLOB.ship_health_vars["ship_hull_health"] = GLOB.ship_health_vars["ship_hull_health"] - 20
					shakeship(10, 10, FALSE, FALSE)
					weaponhits_effects(WEAPON_AABOILER)
					GLOB.ship_hits_tally["times_hit_aaboiler"] += 1
					logtotalhits += 1
				else
					weaponhits_effects(WEAPON_AABOILER, TRUE)
	var/integerhitstally = GLOB.ship_hits_tally["times_hit_missile"] + GLOB.ship_hits_tally["times_hit_railgun"] + GLOB.ship_hits_tally["times_hit_odc"] + GLOB.ship_hits_tally["times_hit_aaboiler"]
	message_admins("weaponhits concluded! Type '[weaponused]' weapon was used, and hit [logtotalhits] times. The Almayer has now suffered a total of [integerhitstally] hits from all the weapons!")

/proc/weaponhits_effects(weaponused, weaponmiss = FALSE, shotspacing = 0)
	switch(weaponused)
		if(WEAPON_MISSILE)
			if(!weaponmiss)
				for(var/mob/living/carbon/current_mob in GLOB.living_mob_list)
					if(!is_mainship_level(current_mob.z))
						continue
					playsound_client(current_mob.client, 'sound/effects/metal_crash.ogg', 100 )
					playsound_client(current_mob.client, 'sound/effects/bigboom3.ogg', 100)
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), current_mob.client, 'sound/effects/pry2.ogg', 20), 1 SECONDS)
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), current_mob.client, 'sound/effects/double_klaxon.ogg'), 2 SECONDS)
			else
				for(var/mob/living/carbon/current_mob in GLOB.living_mob_list)
					if(!is_mainship_level(current_mob.z))
						continue
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), current_mob.client, 'sound/effects/laser_point_defence_success.ogg', 100), shotspacing SECONDS)
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), current_mob.client, SPAN_DANGER("You hear the Point Defense systems shooting down a missile!")), shotspacing SECONDS)

		if(WEAPON_RAILGUN)
			if(!weaponmiss)
				for(var/mob/living/carbon/current_mob in GLOB.living_mob_list)
					if(!is_mainship_level(current_mob.z))
						continue
					playsound_client(current_mob.client, 'sound/effects/bigboom3.ogg', 50)
					playsound_client(current_mob.client, 'sound/effects/railgunhit.ogg', 50)
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), current_mob.client, 'sound/effects/double_klaxon.ogg'), 2 SECONDS)
			else
				for(var/mob/living/carbon/current_mob in GLOB.living_mob_list)
					if(!is_mainship_level(current_mob.z))
						continue
					playsound_client (current_mob.client, 'sound/effects/railgun_miss.ogg', 60)
					to_chat(current_mob.client, SPAN_DANGER("You hear railgun shots barely missing the hull!"))

		if(WEAPON_ODC)
			if(!weaponmiss)
				for(var/mob/living/carbon/current_mob in GLOB.living_mob_list)
					if(!is_mainship_level(current_mob.z))
						continue
					playsound_client(current_mob.client, 'sound/effects/metal_crash.ogg', 100 )
					playsound_client(current_mob.client, 'sound/effects/bigboom3.ogg', 100)
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), current_mob.client, 'sound/effects/pry2.ogg', 20), 1 SECONDS)
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), current_mob.client, 'sound/effects/double_klaxon.ogg'), 2 SECONDS)
			else
				for(var/mob/living/carbon/current_mob in GLOB.living_mob_list)
					if(!is_mainship_level(current_mob.z))
						continue
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), current_mob.client, 'sound/effects/railgun_miss.ogg', 60), shotspacing SECONDS)
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), current_mob.client, SPAN_DANGER("You hear Shells barely missing the hull!")), shotspacing SECONDS)

		if(WEAPON_AABOILER)
			if(!weaponmiss)
				for(var/mob/living/carbon/current_mob in GLOB.living_mob_list)
					if(!is_mainship_level(current_mob.z))
						continue
					playsound_client(current_mob.client, 'sound/effects/metal_crash.ogg', 100 )
					playsound_client(current_mob.client, 'sound/effects/bigboom3.ogg', 100)
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), current_mob.client, 'sound/effects/pry2.ogg', 20), 1 SECONDS)
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), current_mob.client, 'sound/effects/double_klaxon.ogg'), 2 SECONDS)
			else
				for(var/mob/living/carbon/current_mob in GLOB.living_mob_list)
					if(!is_mainship_level(current_mob.z))
						continue
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), current_mob.client, 'sound/effects/railgun_miss.ogg', 60), shotspacing SECONDS)
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), current_mob.client, SPAN_DANGER("You hear a vile mass barely missing the hull!")), shotspacing SECONDS)

//REMOVE THIS WHEN WE USE THESE DEFS SOMEWHERE ELSE OR ELSE IT STRAIGHT UP WON'T WORK.
#undef WEAPON_MISSILE
#undef WEAPON_RAILGUN
#undef WEAPON_ODC
#undef WEAPON_AABOILER
#undef HIT_CHANCE_CHEAT
#undef HIT_CHANCE_STANDARD
