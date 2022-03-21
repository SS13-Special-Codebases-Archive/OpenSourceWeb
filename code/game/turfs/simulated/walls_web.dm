/turf/simulated/wall/r_wall/cave
	name = "cave wall"
	desc = ""
	icon_state = "cave0"
	icon = 'icons/turf/cave2.dmi'
	walltype = "cave"
	var/hitstaken = 0
	var/hitlimit = 8
	climbable = TRUE
	turf_above = /turf/simulated/floor/plating/dirt
	var/cantbreak = FALSE

/turf/simulated/wall/r_wall/cave/white
	name = "cave wall"
	desc = "this one is slightly lighter."
	icon = 'cave2.dmi'

/turf/simulated/wall/r_wall/cave/white/hard
	name = "hard cave wall"
	cantbreak = TRUE
	climbable = FALSE
	icon = 'cave2.dmi'


/turf/simulated/wall/r_wall/cave/white/hard/surface
	name = "hard surface wall"
	cantbreak = TRUE
	climbable = FALSE
	icon = 'cave_snow.dmi'


/turf/simulated/wall/r_wall/cave/examine()
	..()
	for(var/W in range(5, src))
		if(!istype(W, /turf/simulated/wall/r_wall/cave) && istype(W, /turf/simulated/wall))
			to_chat(usr, "<span class='passive'>The rock has enough support.</span>")
			return
		else if(istype(W, /obj/structure/lifeweb/statue/pillar) || istype(W, /obj/structure/lifeweb/stairs))
			to_chat(usr, "<span class='passive'>The rock has enough support.</span>")
			return

/turf/simulated/wall/r_wall/cave/proc/collapse_check()
	var/supportfound = FALSE
	for(var/W in range(5, src))
		if(!istype(W, /turf/simulated/wall/r_wall/cave) && istype(W, /turf/simulated/wall))
			supportfound = TRUE
		else if(istype(W, /obj/structure/lifeweb/statue/pillar) || istype(W, /obj/structure/lifeweb/stairs))
			supportfound = TRUE

	if(supportfound)
		return FALSE
	else
		if(prob(3))
			playsound(src,'sound/effects/cavein.ogg',150,1,10)
			for (var/mob/living/carbon/human/M in range(2, src))
				M.Weaken(15)
				to_chat(M, "<span class='combat'>The cave collapses!</span>")
				new/obj/structure/rack/lwtable/stone(M.loc)
				new/obj/structure/rack/lwtable/stone(src.loc)
				var/chosenOrgan = pick(M.organs_by_name)
				var/chosenOrgan2 = pick(M.organs_by_name)
				var/chosenOrgan3 = pick(M.organs_by_name)
				M.apply_damage(rand(20,80), BRUTE, chosenOrgan)
				M.apply_damage(rand(20,80), BRUTE, chosenOrgan2)
				M.apply_damage(rand(20,80), BRUTE, chosenOrgan3)
				shake_camera(M, 10, 2)
			for(var/turf/simulated/wall/r_wall/cave/SS in range(6, src))
				if(SS.cantbreak) continue
				else if(prob(90))
					if(prob(50))
						new /obj/structure/rack/lwtable/stone(SS.loc)
						new /obj/item/weapon/stone(SS.loc)
					else
						if(prob(80))
							new /obj/item/weapon/stone(SS.loc)
							new /obj/item/weapon/stone(SS.loc)
							new /obj/item/weapon/stone(SS.loc)
							if(prob(50))
								new /obj/item/weapon/stone(SS.loc)
								new /obj/item/weapon/stone(SS.loc)
					SS.ChangeTurfNew(turf_above)
			playsound(src,pick('dustdrop.ogg','fx_dust_a_01.ogg','fx_dust_a_02.ogg','fx_dust_a_03.ogg'),75,1,8)
			for(var/turf/simulated/floor/T in range(src,6))
				T.overlays += image(icon='icons/mining.dmi',icon_state="dustofdanger", layer = 5)
				spawn(11)
					T.overlays -= image(icon='icons/mining.dmi',icon_state="dustofdanger", layer = 5)
			return TRUE
		else
			if(prob(90))
				playsound(src,pick('dustdrop.ogg','fx_dust_a_01.ogg','fx_dust_a_02.ogg','fx_dust_a_03.ogg'),75,1,8)
				for(var/turf/simulated/floor/T in range(src,2))
					T.overlays += image(icon='icons/mining.dmi',icon_state="dustofdanger", layer = 5)
					spawn(11)
						T.overlays -= image(icon='icons/mining.dmi',icon_state="dustofdanger", layer = 5)
				return FALSE
			return FALSE

