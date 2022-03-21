/turf/simulated/floor/airless
	icon_state = "floor"
	name = "airless floor"
	oxygen = 0.01
	nitrogen = 0.01
	temperature = TCMB

	New()
		..()
		name = "floor"

/turf/simulated/floor/deepwater
	name = "deep water"
	icon = 'icons/obj/warfare.dmi'
	icon_state = "trench_trans"
	movement_delay = 4
	oxygen = 0

	layer = 5
	temperature = T0C

/turf/simulated/floor/deepwater/New()
	set_light(1,1,"#e5faa0")

/turf/simulated/floor/deepwater/Entered(mob/living/M as mob)
	..()

	if(!ismob(M))	return 0
	if(M.m_intent == "run")
		if(prob(10))
			M.weakened += 1
			M << "<span class='warning'>You begin flapping around.</span>"
			return

/turf/simulated/floor/deepwater/RightClick(mob/living/M as mob)
	if(M.stat)
		return

	if(prob(40))
		M.Move(locate(src.x, src.y, M.z+1))
		M << "<span class='warning'>You swim back up.</span>"
		playsound(M.loc, 'fst_water_jump_down_01.ogg', 40, 0)
	else
		M << "<span class='warning'>You fail to swim back up!</span>"
		playsound(M.loc, pick('water_max1.ogg','water_max2.ogg'), 40, 0)

/turf/simulated/floor/airless/ceiling
	icon_state = "rockvault"

/turf/simulated/floor/light
	name = "Light floor"
	luminosity = 5
	icon_state = "light_on"


	New()

		var/n = name //just in case commands rename it in the ..() call
		..()
		spawn(4)
			if(src)
				update_icon()
				name = n

/turf/simulated/floor/light/tech_neon
	icon_state = "techfloor_neon"

	luminosity = 0
	New()
		..()
		update_icon()

/turf/simulated/floor/light/tech_neon/tech_white
	icon_state = "techfloor_neonwhte"


/turf/simulated/floor/light/tech_neon/side
	icon_state = "techfloor_lightedcorner"


/turf/simulated/floor/light/tech_neon/side_grid
	icon_state = "techfloor_lightedcorner_grid"




/turf/simulated/floor/wood
	name = "floor"
	icon_state = "wood"


/turf/simulated/floor/vault
	icon_state = "rockvault"

	New(location,type)
		..()
		icon_state = "[type]vault"

/turf/simulated/wall/vault
	icon_state = "rockvault"

	New(location,type)
		..()
		icon_state = "[type]vault"

/turf/simulated/floor/goonplaque
	name = "Commemorative Plaque"
	icon_state = "plaque"
	desc = "\"This is a plaque in honour of our comrades on the G4407 Stations. Hopefully TG4407 model can live up to your fame and fortune.\" Scratched in beneath that is a crude image of a meteor and a spaceman. The spaceman is laughing. The meteor is exploding."

/turf/simulated/floor/engine
	name = "reinforced floor"
	icon_state = "engine"
	thermal_conductivity = 0.025
	heat_capacity = 325000

/turf/simulated/floor/engine/ex_act(severity)
	return ..(severity+1) //stronger than regular floors

/turf/simulated/floor/engine/attackby(obj/item/weapon/C as obj, mob/user as mob)
	if(!C)
		return
	if(!user)
		return
	if(istype(C, /obj/item/weapon/wrench))
		user << "\blue Removing rods..."
		playsound(src.loc, 'sound/items/Ratchet.ogg', 80, 1)
		if(do_after(user, 30))
			new /obj/item/stack/rods(src, 2)
			ChangeTurf(/turf/simulated/floor)
			var/turf/simulated/floor/F = src
			F.make_plating()
			return

/turf/simulated/floor/engine/cult
	name = "engraved floor"
	icon_state = "cult"


/turf/simulated/floor/engine/n20
	New()
		. = ..()
		assume_gas("sleeping_agent", 2000)

/turf/simulated/floor/engine/vacuum
	name = "vacuum floor"
	icon_state = "engine"
	oxygen = 0
	nitrogen = 0.001
	temperature = TCMB

/turf/simulated/floor/engine/vacuum/hull
	name = "Hull Plating"
	icon_state = "engine"
	oxygen = 0
	nitrogen = 0.001
	temperature = TCMB

/turf/simulated/floor/engine/vacuum/hull/supernew
	icon = 'icons/turf/hull.dmi'
	icon_state = "hull"
	style = "hull_new"


	New()
		..()
		spawn(4)
			update_icon()
			for(var/direction in cardinal)
				if(istype(get_step(src,direction),/turf/simulated/floor))
					var/turf/simulated/floor/FF = get_step(src,direction)
					FF.update_icon() //so siding get updated properly

