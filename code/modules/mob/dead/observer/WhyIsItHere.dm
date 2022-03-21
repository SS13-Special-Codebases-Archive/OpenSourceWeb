/*
/mob/living/carbon/human/proc/CountWar()
	set hidden = 0
	set category = "Siege"
	set name = "Declarar guerra"
	set desc="Declara a guerra."
	var/war = 0
	if(!war)
		to_chat(world, "<br>")
		to_chat(world, "<span class='ravenheartfortress'>Acampamento do Sul</span>")
		to_chat(world, "<span class='excomm'>¤ Count [src.real_name] declars war to Firethorn. ¤</span>")
		world << sound('sound/AI/siege_declared.ogg')
		to_chat(world, "<br>")
		to_chat(world, "<span class='alert'>New Count Decree!</span>")
		to_chat(world, "<br>")
		wardeclared = TRUE
		world << sound('mantrap.ogg', repeat = 1, wait = 0, volume = 50, channel = 6)
		for(var/obj/effect/blockedsiege/S in world)
			S.density = 0
		war = 1
*/
/*
/mob/dead/observer/verb/jumptomob() //Moves the ghost instead of just changing the ghosts's eye -Nodrak
	set category = "Ghost"
	set name = "Jump to Mob"
	set desc = "Teleport to a mob"

	if(istype(usr, /mob/dead/observer)) //Make sure they're an observer!


		var/list/dest = list() //List of possible destinations (mobs)
		var/target = null	   //Chosen target.

		dest += getmobs() //Fill list, prompt user with list
		target = input("Please, select a player!", "Jump to Mob", null, null) as null|anything in dest

		if (!target)//Make sure we actually have a target
			return
		else
			var/mob/M = dest[target] //Destination mob
			var/mob/A = src			 //Source mob
			var/turf/T = get_turf(M) //Turf of the destination mob

			if(T && isturf(T))	//Make sure the turf exists, then move the source to that destination.
				A.loc = T
				following = null
			else
				A << "This mob is not located in the game world."
*/

/*
/mob/dead/observer/verb/analyze_air()
	set name = "Analyze Air"
	set category = "Ghost"

	if(!istype(usr, /mob/dead/observer)) return

	// Shamelessly copied from the Gas Analyzers
	if (!( istype(usr.loc, /turf) ))
		return

	var/datum/gas_mixture/environment = usr.loc.return_air()

	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles

	src << "\blue <B>Results:</B>"
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		src << "\blue Pressure: [round(pressure,0.1)] kPa"
	else
		src << "\red Pressure: [round(pressure,0.1)] kPa"
	if(total_moles)
		for(var/g in environment.gas)
			src << "\blue [gas_data.name[g]]: [round((environment.gas[g] / total_moles) * 100)]% ([round(environment.gas[g], 0.01)] moles)"
		src << "\blue Temperature: [round(environment.temperature-T0C,0.1)]&deg;C"
		src << "\blue Heat Capacity: [round(environment.heat_capacity(),0.1)]"
*/

/*
/mob/dead/observer/verb/become_mouse()
	set name = "Become mouse"
	set category = "Ghost"

	if(config.disable_player_mice)
		src << "<span class='warning'>Spawning as a mouse is currently disabled.</span>"
		return

	var/mob/dead/observer/M = usr
	if(config.antag_hud_restricted && M.has_enabled_antagHUD == 1)
		src << "<span class='warning'>antagHUD restrictions prevent you from spawning in as a mouse.</span>"
		return

	var/timedifference = world.time - client.time_died_as_mouse
	if(client.time_died_as_mouse && timedifference <= mouse_respawn_time * 600)
		var/timedifference_text
		timedifference_text = time2text(mouse_respawn_time * 600 - timedifference,"mm:ss")
		src << "<span class='warning'>You may only spawn again as a mouse more than [mouse_respawn_time] minutes after your death. You have [timedifference_text] left.</span>"
		return

	var/response = alert(src, "Are you -sure- you want to become a mouse?","Are you sure you want to squeek?","Squeek!","Nope!")
	if(response != "Squeek!") return  //Hit the wrong key...again.


	//find a viable mouse candidate
	var/mob/living/simple_animal/mouse/host
	var/obj/machinery/atmospherics/unary/vent_pump/vent_found
	var/list/found_vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/v in world)
		if(!v.welded && v.z == src.z)
			found_vents.Add(v)
	if(found_vents.len)
		vent_found = pick(found_vents)
		host = new /mob/living/simple_animal/mouse(vent_found.loc)
	else
		src << "<span class='warning'>Unable to find any unwelded vents to spawn mice at.</span>"

	if(host)
		if(config.uneducated_mice)
			host.universal_understand = 0
		host.ckey = src.ckey
		host << "<span class='info'>You are now a mouse. Try to avoid interaction with players, and do not give hints away that you are more than a simple rodent.</span>"

/mob/dead/observer/verb/view_manfiest()
	set name = "View Crew Manifest"
	set category = "Ghost"

	var/dat
	dat += "<h4>Crew Manifest</h4>"
	dat += data_core.get_manifest()

	src << browse(dat, "window=manifest;size=370x420;can_close=1")

//Used for drawing on walls with blood puddles as a spooky ghost.
*/
