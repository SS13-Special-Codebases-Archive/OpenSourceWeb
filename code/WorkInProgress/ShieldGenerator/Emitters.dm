//Shield Generator - Emitters
//The shield emitters



//
// Emitter Base Class
//

/obj/machinery/shielding/emitter
	icon = 'shieldgen.dmi'
	anchored = 1
	level = 1
	var/online = 0
	var/control = 0
	var/list/obj/effect/shield/PoweredShields = list( )


//When an emitter is created, run the AoE setup code after a delay
/obj/machinery/shielding/emitter/New()
	spawn(5)
		UpdateAoE()
	..()


/obj/machinery/shielding/emitter/proc/UpdateAoE()
	return


//Whether the emitter is powered - remember, this uses shield power, not electrical power!
/obj/machinery/shielding/emitter/powered()
	return ShieldNetwork && ShieldNetwork.HasPower()


//Basic process function
/obj/machinery/shielding/emitter/process()
	var/nonline = ShieldNetwork.HasPower() && control

	if (online != nonline)
		for(var/obj/effect/shield/Shield in PoweredShields)
			if(Shield.disabled)
				Shield.density = 0
				Shield.invisibility = 101
				Shield.explosion_resistance = 0
				continue
			if (nonline)
				Shield.density = !Shield.blockatmosonly
				Shield.icon_state = "shieldsparkles[Shield.blockatmosonly]"
				Shield.explosion_resistance = INFINITY
				Shield.invisibility = 0
			else
				Shield.density = 0
				Shield.invisibility = 101
				Shield.explosion_resistance = 0

	online = nonline
	if(online)
		UseMaintenanceCharge()

	icon_state = online ? "plate" : "plate-p" //TODO better graphics handling

//The base energy cost for maintaining each shield tile
/obj/machinery/shielding/emitter/proc/UseMaintenanceCharge()
	Draw(PoweredShields.len * 5)


//Called when a shield tile requires additional power
//e.g. after an explosion (I might put stats-tracking in here...)
/obj/machinery/shielding/emitter/proc/Draw(amount)


//Set up a shield tile on this turf if applicable
/obj/machinery/shielding/emitter/proc/UpdateTurf(var/turf/S)
	for (var/obj/effect/shield/shield in S)
		if(!shield.emitter || shield.emitterdist < get_dist(shield, src))
			shield.emitter = src
			shield.emitterdist = get_dist(shield, src)
		return

	for(var/dir in alldirs)
		var/turf/T = get_step(S,dir)
		if(T)
			if(T.type != /turf/space && T.type != /turf/simulated/floor/engine/vacuum/hull)
				AddShield(S)
				return

/obj/machinery/shielding/emitter/proc/AddShield(var/turf/S)
	for (var/obj/effect/shield/shield in S)
		if(!shield.emitter)
			shield.emitter = src
		return
	var/obj/effect/shield/Shield = new /obj/effect/shield(S)
	Shield.emitter = src
	PoweredShields += Shield
	return

//
// Plate-Type Emitter
//


/obj/machinery/shielding/emitter/plate
	icon_state = "plate"
	name = "Emitter Plate"
	desc = "An AoE shield emitter"
	level = 1
	var/range_dist = 10

//AoE Setup for the emitter plate - Shield the exterior hull
/obj/machinery/shielding/emitter/plate/UpdateAoE()
	for(var/obj/effect/shield/shield in PoweredShields)
		shield.density = 0
		shield.invisibility = 101
		shield.explosion_resistance = 0
		shield.emitter = null
		shield.emitterdist = INFINITY

	for(var/turf/space/S in range(src,range_dist))
		UpdateTurf(S)
	for(var/turf/simulated/floor/engine/vacuum/hull/S in range(src,range_dist))
		UpdateTurf(S)


/obj/machinery/shielding/emitter/plate/New()
	..()

	var/turf/T = src.loc			// hide if turf is not intact

	if(level==1) hide(T.intact)


/obj/machinery/shielding/emitter/plate/hide(var/i)
	if(level == 1 && istype(loc, /turf/simulated))
		invisibility = i ? 101 : 0
	update_icon()

/obj/machinery/shielding/emitter/plate/update_icon()
	return