/turf/simulated/wall
	var/istop = 1

/turf/simulated/wall/proc/targetZ()
	return src.z + (istop ? 1 : -1)

/turf/simulated/wall/proc/climbWall(mob/living/carbon/human/user as mob)
	if(!climbable)
		to_chat(user, "<span class='combatbold'>[pick(nao_consigoen)] I can't even imagine climbing this!</span>")
		return
	if(!check_both_hands_empty(user))
		to_chat(user, "<span class='combatbold'>[pick(nao_consigoen)] My hands must be empty!</span>")
		return
	if(user.stat)
		return

	if(user.resting)
		return

	if(user.sleeping)
		return

	if(!user.canmove)
		return

	for(var/limbcheck in list(BP_L_LEG,BP_R_LEG))//But we need to see if we have legs.
		var/obj/item/weapon/reagent_containers/food/snacks/organ/affecting = user.get_organ(limbcheck)
		if(!affecting)//Oh shit, we don't have have any legs, we can't jump.
			return

	if(rotting)
		to_chat(user, "<span class='passive'>This wall feels rather unstable.</span>")
		return

	src.add_fingerprint(user)
	var/turf/controllerlocation = locate(1, 1, user.z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		if(controller.up)
			var/turf/above = locate(user.x, user.y, controller.up_target)
			if(istype(above,/turf/space) || istype(above,/turf/simulated/floor/open))
				if(istype(above,/turf/simulated/floor/lifeweb/stone/ladder))
					var/turf/simulated/floor/lifeweb/stone/ladder/L = above
					if(!L.opened)
						to_chat(user, "<span class='combatbold'>[pick(nao_consigoen)]</span><span class='combat'> there's a closed manhole above me!</span>")
						return
				to_chat(user, "<span class='passive'>You start climbing [src].</span>")
				var/mob/living/carbon/human/H = user
				var/turf/T = locate(src.x, src.y, targetZ())
				if(T.density)
					to_chat(user, "<span class='hitbold'>I cannot climb [src]!</span>")
					return
				if(do_after(user, 42-H.my_skills.GET_SKILL(SKILL_CLIMB)))
					var/list/rolled = roll3d6(H,SKILL_CLIMB,null)
					switch(rolled[GP_RESULT])
						if(GP_FAILED)
							to_chat(user, "<span class='hitbold'>You failed to climb [src]!</span>")
							if(user.special == "notafraid")
								to_chat(user, "You land softly.")
								playsound(user, pick('sound/webbers/fst_stone_solid_land_01.ogg', 'sound/webbers/fst_stone_solid_land_02.ogg'), 80, 1)
								user.visible_message("<span class='bname'>[user.name]</span> lands softly!")
								return
							var/damage = rand(10,30)
							H.apply_damage(damage + rand(-5,12), BRUTE, "l_leg")
							H.apply_damage(damage + rand(-5,12), BRUTE, "r_leg")
							H.apply_damage(damage + rand(-5,12), BRUTE, "l_foot")
							H.apply_damage(damage + rand(-5,12), BRUTE, "r_foot")
							H:weakened = max(H:weakened,4)
							playsound(H.loc, 'sound/effects/fallsmash.ogg', 100, 0)
							if(prob(70))
								H.emote("fallscream",1)
							if(prob(40))
								var/time = rand(2, 6)
								H.Paralyse(time)
								H.Stun(time)
							H:updatehealth()
							return
						if(GP_CRITFAIL)
							to_chat(user, "<span class='crithit'>CRITICAL FAILURE!</span> <span class='hitbold'>You failed to climb [src]!</span>")
							if(user.special == "notafraid")
								to_chat(user, "You land softly.")
								playsound(user, pick('sound/webbers/fst_stone_solid_land_01.ogg', 'sound/webbers/fst_stone_solid_land_02.ogg'), 80, 1)
								user.visible_message("<span class='bname'>[user.name]</span> lands softly!")
								return
							var/damage = rand(28,40)
							H.apply_damage(damage/2 + rand(-5,12), BRUTE, "l_leg")
							H.apply_damage(damage/2 + rand(-5,12), BRUTE, "r_leg")
							H.apply_damage(damage + rand(-5,12), BRUTE, "l_foot")
							H.apply_damage(damage + rand(-5,12), BRUTE, "r_foot")
							H.apply_damage(damage/2 + rand(-5,12), BRUTE, "head")
							H:weakened = max(H:weakened,8)
							playsound(H.loc, 'sound/effects/fallsmash.ogg', 100, 0)
							if(prob(70))
								H.emote("fallscream",1)
							if(prob(40))
								var/time = rand(2, 6)
								H.Paralyse(time)
								H.Stun(time)
							H:updatehealth()
							var/DICELOL = roll("3d6")
							if(DICELOL <= 8)
								H.apply_effect(5, PARALYZE)
								visible_message("<span class='combatglow'><b>[H]</b> has been knocked unconscious!</span>")
								H.ear_deaf = max(H.ear_deaf,6)
								H.CU()
							return
						if(GP_SUCCESS, GP_CRITSUCCESS)
							user.forceMove(locate(src.x, src.y, targetZ()))
							to_chat(user, "<span class='passive'>You climb [src].</span>")
							playsound(user.loc, 'sound/effects/climb.ogg', 40, 1)
							return
	return

/turf/simulated/wall/proc/climbWallHelp(mob/living/carbon/human/user as mob, var/mob/living/carbon/human/assailant, var/obj/item/weapon/grab/W)
	if(!climbable)
		to_chat(assailant, "<span class='combatbold'>[pick(nao_consigoen)] I can't even imagine climbing this!</span>")
		return
	if(!user.resting || !user.lying)
		return
	src.add_fingerprint(user)
	var/turf/controllerlocation = locate(1, 1, user.z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		if(controller.up)
			var/turf/above = locate(user.x, user.y, controller.up_target)
			if(istype(above,/turf/space) || istype(above,/turf/simulated/floor/open))
				to_chat(assailant, "<span class='passive'>You start pushing [user] up \the [src].</span>")
				if(do_after(assailant, 10))
					user.forceMove(locate(src.x, src.y, targetZ()))
					playsound(user.loc, 'sound/effects/climb.ogg', 40, 1)
					visible_message("<span class='passive'>[assailant]</span> helps [user] to climb \the [src]!</span>")
					user.drop_from_inventory(W)
	return


/turf/simulated/wall/r_wall/cave/attack_hand(mob/living/carbon/human/user as mob)
	src.add_fingerprint(user)
	climbWall(user)


/turf/simulated/wall/r_wall/cave/attackby(obj/item/weapon/W as obj, mob/living/carbon/human/user as mob)
	if(istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = W
		if(G.aforgan.display_name == "chest")
			climbWallHelp(G.affecting, G.assailant, G)
	if(istype(W, /obj/item/weapon/pickaxe))
		var/obj/item/weapon/pickaxe/P = W
		if(cantbreak)
			to_chat(user, "<span class='bname'>TOO HARD!!!</span>")
			playsound(W.loc, pick('npc_human_pickaxe_01.ogg','npc_human_pickaxe_02.ogg','npc_human_pickaxe_03.ogg','npc_human_pickaxe_05.ogg'), 25, 1, -1)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			return
		var/list/roll_result = roll3d6(user,SKILL_MINE, -3, FALSE)
		switch(roll_result[GP_RESULT])
			if(GP_SUCCESS, GP_CRITSUCCESS)
				to_chat(user, "<span class='passive'>You hit [src]!</span>")
				playsound(W.loc, pick('npc_human_pickaxe_01.ogg','npc_human_pickaxe_02.ogg','npc_human_pickaxe_03.ogg','npc_human_pickaxe_05.ogg'), 25, 1, -1)
				var/mining_hits = P.mining_power + round((user.my_stats.st - 10)/2)
				if(mining_hits < 1)
					mining_hits = 1
				if(roll_result[GP_RESULT] == GP_CRITSUCCESS)
					mining_hits *= 2
				hitstaken += mining_hits
			if(GP_FAILED, GP_CRITFAIL)
				to_chat(user, "<span class='combat'>You hit [src]!</span>")
				playsound(W.loc, pick('npc_human_pickaxe_01.ogg','npc_human_pickaxe_02.ogg','npc_human_pickaxe_03.ogg','npc_human_pickaxe_05.ogg'), 25, 1, -1)
				if(roll_result[GP_RESULT] == GP_CRITFAIL)
					P.durability -= 5

		P.durability -= 1
		handle_mining()
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	else
		..()
/turf/simulated/wall/r_wall/cave/proc/handle_mining()
	collapse_check()
	if(hitstaken < hitlimit)
		return
	var/amount = rand(1, 2)
	var/list/loc_use = list("x" = src.x, "y" = src.y, "z" = src.z)
	//new /turf/simulated/floor/plating/dirt(src.loc)
	ChangeTurfNew(turf_above)
	for(var/turf/simulated/wall/W in range(1, src))
		W.relativewall()
	var/ore_loc = locate(loc_use["x"],loc_use["y"],loc_use["z"])
	for(var/a = 0, a <= amount, a++)
		new /obj/item/weapon/stone(ore_loc)
	if(prob(33))
		var/chance_ores = rand(1,101)
		switch(chance_ores)
			if(1 to 40)
				new /obj/item/weapon/ore/lw/coal(ore_loc)
			if(41 to 70)
				new /obj/item/weapon/ore/lw/copperlw(ore_loc)
			if(71 to 90)
				new /obj/item/weapon/ore/lw/ironlw(ore_loc)
			if(91 to 95)
				new /obj/item/weapon/ore/lw/silverlw(ore_loc)
			if(96 to 99)
				new /obj/item/weapon/ore/lw/goldlw(ore_loc)
			if(100)
				new /obj/item/weapon/ore/lw/adamantinelw(ore_loc)
			if(101)
				new /obj/item/gem(ore_loc)


/turf/simulated/wall/r_wall/cave/RightClick(mob/living/carbon/human/user)
	if(istype(user.get_active_hand(), /obj/item/weapon/pickaxe) && user.my_skills.GET_SKILL(SKILL_MINE) >= 3)
		to_chat(user, "<span class='combatbold'>You hit [src]!</span>")
		playsound(user.loc, pick('npc_human_pickaxe_01.ogg','npc_human_pickaxe_02.ogg','npc_human_pickaxe_03.ogg','npc_human_pickaxe_05.ogg'), 25, 1, -1)
		if(cantbreak || siegeblocked || src.z >= 6)
			to_chat(user, "<span class='bname'>TOO HARD!!!</span>")
			return
		collapse_check()
		var/above = locate(src.x, src.y, src.z+1)
		if(above)
			if(istype(above, /turf/simulated/wall) && !istype(above, /turf/simulated/wall/r_wall/cave))
				return
			if(istype(above, /turf/simulated/wall/r_wall/cave))
				var/turf/simulated/floor/lifeweb/stone/handmade/H = new(above)
				H.reconsider_lights()
				for(var/turf/T in view(7, H))
					T.reconsider_lights()
				H.reconsider_lights()
				above = locate(src.x, src.y, src.z+1)
			hitstaken = hitlimit
			handle_mining()
			var/obj/structure/lifeweb/stairs/cave/S1 = new(above)
			var/loc_s2 = locate(S1.x, S1.y, S1.z-1)
			var/obj/structure/lifeweb/stairs/cave/down/S2 = new(loc_s2)
			S1.dir = turn(user.dir, 180)
			S1.find_stairs_where()
			S2.dir = turn(user.dir, 180)
			S2.find_stairs_where()

/turf/simulated/wall/r_wall/metal
	name = "metal wall"
	desc = "A metal wall."
	icon_state = "metalic"
	walltype = "metalic"
	climbable = TRUE
	turf_above = /turf/simulated/floor/lifeweb

/turf/simulated/wall/r_wall/leviathan
	name = "metal wall"
	desc = "A wall made of Leviathan steel. God be saved."
	icon_state = "leviathan"
	walltype = "leviathan"

/turf/simulated/wall/r_wall/keep
	name = "noble wall"
	desc =  "A noble wall. Fancy?"
	icon = 'icons/turf/keepwall.dmi'
	turf_above = /turf/simulated/floor/lifeweb/spookyplaza

/turf/simulated/wall/r_wall/keep/relativewall()
	return 0

/turf/simulated/wall/r_wall/keep/_2
	icon_state = "2"

/turf/simulated/wall/r_wall/keep/_4
	icon_state = "4"

/turf/simulated/wall/r_wall/keep/_5
	icon_state = "5"

/turf/simulated/wall/r_wall/keep/bg
	icon_state = "bg"

/turf/simulated/wall/r_wall/charon
	New()
		return 0

/turf/simulated/wall/r_wall/charon/relativewall()
	return 0

/turf/simulated/wall/r_wall/keepss13
	name = "noble wall"
	desc =  "A noble wall. Fancy?"
	icon = 'icons/turf/walls.dmi'

/turf/simulated/wall/r_wall/keepss13/relativewall()
	return 0

/turf/simulated/wall/r_wall/keepss13/_1
	icon_state = "r1"

/turf/simulated/wall/r_wall/keepss13/_2
	icon_state = "r2"

/turf/simulated/wall/r_wall/keepss13/_3
	icon_state = "r3"

/turf/simulated/wall/r_wall/charon/charon1
	icon_state = "vau2"

//icon.MapColors(rgb(51,13,13), rgb(26,77,51), rgb(26,26,102), rgb(0,0,0))

/turf/simulated/wall/r_wall/charon/charon2
	icon_state = "vau3"

/turf/simulated/wall/r_wall/charon/charon3
	icon_state = "vau4"

/turf/simulated/wall/r_wall/charon/charon4
	icon_state = "ch2"

/turf/simulated/wall/r_wall/charon/charon5
	icon_state = "ch22"

/turf/simulated/wall/r_wall/charon/charon6
	icon_state = "ch223"

/turf/simulated/floor/lifewebe/CHAOFAKE
	icon_state = "asteroid_anim"

/turf/simulated/floor/lifewebe/CHAOFAKE/Entered(AM)
	if(!istype(AM, /mob/living))
		if(!istype(AM, /obj))
			return
		else
			qdel(AM)
		return
	var/mob/living/M = AM
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.fakegib()
	else
		M.gib()

/turf/simulated/wall/r_wall/cave/animated
	icon_state = "caves_anim"

	New()
		return 0
	relativewall()
		return 0