/turf/simulated/floor/plating
	name = "plating"
	icon_state = "plating"

	intact = 0

/turf/simulated/floor/plating/under
	name = "plating"
	icon = 'icons/turf/un.dmi'
	icon_state = "4,6"

	style = "underplating"

/turf/simulated/floor/plating/under/New()

	icon_state = "grass[pick("1","2","3","4")]"
	..()
	spawn(4)
		if(src)
			update_icon()
			for(var/direction in cardinal)
				if(istype(get_step(src,direction),/turf/simulated/floor))
					var/turf/simulated/floor/FF = get_step(src,direction)
					FF.update_icon() //so siding get updated properly

/turf/simulated/floor/plating/under/Entered(mob/living/M as mob)
	..()
	for(var/obj/structure/catwalk/C in get_turf(src))
		return 0

	if(!ismob(M))	return 0
	if(M.m_intent == "run")
		if(prob(75))
			M.adjustBruteLoss(5)
			M.weakened += 3
			M << "<span class='warning'>You tripped over.</span>"
			return


/turf/simulated/floor/plating/airless
	icon_state = "plating"
	name = "airless plating"
	oxygen = 0.01
	nitrogen = 0.01
	temperature = TCMB

	New()
		..()
		name = "plating"

/turf/simulated/floor/bluegrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "bcircuit"

/turf/simulated/floor/greengrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "gcircuit"


/turf/simulated/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0
	layer = 2

/turf/simulated/shuttle/wall
	name = "wall"
	icon_state = "wall1"
	opacity = 1
	density = 1
	blocks_air = 1

/turf/simulated/shuttle/floor
	name = "floor"
	icon_state = "floor"

/turf/simulated/shuttle/plating
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"

/turf/simulated/shuttle/floor4 // Added this floor tile so that I have a seperate turf to check in the shuttle -- Polymorph
	name = "Brig floor"        // Also added it into the 2x3 brig area of the shuttle.
	icon_state = "floor4"

/turf/simulated/floor/beach
	name = "Beach"
	icon = 'icons/misc/beach.dmi'

/turf/simulated/floor/beach/sand
	name = "Sand"
	icon_state = "sand"

/turf/simulated/floor/beach/coastline
	name = "Coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/simulated/floor/beach/water
	name = "Water"
	icon_state = "water"

/turf/simulated/floor/beach/water/New()
	..()
	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="water5","layer"=MOB_LAYER+0.1)

