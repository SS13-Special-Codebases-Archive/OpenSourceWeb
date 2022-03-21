/*
#define BRUTE "brute"
#define BURN "burn"
#define TOX "tox"
#define OXY "oxy"
#define CLONE "clone"

#define ADD "add"
#define SET "set"
*/

/obj/item/projectile
	name = "projectile"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bullet"
	density = 1
	unacidable = 1
	anchored = 1 //There's a reason this is here, Mport. God fucking damn it -Agouri. Find&Fix by Pete. The reason this is here is to stop the curving of emitter shots.
	flags = FPRINT | TABLEPASS
	pass_flags = PASSTABLE
	mouse_opacity = 0
	gravitydep = 0
	var/bumped = 0		//Prevents it from hitting more than one guy at once
	var/def_zone = ""	//Aiming at
	var/mob/firer = null//Who shot it
	var/silenced = 0	//Attack message
	var/yo = null
	var/xo = null
	var/current = null
	var/obj/shot_from = null // the object which shot us
	var/atom/original = null // the original target clicked
	var/turf/starting = null // the projectile's starting turf
	var/list/permutated = list() // we've passed through these atoms, don't try to hit them again

	var/p_x = 16
	var/p_y = 16 // the pixel location of the tile that the player clicked. Default is the center

	var/lethal = 1

	var/damage = 10
	var/damage_type = BRUTE //BRUTE, BURN, TOX, OXY, CLONE are the only things that should be in here
	var/nodamage = 0 //Determines if the projectile will skip any damage inflictions
	var/flag = "bullet" //Defines what armor to use when it hits things.  Must be set to bullet, laser, energy,or bomb	//Cael - bio and rad are also valid
	var/projectile_type = "/obj/item/projectile"
	var/kill_count = 50 //This will de-increment every process(). When 0, it will delete the projectile.
		//Effects
	var/stun = 0
	var/weaken = 0
	var/paralyze = 0
	var/irradiate = 0
	var/stutter = 0
	var/eye_blind = 0
	var/eyeblur = 0
	var/drowsy = 0
	var/agony = 0
	var/embed = 0 // whether or not the projectile can embed itself in the mob

	var/range = 0
	var/proj_hit = 0

	proc/Range()
		if(range)
			range--
			if(range <= 0)
				on_range()
		else
			return

	Destroy()
		starting = null
		original = null
		shot_from = null
		permutated = null
		..()

	proc/on_range() //if we want there to be effects when they reach the end of their range
		proj_hit = 1
		qdel(src)

	proc/on_hit(var/atom/target, var/blocked = 0)
		if(blocked >= 2)		return 0//Full block
		if(isliving(target) && !isanimal(target))
			var/mob/living/L = target
			L.apply_effects(stun, weaken, paralyze, irradiate, stutter, eyeblur, drowsy, agony, blocked) // add in AGONY!
			if(istype(src, /obj/item/projectile/energy/electrode))
				L.eye_blind = 20
		else
			return 0
		return 1

	proc/check_fire(var/mob/living/target as mob, var/mob/living/user as mob)  //Checks if you can hit them or not.
		if(!istype(target) || !istype(user))
			return 0
		var/obj/item/projectile/test/in_chamber = new /obj/item/projectile/test(get_step_to(user,target)) //Making the test....
		in_chamber.target = target
		in_chamber.flags = flags //Set the flags...
		in_chamber.pass_flags = pass_flags //And the pass flags to that of the real projectile...
		in_chamber.firer = user
		var/output = in_chamber.process() //Test it!
		qdel(in_chamber) //No need for it anymore
		return output //Send it back to the gun!

	Bump(atom/A as mob|obj|turf|area)
		if(A == firer)
			loc = A.loc
			return 0 //cannot shoot yourself

		if(bumped)	return 0
		var/forcedodge = 0 // force the projectile to pass

		bumped = 1
		if(firer && istype(A, /mob))
			var/mob/M = A
			if(!istype(A, /mob/living))
				loc = A.loc
				return 0// nope.avi

			//Lower accurancy/longer range tradeoff. Distance matters a lot here, so at
			// close distance, actually RAISE the chance to hit.
			var/distance = get_dist(starting,loc)
			var/miss_modifier = 20
			/*if (istype(shot_from,/obj/item/weapon/gun))	//If you aim at someone beforehead, it'll hit more often. CODE ESTRANHO
				var/obj/item/weapon/gun/daddy = shot_from //Kinda balanced by fact you need like 2 seconds to aim	  NAO SEI PRA QUE SERVE, COMENTEI
				if (daddy.target && original in daddy.target) //As opposed to no-delay pew pew
					miss_modifier += -30*/
			if(istype(firer, /mob/living/carbon/human))
				var/mob/living/carbon/human = firer
				miss_modifier += (human.my_skills.GET_SKILL(SKILL_RANGE) + 20) * -1

			var/ERRADO
			var/mob/living/carbon/human/H = firer
			var/ModiFier = 0
			var/never_miss = FALSE
			if(!istype(original, /mob))
				ModiFier = 1
			var/obj/item/weapon/WW = shot_from
			if(!WW.wielded)
				ModiFier -= pick(0,0.5,1)
				if(WW.weight >= 6)
					ModiFier -= rand(6,8)
			if(distance > 3)
				ModiFier -= (distance * 2)
			else
				ModiFier += 2 //random number. Remove on rework
				if(distance == 1)
					ModiFier += 3

			if(H.reagents.has_reagent("lucky_shot"))
				never_miss = TRUE

			var/list/roll = roll3d6(H,SKILL_RANGE, ModiFier)
			var/result = roll[GP_RESULT]
			switch(result)
				if(GP_FAILED)
					ERRADO = TRUE
				if(GP_CRITFAIL)
					ERRADO = TRUE
				if(GP_SUCCESS)
					ERRADO = FALSE
				if(GP_CRITSUCCESS)
					ERRADO = FALSE
			if(istype(WW, /obj/item/weapon/gun/projectile/shotgun/princess/nevermiss))
				ModiFier += 200
				never_miss = TRUE
				forcedodge = 0 // force the projectile to pass