/turf/simulated/floor/grass
	name = "Grass patch"
	icon_state = "grass1"


	New()

		icon_state = "grass[pick("1","2","3","4")]"
		..()
		spawn(4)
			if(src)
				update_icon()
				for(var/direction in cardinal)
					if(istype(get_step(src,direction),/turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,direction)
						FF.update_icon() //so siding get updated properly

/turf/simulated/floor/carpet
	name = "Carpet"
	icon = 'icons/turf/carpet.dmi'
	icon_state = "carpet"

	style = "carpet"

	New()

		if(!icon_state)
			icon_state = "carpet"
		..()
		spawn(4)
			if(src)
				update_icon()
				for(var/direction in list(1,2,4,8,5,6,9,10))
					if(istype(get_step(src,direction),/turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,direction)
						FF.update_icon() //so siding get updated properly

/turf/simulated/floor/carpet/beatifulcarpet1
	icon = 'icons/turf/carpetlw.dmi'
	icon_state = "carpet23side"
	New()
		turfs.Add(src)

/turf/simulated/floor/carpet/beatifulcarpet_side
	icon = 'icons/turf/carpetlw.dmi'
	icon_state = "carpbet23side"
	New()
		turfs.Add(src)

/turf/simulated/floor/carpet/beatifulcarpet2
	icon = 'icons/turf/carpetlw.dmi'
	icon_state = "carpbet23"
	New()
		turfs.Add(src)

/turf/simulated/floor/carpet/beatifulcarpet3
	icon = 'icons/turf/carpetlw.dmi'
	icon_state = "carpbet2side"
	New()
		turfs.Add(src)

/turf/simulated/floor/carpet/beatifulcarpet4
	icon = 'icons/turf/carpetlw.dmi'
	icon_state = "carpbet2"
	New()
		turfs.Add(src)

/turf/simulated/floor/carpet/beatifulcarpetazul_side
	icon = 'icons/turf/carpetlw.dmi'
	icon_state = "carpet2side"
	New()
		turfs.Add(src)

/turf/simulated/floor/carpet/beatifulcarpetazul
	icon = 'icons/turf/carpetlw.dmi'
	icon_state = "carpet2"
	New()
		turfs.Add(src)

/turf/simulated/floor/carpet/beatifulcarpet5
	icon = 'icons/turf/carpetlw.dmi'
	icon_state = "carpet0"
	New()
		turfs.Add(src)

/obj/structure/beatiful_carpet
	density = 0
	opacity = 0
	anchored = 1
	layer = 2
	icon = 'icons/turf/carpetlw.dmi'
	icon_state = "carpet_part"
	anchored = 1
	New()
		return 0

/obj/structure/structural_cables
	density = 0
	opacity = 0
	anchored = 1
	layer = 2
	name = "cable"
	icon = 'icons/obj/computer.dmi'
	icon_state = "cable0"
	anchored = 1

/obj/structure/structural_cables/cable1
	icon_state = "cable1"

/obj/structure/beatiful_carpet9
	icon = 'icons/turf/carpetlw.dmi'
	icon_state = "mcarpet"
	anchored = 1
	New()
		return 0

/turf/simulated/floor/carpet/beatifulcarpet7
	icon = 'icons/turf/carpetlw.dmi'
	icon_state = "carpet"
	New()
		return 0

/turf/simulated/floor/carpet/beatifulcarpet8
	icon = 'icons/turf/carpetlw.dmi'
	icon_state = "carpet2"
	New()
		return 0

/turf/simulated/floor/carpet/beatifulcarpet9
	icon = 'icons/turf/carpetlw.dmi'
	icon_state = "mcarpet"
	New()
		return 0

/turf/simulated/floor/carpet/beatifulcarpet10
	icon = 'icons/turf/carpetlw.dmi'
	icon_state = "mcarpet2"
	New()
		return 0

/turf/simulated/floor/carpet/beatifulcarpet11
	icon = 'icons/turf/carpetlw.dmi'
	icon_state = "hcarp"
	New()
		return 0


/turf/simulated/floor/meister1
	icon = 'icons/life/floors.dmi'
	icon_state = "k1"
	New()
		return 0

/turf/simulated/floor/shuttle1
	icon = 'icons/life/floors.dmi'
	icon_state = "shuttle1"

/turf/simulated/floor/shuttle2
	icon = 'icons/life/floors.dmi'
	icon_state = "shuttle2"

/turf/simulated/floor/shuttle3
	icon = 'icons/life/floors.dmi'
	icon_state = "shuttle3"

/turf/simulated/floor/shuttle4
	icon = 'icons/life/floors.dmi'
	icon_state = "shuttle4"

/turf/simulated/floor/shuttle5
	icon = 'icons/life/floors.dmi'
	icon_state = "shuttle5"

/turf/simulated/floor/shuttle6
	icon = 'icons/life/floors.dmi'
	icon_state = "shuttle6"

/turf/simulated/floor/meister2
	icon = 'icons/life/floors.dmi'
	icon_state = "k3"
	New()
		return 0

/turf/simulated/floor/meister3
	icon = 'icons/life/floors.dmi'
	icon_state = "mrav"
	New()
		return 0

/turf/simulated/floor/meister4
	icon = 'icons/life/floors.dmi'
	icon_state = "mrav2"
	New()
		return 0



/turf/simulated/floor/carpet/redy
	name = "Carpet"
	icon = 'icons/life/floors.dmi'
	icon_state = "carpbet2side"

	style = "carpet"

	New()

		if(!icon_state)
			icon_state = "carpet"
		..()
		spawn(4)
			if(src)
				update_icon()
				for(var/direction in list(1,2,4,8,5,6,9,10))
					if(istype(get_step(src,direction),/turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,direction)
						FF.update_icon() //so siding get updated properly

/turf/simulated/floor/carpet/blue
	style = "blue"
	icon_state = "blue15-15"

/turf/simulated/floor/carpet/black
	style = "black"
	icon_state = "black15-15"

/turf/simulated/floor/carpet/green
	style = "green"
	icon_state = "green15-15"

/turf/simulated/floor/carpet/silverblue
	style = "silverblue"
	icon_state = "silverblue15-15"

/turf/simulated/floor/carpet/gay
	style = "gay"
	icon_state = "gay15-15"

/turf/simulated/floor/carpet/purple
	style = "purple"
	icon_state = "purple15-15"

/turf/simulated/floor/os13/os13
	style = "os13"
	icon_state = "floorlight"
	temperature = T20C

/turf/simulated/floor/os13/os133
	style = "os13"
	icon_state = "floorlight2"

/turf/simulated/floor/os13/is13
	style = "os13"
	icon_state = "sci"

/turf/simulated/floor/os13/is14
	style = "os13"
	icon_state = "scilight"

/turf/simulated/floor/os13/fs13
	style = "os13"
	icon_state = "cargo"

/turf/simulated/floor/os13/fs14
	style = "os13"
	icon_state = "cargowhite"

/turf/simulated/floor/os13/fs15
	style = "os13"
	icon_state = "whitee"

/turf/simulated/floor/os13/fs16
	style = "os13"
	icon = 'icons/life/floors.dmi'
	icon_state = "n00"

/turf/simulated/floor/os13/fs17
	style = "os13"
	icon = 'icons/life/floors.dmi'
	icon_state = "n01"

/turf/simulated/floor/os13/fs18
	style = "os13"
	icon = 'icons/life/floors.dmi'
	icon_state = "brothel"

/turf/simulated/floor/os13/carpet
	style = "os13"
	icon = 'icons/life/floors.dmi'
	icon_state = "carpbet2"
/turf/simulated/floor/os13/carpet2
	style = "os13"
	icon = 'icons/life/floors.dmi'
	icon_state = "carpbet2side"

/turf/simulated/floor/os13/ladderl
	style = "green"
	icon_state = "ladderleft"

/turf/simulated/floor/os13/sladder
	style = "green"
	icon = 'icons/life/floors.dmi'
	icon_state = "s_ladder"

/turf/simulated/floor/os13/ladderr
	style = "green"
	icon_state = "ladderright"

/turf/simulated/floor/os13/ladder1
	style = "green"
	icon = 'icons/life/floors.dmi'
	icon_state = "ladder"

/turf/simulated/floor/os13/ladder2
	style = "green"
	icon = 'icons/life/floors.dmi'
	icon_state = "ladder2"

/turf/simulated/floor/os13/ladder3
	style = "green"
	icon = 'icons/life/floors.dmi'
	icon_state = "ladder3"

/turf/simulated/floor/os13/ladder4
	style = "green"
	icon = 'icons/life/floors.dmi'
	icon_state = "ladder4"

//LIFEWEB

/turf/simulated/floor/lifeweb
	style = "lifeweb"
	icon = 'icons/life/floors.dmi'

/turf/simulated/floor/lifewebe
	style = "lifewebold"
	icon = 'icons/life/floorsold.dmi'

/turf/simulated/floor/lifewebe/engine
	icon_state = "engine"

/turf/simulated/floor/lifewebe/newplate
	icon_state = "newplate"

/turf/simulated/floor/lifewebe/_21
	icon_state = "21"

/turf/simulated/floor/lifewebe/F3
	icon_state = "F3"

/turf/simulated/floor/lifeweb/attackby(obj/item/C as obj, mob/user as mob)
	..()
	if(istype(C, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = C
		if(G.assailant.zone_sel.selecting == "head" && G.affecting.lying)
			if(ishuman(G.affecting))
				G.affecting.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been smashed on the floor by [G.assailant.name] ([G.assailant.ckey])</font>")
				G.assailant.attack_log += text("\[[time_stamp()]\] <font color='red'>Smashed [G.affecting.name] ([G.affecting.ckey]) on the floor.</font>")

				//log_admin("ATTACK: [G.assailant] ([G.assailant.ckey]) smashed [G.affecting] ([G.affecting.ckey]) on a table.", 2)
				message_admins("ATTACK: [G.assailant] ([G.assailant.ckey])(<A HREF='?_src_=holder;adminplayerobservejump=\ref[G]'>JMP</A>) smashed [G.affecting] ([G.affecting.ckey]) on the floor.", 2)
				log_attack("[G.assailant] ([G.assailant.ckey]) smashed [G.affecting] ([G.affecting.ckey]) on a table.")

				var/mob/living/carbon/human/H = G.affecting
				var/datum/organ/external/affecting = H.get_organ("head")
				if(prob(25))
					affecting.take_damage(rand(25,35), 0)
					H.Weaken(2)
					if(prob(20)) // One chance in 20 to DENT THE TABLE
						affecting.take_damage(rand(8,15), 0) //Extra damage
						H.apply_effect(5, PARALYZE)
						visible_message("<span class='combatglow'><b>[H]</b>< has been knocked unconscious!</span>")
						H.ear_damage += rand(0, 3)
						H.ear_deaf = max(H.ear_deaf,6)
						H.CU()
						G.assailant.visible_message("\red \The [G.assailant] smashes \the [H]'s head on \the [src] with enough force to further deform \the [src]!\nYou wish you could unhear that sound.",\
						"\red You smash \the [H]'s head on \the [src] with enough force to leave another dent!\n[prob(50)?"That was a satisfying noise." : "That sound will haunt your nightmares"]",\
						"\red You hear the nauseating crunch of bone and gristle on solid metal and the squeal of said metal deforming.")
					else if(prob(50))
						G.assailant.visible_message("\red [G.assailant] smashes \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] bone and cartilage making a loud crunch!",\
						"\red You smash \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] bone and cartilage making a loud crunch!",\
						"\red You hear the nauseating crunch of bone and gristle on solid metal, the noise echoing through the room.")
					else
						G.assailant.visible_message("\red [G.assailant] smashes \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] nose smashed and face bloodied!",\
						"\red You smash \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] nose smashed and face bloodied!",\
						"\red You hear the nauseating crunch of bone and gristle on solid metal and the gurgling gasp of someone who is trying to breathe through their own blood.")
				else
					affecting.take_damage(rand(5,10), 0)
					G.assailant.visible_message("\red [G.assailant] smashes \the [H]'s head on \the [src]!",\
					"\red You smash \the [H]'s head on \the [src]!",\
					"\red You hear the nauseating crunch of bone and gristle on solid metal.")
				add_blood(G.affecting, 1) //Forced
				H.UpdateDamageIcon()
				H.updatehealth()
				var/mob/living/carbon/human/AS = G.assailant
				AS.adjustStaminaLoss(rand(6,15))
				playsound(H.loc, pick('sound/effects/gore/smash1.ogg','sound/effects/gore/smash2.ogg','sound/effects/gore/smash3.ogg'), 50, 1, -3)
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				qdel(G)

/turf/simulated/floor/lifeweb/wood
	burnAble = 1
	flammable = 1
	icon_state = "F74"


/turf/simulated/floor/lifeweb/wood/wooddark
	icon_state = "23323"

/turf/simulated/floor/lifeweb/wood/wooddaarkk
	icon_state = "34242"

/turf/simulated/floor/lifeweb/wood/wooddaarkkk
	icon_state = "2115"

/turf/simulated/floor/lifeweb/wood/woodt
	icon_state = "troom3"

/turf/simulated/floor/lifeweb/wood/woodtF74
	icon_state = "F74"

/turf/simulated/floor/lifeweb/wood/woodtF75
	icon_state = "FF"

/turf/simulated/floor/lifeweb/wood/woodtt
	icon_state = "troom1"

/turf/simulated/floor/lifeweb/wood/woodbf2
	icon_state = "bf2"

/turf/simulated/floor/lifeweb/wood/woodbf22
	icon_state = "bf22"

/turf/simulated/floor/lifeweb/wood/woodbf25
	icon_state = "bf25"

/turf/simulated/floor/lifeweb/wood/woodttt
	icon_state = "troom2"

/turf/simulated/floor/lifeweb/wood/troom3
	icon_state = "troom3"

/turf/simulated/floor/lifeweb/wood/nf24
	icon_state = "nf24"

/turf/simulated/floor/lifeweb/wood/nf23
	icon_state = "nf23"

/turf/simulated/floor/lifeweb/wood/nf22
	icon_state = "nf22"

/turf/simulated/floor/lifeweb/wood/snf22
	icon_state = "snf22"

/turf/simulated/floor/lifeweb/wood/snf23
	icon_state = "snf23"

/turf/simulated/floor/lifeweb/wood/snf2
	icon_state = "snf2"

/turf/simulated/floor/lifeweb/wood/snf23
	icon_state = "snf24"

/turf/simulated/floor/lifeweb/wood/nf2
	icon_state = "nf2"


/turf/simulated/floor/lifeweb/plaza
	icon_state = "plazaf"

/turf/simulated/floor/lifeweb/plazabox
	icon_state = "plazabox"

/turf/simulated/floor/lifeweb/plazar
	icon_state = "plazar"

/turf/simulated/floor/lifeweb/vinte1
	icon_state = "21"

/turf/simulated/floor/lifeweb/vinte2
	icon_state = "w"

/turf/simulated/floor/lifeweb/vinte3
	icon_state = "wb"

/turf/simulated/floor/lifeweb/vinte4
	icon_state = "wb2"

/turf/simulated/floor/lifeweb/vinte5
	icon_state = "23"

/turf/simulated/floor/lifeweb/vinte6
	icon_state = "23s"

/turf/simulated/floor/lifeweb/vinte7
	icon_state = "24"

/turf/simulated/floor/lifeweb/vinte7
	icon_state = "23b"

/turf/simulated/floor/lifeweb/spookyplaza
	icon_state = "spookyplaza"

/turf/simulated/floor/lifeweb/plazar2
	icon_state = "plazar2"

/turf/simulated/floor/lifeweb/nfloorz2
	icon_state = "nfloorz2"

/turf/simulated/floor/lifeweb/nfloorz3
	icon_state = "nfloorz3"

/turf/simulated/floor/lifeweb/nfloorz4
	icon_state = "nfloorz4"


/turf/simulated/floor/lifeweb/surgery
	icon_state = "surgery"

/turf/simulated/floor/lifeweb/surgery2
	icon_state = "surgery2"

/turf/simulated/floor/lifeweb/soulbreaker
	icon = 'soulwall2.dmi'
	icon_state = ""


/turf/simulated/floor/lifeweb/train
	icon = 'train.dmi'
	icon_state = "floor"

/turf/simulated/floor/lifeweb/soulbreaker/two
	icon = 'soulwall2.dmi'
	icon_state = "darkfloor"

/turf/simulated/floor/lifeweb/soulbreaker/three
	icon = 'soulwall2.dmi'
	icon_state = "SoulFloor"


/turf/simulated/floor/lifeweb/soulbreaker/four
	icon = 'soulwall2.dmi'
	icon_state = "SoulFloorS"


/turf/simulated/floor/lifeweb/soulbreaker/cluster
	icon = 'soulwall2.dmi'
	icon_state = "cluster"

/turf/simulated/floor/lifeweb/soulbreaker/cluster/New()
	..()
	src.dir = rand(0,8)

/turf/simulated/floor/lifeweb/merch
	icon_state = "bet"

/turf/simulated/floor/lifeweb/newbar
	icon_state = "newbar"

/turf/simulated/floor/lifeweb/newbar2
	icon_state = "newbar2"

/turf/simulated/floor/lifeweb/grilledfloor
	icon_state = "grilledfloor"

/turf/simulated/floor/lifeweb/f55
	icon_state = "f55"

/turf/simulated/floor/lifeweb/f5
	icon_state = "f5"

/turf/simulated/floor/lifeweb/newbar5
	icon_state = "newbar5"

/turf/simulated/floor/lifeweb/cerb
	icon_state = "nfloorz"

/turf/simulated/floor/lifeweb/ramptop
	icon_state = "ramptop"
	layer = 2.41

/turf/simulated/floor/lifeweb/rampbottom
	icon_state = "rampbottom"

/turf/simulated/floor/lifeweb/cerb2
	icon_state = "n2floors"

/turf/simulated/floor/lifeweb/damaged
	icon_state = "floor"

/turf/simulated/floor/lifeweb/stonedamaged
	icon_state = "stonedamaged"

/turf/simulated/floor/lifeweb/cerb3
	icon_state = "n"

/turf/simulated/floor/lifeweb/bbb
	icon_state = "bbb"

/turf/simulated/floor/lifeweb/lev
	icon_state = "lev"

/turf/simulated/floor/lifeweb/stone
	style = "stone"
	icon = 'icons/life/stonefloor.dmi'
	icon_state = "4,0"
	var/damage = 0
	var/damage_cap = 50
	var/turf/floorbelow

/turf/simulated/floor/lifeweb/stone/proc/update_damage()
	var/cap = damage_cap

	if(damage >= cap)
		getbelow()

	return

/turf/simulated/floor/lifeweb/stone/damage_overlay()
	var/image/img = image(icon = 'icons/turf/bholes.dmi', icon_state = pick("bhole1","bhole2","bhole3","bhole4"))
	img.pixel_x = rand(1,32)
	img.pixel_y = rand(1,32)
	src.overlays += img

/turf/simulated/floor/lifeweb/stone/proc/take_damage(dam)
	if(dam)
		damage = max(0, damage + dam)
		update_damage()
		damage_overlay()
	return

/turf/simulated/floor/lifeweb/stone/proc/getbelow()
	var/turf/controllerlocation = locate(1, 1, z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		// check if there is something to draw below
		if(!controller.down)
			src.ChangeTurf(/turf/space)
			return 0
		else
			floorbelow = locate(src.x, src.y, controller.down_target)
			if(floorbelow.density)
				src.ChangeTurf(/turf/simulated/floor/plating/dirt)
				return 0
			else
				src.ChangeTurf(/turf/simulated/floor/open)
				return 1
	return 1
/turf/simulated/floor/lifeweb/stone/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/rag))
		return
	if(istype(src, /turf/simulated/floor/lifeweb/stone/ladder))
		return
	if(user.a_intent == "hurt")
		visible_message("<span class='danger'>[src] has been hit by [user] with [W].</span>")
		var/totaldamage = W.force/3
		if(!W.sharp && !W.edge)
			totaldamage = W.force/8
			W.damageItem("HARD")
		else
			totaldamage = W.force/12
			W.damageItem("HARD")
		if(istype(W, /obj/item/weapon/sledgehammer))
			totaldamage = W.force/2
		take_damage(totaldamage)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.adjustStaminaLoss(rand(3,5))
			take_damage(H.my_stats.st)
		playsound(src, pick('wallhit.ogg','wallhit2.ogg','wallhit3.ogg'), 80, 1)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)


		return
	..()
	return

/turf/simulated/floor/lifeweb/stone/ladder/getbelow()
	var/turf/controllerlocation = locate(1, 1, z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		// check if there is something to draw below
		if(!controller.down)
			src.ChangeTurf(/turf/space)
			return 0
		else
			floorbelow = locate(src.x, src.y, controller.down_target)
			return 1
	return 1

/turf/simulated/wall/Destroy()
	dismantle_wall(null,null,1)
	..()

/turf/Destroy()
	..()
	return QDEL_HINT_IWILLGC

/turf/simulated/floor/lifeweb/stone/ladder/attack_hand(mob/living/carbon/human/user as mob)
	..()
	if(opened)
		user.forceMove(below)
		playsound(user.loc, 'sound/effects/climb.ogg', 40, 1)
		return
/turf/simulated/floor/lifeweb/stone/ladder
	name = "sewer"
	var/opened = FALSE
	var/open_state = "sewerhatch0"
	var/default_state = "sewerhatch1"
	icon = 'miscobjs.dmi'
	icon_state = "sewerhatch1"
	var/turf/below
	New()
		..()
		below = locate(src.x, src.y, src.z - 1)
		getbelow()
		return


/turf/simulated/floor/lifeweb/stone/_1
	icon_state = "4,0"

/turf/simulated/floor/lifeweb/stone/_2
	icon_state = "5,0"

/turf/simulated/floor/lifeweb/stone/_3
	icon_state = "25"

/turf/simulated/floor/lifeweb/stone/_4
	icon_state = "1,2"

/turf/simulated/floor/lifeweb/stone/_5
	icon_state = "255"

/turf/simulated/floor/lifeweb/stone/_6
	icon_state = "52"

/turf/simulated/floor/lifeweb/stone/_7
	icon_state = "s"

/turf/simulated/floor/lifeweb/stone/handmade
	icon_state = "stonecrafted1"
	var/chiseled = FALSE

/turf/simulated/floor/lifeweb/stone/handmade/New()
	..()
	icon_state = "stonecrafted[rand(1,4)]"

/turf/simulated/floor/lifeweb/stone/handmade/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/chisel) && !chiseled)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		playsound(src, 'obj_stone_generic_switch_enter_01.ogg', 80, 0,0)
		chiseled = TRUE
		user.visible_message("<span class='passive'>\The [user] chisels \the [src]</span>")
		icon_state = "newstone[rand(1,4)]"
	..()




/turf/simulated/floor/bridge
	style = "Bridge"
	icon = 'icons/life/bridge.dmi'

/turf/simulated/floor/bridge/_1
	icon_state = "a"

/turf/simulated/floor/bridge/_2
	icon_state = "b"

/turf/simulated/floor/bridge/_3
	icon_state = "c"

/turf/simulated/floor/bridge/_4
	icon_state = "d"


//lifeweb

/turf/simulated/floor/plating/ironsand/New()
	..()
	name = "Iron Sand"
	icon_state = "ironsand[rand(1,15)]"

/turf/simulated/floor/var/muddy

/turf/simulated/floor/plating/dirt_path
	name = "dirt"
	icon = 'icons/turf/dirt.dmi'
	icon_state = "1"
	mudpit = 1
	movement_delay = 1

/turf/simulated/floor/plating/dirt_path/New()
	..()
	icon_state = "[rand(1,16)]"

/turf/simulated/floor/plating/dirt2
	name = "dirt"
	icon = 'icons/life/dirt.dmi'
	icon_state = "dirtspawn"
	mudpit = 1
	movement_delay = 1
	glidesize = 5
	var/diggability = 4

/turf/simulated/floor/plating/dirt2/update_icon()
	..()
	switch(diggability)
		if(4)
			icon_state = "asteroid_dug0"
		if(3)
			icon_state = "asteroid_dug1"
		if(2)
			icon_state = "asteroid_dug2"
		if(1)
			icon_state = "asteroid_dug3"

/turf/simulated/floor/attackby(obj/item/C, mob/user) // I CAN LEAVE SOME DIRT HERE WITHOUT ADDING IT
	..()
	if(istype(src, /turf/simulated/floor/plating/dirt2))
		return
	else
		if(istype(C, /obj/item/weapon/shovel))
			var/obj/item/weapon/shovel/S = C
			if(S.contents.len)
				for(var/obj/item/I in S)
					S.contents -= I
					I.loc = src
				playsound(src, 'sound/effects/empty_shovel.ogg', 50, 1)
				src.update_icon()
				S.update_icon()
				return

/turf/simulated/floor/plating/dirt2/New()
	..()
	icon_state = "[rand(1,16)]"

/turf/simulated/floor/plating/dirt
	name = "dirt"
	icon = 'icons/turf/cavefloor.dmi'
	icon_state = "asteroid1"
	mudpit = 1
	movement_delay = 2
	glidesize = 4

	var/allowedExist = TRUE
	//temperature = CAVEDIRT
	var/diggable = 1
/turf/simulated/floor/plating/dirt/ex_act(severity)
	return

/turf/simulated/floor/plating/dirt/New()
	icon_state = "asteroid[rand(1,15)]"
	if(istype(loc, /area/dunwell/surface) || istype(loc, /area/dunwell/river) || istype(loc, /area/dunwell/village))
		var/list/prohibitedDirs = list(list(EAST, WEST), list(EAST, SOUTHWEST), list(WEST, SOUTHEAST), list(NORTH, SOUTH), list(SOUTHWEST, SOUTHEAST), list(NORTHEAST, SOUTHWEST))
		for(var/list/L in prohibitedDirs)
			var/turf/firstDir = get_step(src, L[1])
			var/turf/secondDir = get_step(src, L[2])
			if(firstDir && secondDir)
				if(firstDir.density && secondDir.density)
					break;
				for(var/obj/A in firstDir.contents)
					if(A.density)
						break;
				for(var/obj/A in secondDir.contents)
					if(A.density)
						break;
		dirt_gen_list += src
	..()

/obj/structure/lifeweb/s_stone/xsd
	name = "side walk"
	icon = 'icons/life/stonefloor.dmi'
	icon_state = "aborder1"

	plane = 0
	layer = 2
	density = 0
	opacity = 0
	mouse_opacity = 0

/obj/structure/lifeweb/s_stone/xsd/New()
	..()
	plane = 0

/obj/structure/lifeweb/s_stone/xss
	name = "side walk"
	icon = 'icons/life/stonefloor.dmi'
	icon_state = "aborder2"

	plane = 0
	layer = 2
	density = 0
	opacity = 0
	mouse_opacity = 0

/obj/structure/lifeweb/s_stone/xss/New()
	..()
	plane = 0

/turf/simulated/floor/plating/dirt/ex_act(severity)
	return

/obj/effect/snowfog
	name = "snow"
	icon = 'icons/fog.dmi'
	icon_state = "0"
	plane = 21
	layer = 5
	density = FALSE
	anchored = TRUE
	mouse_opacity = FALSE

/turf/simulated/floor/plating/coldstorage
	name = "ice"
	icon = 'icons/turf/life/snow.dmi'
	icon_state = "ironsand1"
	temperature = COLDCAVE

/turf/simulated/floor/plating/snow
	name = "snow"
	icon = 'icons/turf/life/snow.dmi'
	icon_state = "ironsand1"
	temperature = COLDCAVE
	//mouse_opacity = 0
	var/dug = 0

/turf/simulated/floor/plating/snow/New()
	..()
	name = "Snow"
	icon_state = "ironsand[rand(1,15)]"
	if(prob(5))
		if(prob(60))
			new /obj/structure/lifeweb/mushroom/surface(src)
		else
			new /obj/structure/rack/lwtable/stone(src)


/turf/simulated/floor/plating/snow/attackby(obj/item/weapon/shovel/W as obj, mob/user as mob)
	if(!W || !user)
		return 0

	if ((istype(W, /obj/item/weapon/shovel)))
		var/turf/T = user.loc
		if (!( istype(T, /turf) ))
			return

		if (dug == 3)
			return
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if ((user.loc == T && user.get_active_hand() == W) && !W.full)
			W.full = "oreminerado"
			W.icon_state = "shovel[W.full]"
			dug += 1
			icon_state = "asteroid_dug[dug]"
			playsound(src, 'sound/effects/dig_shovel.ogg', 50, 1)

		else if ((user.loc == T && user.get_active_hand() == W) && W.full == "oreminerado" || "oredochao")
			if(!dug >= 1)
				return
			W.full = 0
			W.icon_state = "shovel[W.full]"
			dug -= 1
			icon_state = "asteroid_dug[dug]"
			playsound(src, 'sound/effects/empty_shovel.ogg', 50, 1)



/turf/simulated/floor/plating/snow/gets_dug()
	if(dug == 4)
		return
	new/obj/item/weapon/ore/glass(src)
	new/obj/item/weapon/ore/glass(src)
	dug += 1
	icon_plating = "asteroid_dug"
	icon_state = "asteroid_dug"
	return


/turf/simulated/floor/plating/snow/ex_act(severity)
	return

//CATWALKS

/turf/simulated/floor/plating/catwalk
	layer = TURF_LAYER + 0.5
	icon = 'icons/turf/catwalks.dmi'
	icon_state = "catwalk"
	name = "catwalk"
	desc = "Cats really don't like these things."
	blocksOpenFalling = 1

/turf/simulated/floor/plating/catwalk/airless
	oxygen = 0.01
	nitrogen = 0.01
	temperature = TCMB