//			if(distance > 1)
			if(ERRADO && !never_miss)
				visible_message("<span class='hitbold'>[src]</span> <span class='hit'>misses</span> <span class='hitbold'>[M]</span> <span class='hit'>narrowly!</span>")
				forcedodge = -1
			var/mob/living/carbon/human/HH = M
			if((HH.special == "bulletdodger" || HH.reagents.has_reagent("impossible_targets")) &&!never_miss)// bullet dodger
				if(prob(90))
					def_zone = 0
					visible_message("<span class='hitbold'>[HH]</span> <span class='hit'>dodges \the [src]!</span>")
					forcedodge = -1

			if(HH.hasActiveShield(1))//
				def_zone = 0
				visible_message("<span class='hitbold'>[src]</span> <span class='hit'>is deflected by</span> <span class='hitbold'>[HH]</span> <span class='hit'>energy shield!</span>")
				forcedodge = -1
				playsound(HH.loc, 'sound/effects/energyparrylas.ogg', 100, 1)
				current = firer
/*
			if(!istype(original, /mob))//se tu nao clicar no cara
				if(ERRADO)
					def_zone = 0
					if(istype(M, /mob/living/carbon/human))
						if(!HH.shielded)
							visible_message("<span class='combatbold'>[src]</span> <span class='combat'>misses</span> <span class='combatbold'>[M]</span> <span class='combat'>narrowly!</span>")
					else
						visible_message("<span class='combatbold'>[src]</span> <span class='combat'>misses</span> <span class='combatbold'>[M]</span> <span class='combat'>narrowly!</span>")
					forcedodge = -1
*/
			if(silenced)
				to_chat(M, "<span class='hitbold'>You've been shot in the [parse_zone(def_zone)] by the</span> <span class='hitbold'>[src.name]!</span>")
			else if(forcedodge != -1)
				var/moreTXT = ""
				var/HT = HH.my_stats.ht
				var/datum/organ/external/E = HH.organs_by_name[def_zone]
				var/datum/organ/internal/I = pick(E?.internal_organs)
				if(lethal)
					var/internal_chance = 100
					var/internal_damage = src.damage
					var/shit_happening = 100

					if(HT <= 8)
						if(I)
							I.take_damage(internal_damage)
					else
						if(!HT >= 20)
							switch(HT)
								if(9)
									internal_damage -= 5
								if(10)
									internal_damage -= 15
								if(11)
									internal_damage -= 20
								if(12)
									internal_damage -= 25
								if(13)
									internal_damage -= 30
									internal_chance = 90
									shit_happening = 90
								if(14)
									internal_damage -= 35
									internal_chance = 85
									shit_happening = 85
								if(15)
									internal_damage -= 40
									internal_chance = 60
									shit_happening = 55
								if(16)
									internal_damage -= 45
									internal_chance = 40
									shit_happening = 35
								if(16)
									internal_damage -= 45
									internal_chance = 40
									shit_happening = 35
								if(17)
									internal_damage -= 50
									internal_chance = 30
									shit_happening = 25
								if(18)
									internal_damage -= 45
									internal_chance = 30
									shit_happening = 25
								if(19)
									internal_damage -= 45
									internal_chance = 15
									shit_happening = 15
					internal_chance = max(0, internal_chance - HH.getarmor(def_zone, src.flag))
					shit_happening = max(0, shit_happening - HH.getarmor(def_zone, src.flag))
					internal_damage = max(0, internal_damage - HH.getarmor(def_zone, src.flag))
					if(prob(internal_chance) && I && !istype(HH?.species, /datum/species/human/alien))
						I.take_damage(internal_damage)
						moreTXT += "<span class='hit'>An internal organ has been damaged. </span>"
					if(prob(shit_happening) && !istype(HH?.species, /datum/species/human/alien))
						var/list/What = list()
						var/list/CantCrippleList = list("chest", "throat", "head", "face", "mouth", "groin", "vitals")
						if(!(E.status & ORGAN_BROKEN))
							What += "fracture"
						if(E.artery_prob && !(E.status & ORGAN_ARTERY))
							What += "artery"
						if(E.tendon_prob && !(E.status & ORGAN_TENDON))
							What += "tendon"
						if(!E.name in CantCrippleList)
							What += "cripple"
						var/HAPPEN
						if(What.len)
							HAPPEN = pick(What)
							switch(HAPPEN)
								if("fracture")

									if(E.name == "chest")
										moreTXT += "<span class='hit'>The ribs have been crushed! </span>"
									else
										moreTXT += "<span class='hit'>A bone has been crushed! </span>"
									E.fracture()
								if("artery")
									moreTXT += "<span class='combatbold'>An artery has been torn! </span>"

									E.sever_artery()
								if("tendon")
									moreTXT += "<span class='combatbold'>A tendon has been torn! </span>"
									E.tendon_ize()
								if("cripple")
									moreTXT += "<span class='hit'>A bone has been dislocated! </span>"
									E.cripple_ize()
					if(E.name == "head" && !istype(HH?.species, /datum/species/human/alien))
						moreTXT += "<span class='hitbold'>[A] has been disoriented! </span>"
						if(HH.client)
							HH?.CU()
							HH?.film_grain2.blend_mode = 3
							HH?.film_grain2.alpha = 255
							spawn(250)
								HH?.film_grain2.blend_mode = 4
								HH?.film_grain2.alpha = 190

							HH?.make_dizzy(600)
							HH?.ear_deaf += 60

						if(HH.wear_mask)
							HH.wear_mask.add_blood(src)
							HH.update_inv_wear_mask(0)
						if(HH.head)
							HH.head.add_blood(src)
							HH.update_inv_head(0)
						if(HH.glasses && prob(33))
							HH.glasses.add_blood(src)
							HH.update_inv_glasses(0)

					else
						HH.bloody_body(HH)

				var/turf/T = get_turf(A)
				T.add_blood(A)
				visible_message("<span class='hitbold'>[A.name]'s [parse_zone(def_zone)] was hit by [src.name]!</span> [moreTXT]")//X has fired Y is now given by the guns so you cant tell who shot you if you could not see the shooter


			if(istype(firer, /mob))
				M.attack_log += "\[[time_stamp()]\] <b>[firer]/[firer.ckey]</b> shot <b>[M]/[M.ckey]</b> with a <b>[src.type]</b>"
				firer.attack_log += "\[[time_stamp()]\] <b>[firer]/[firer.ckey]</b> shot <b>[M]/[M.ckey]</b> with a <b>[src.type]</b>"
				message_admins("ATTACK: [firer] ([firer.ckey])(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[firer.x];Y=[firer.y];Z=[firer.z]'>JMP</A>) shot [M] ([M.ckey]) with [src].") //BS12 EDIT ALG
			else
				M.attack_log += "\[[time_stamp()]\] <b>UNKNOWN SUBJECT (No longer exists)</b> shot <b>[M]/[M.ckey]</b> with a <b>[src]</b>"
				message_admins("ATTACK: UNKNOWN (no longer exists) shot [M] ([M.ckey])(<A HREF='?_src_=holder;adminplayerobservejump=\ref[M]'>JMP</A>) with [src].") //BS12 EDIT ALG
		spawn(0)
			if(A)
				if (!forcedodge)
					forcedodge = A.bullet_act(src, def_zone) // searches for return value
				if(forcedodge == -1) // the bullet passes through a dense object!
					bumped = 0 // reset bumped variable!
					if(istype(A, /turf))
						loc = A
					else
						loc = A.loc
					permutated.Add(A)
					return 0
				if(istype(A,/turf))
					for(var/obj/O in A)
						O.bullet_act(src)
					for(var/mob/M in A)
						M.bullet_act(src, def_zone)
				density = 0

				invisibility = 101
				qdel(src)
		return 1


	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(air_group || (height==0)) return 1

		if(istype(mover, /obj/item/projectile))
			return prob(95)
		else
			return 1


	process()
		if(kill_count < 1)

			qdel(src)
		kill_count--
		spawn while(src)
			if((!( current ) || loc == current))
				current = locate(min(max(x + xo, 1), world.maxx), min(max(y + yo, 1), world.maxy), z)
			if((x == 1 || x == world.maxx || y == 1 || y == world.maxy))

				qdel(src)
				return

			step_towards(src, current, 3000)

			if(istype(src, /obj/item/projectile/bullet/fire))
				new /obj/structure/fire(src.loc)

			sleep(0.0001)
			if(!bumped && !isturf(original))
				if(loc == get_turf(original))
					if(!(original in permutated))
						Bump(original)
						sleep(0.0001)
		return

	proc/dumbfire(var/dir) // for spacepods, go snowflake go
		if(!dir)

			qdel(src)
		if(kill_count < 1)

			qdel(src)
		kill_count--
		spawn while(loc)
			var/turf/T = get_step(src, dir)
			step_towards(src, T)
			if(!bumped && !isturf(original))
				if(loc == get_turf(original))
					if(!(original in permutated))
						Bump(original)
						sleep(1)
			sleep(1)
		return

/obj/item/projectile/test //Used to see if you can hit them.
	invisibility = 101 //Nope!  Can't see me!
	yo = null
	xo = null
	var/target = null
	var/result = 0 //To pass the message back to the gun.

	Bump(atom/A as mob|obj|turf|area)
		if(A == firer)
			loc = A.loc
			return //cannot shoot yourself
		if(istype(A, /obj/item/projectile))
			return
		if(istype(A, /mob/living))
			result = 2 //We hit someone, return 1!
			return
		result = 1
		return

	process()
		var/turf/curloc = get_turf(src)
		var/turf/targloc = get_turf(target)
		if(!curloc || !targloc)
			return 0
		yo = targloc.y - curloc.y
		xo = targloc.x - curloc.x
		target = targloc
		while(src) //Loop on through!
			if(result)
				return (result - 1)
			if((!( target ) || loc == target))
				target = locate(min(max(x + xo, 1), world.maxx), min(max(y + yo, 1), world.maxy), z) //Finding the target turf at map edge
			step_towards(src, target)
			var/mob/living/M = locate() in get_turf(src)
			if(istype(M)) //If there is someting living...
				return 1 //Return 1
			else
				M = locate() in get_step(src,target)
				if(istype(M))
					return 1
