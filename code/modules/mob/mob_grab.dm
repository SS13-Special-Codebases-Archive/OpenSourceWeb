#define UPGRADE_COOLDOWN	40
#define UPGRADE_KILL_TIMER	100

/obj/item/weapon/grab
	name = "grab"
	flags = NOBLUDGEON
	var/obj/screen/grab/hud = null
	var/mob/affecting = null
	var/mob/assailant = null
	var/datum/organ/external/aforgan = null
	var/state = GRAB_AGGRESSIVE

	var/allow_upgrade = 0
	var/last_upgrade = 1
	icon_state = "takedown"
	layer = 21
	abstract = 1
	item_state = "nothing"
	throw_range = 3
	w_class = 5.0

/obj/item/weapon/grab/wrench
	name = "wrench"
	icon_state = "wrench"
	throw_range = 2

/obj/item/weapon/grab/wrench/New(mob/user, mob/victim)
	..()
	loc = user
	assailant = user
	affecting = victim

	if(ishuman(affecting))
		var/mob/living/carbon/human/H = affecting
		H.lastDir = assailant.dir

		if(ishuman(assailant))
			var/mob/living/carbon/human/HH = assailant

			aforgan = H.get_organ(HH.zone_sel.selecting)
	if(affecting.anchored)
		qdel(src)
		return

	hud = new /obj/screen/grab(src)
	hud.master = src
	hud.name = "wrench grab"

	hud.icon_state = "wrench"


/obj/item/weapon/grab/wrench/s_click(obj/screen/S)
	var/mob/living/carbon/human/AS = assailant
	var/mob/living/carbon/human/AF = affecting
	var/datum/organ/external/affectedorgan = aforgan
	if(!affecting)
		return
	if(state == GRAB_UPGRADING)
		return
	if(assailant.next_move > world.time)
		return
	if(world.time < (last_upgrade + UPGRADE_COOLDOWN))
		return
/*
	if(!assailant.canmove || assailant.lying)
		qdel(src)
		return
*/
	if(AS.a_intent == "hurt")
		if(AS.consyte) return AS.vomit()
		if(iszombie(AS)) return
		if(istype(AS?.species, /datum/species/human/alien)) return
		if(AS.wrenchTry(AS, AF))
			if (affectedorgan.status & ORGAN_BROKEN)
				AS.visible_message("<span class='hitbold'>[assailant]</span> <span class='hit'>twists</span> <span class='hitbold'>[AF]</span> <span class='hit'>[affectedorgan.display_name]!</span>")
				playsound(AF.loc, 'bite.ogg', 75, 0, -1)
				var/baseDamage = 10
				var/chanceToFracture = 40
				var/attack_mod = 0
				var/target_mod = 0
				if(AF.isChild())
					attack_mod += 10
				if(AS.isChild())
					attack_mod -= 10
				var/list/attack_roll = roll3d6(AS,SKILL_UNARM,attack_mod)
				var/list/target_roll = roll3d6(AF,SKILL_UNARM,target_mod)

				var/attack_result = attack_roll[GP_RESULT]
				var/attack_margin = attack_roll[GP_MARGIN]

				var/target_result = target_roll[GP_RESULT]
				var/target_margin = target_roll[GP_MARGIN]

				baseDamage += attack_margin
				chanceToFracture += attack_margin

				if(attack_result < target_result)
					chanceToFracture -= target_margin
					baseDamage 	-= target_margin


				AF.apply_damage(baseDamage, BRUTE, affectedorgan)
				AS.adjustStaminaLoss(rand(8,13))


				if(chanceToFracture >= 100)
					chanceToFracture = 88
				if(prob(chanceToFracture))
					if(istype(affectedorgan, /datum/organ/external/head))
						var/datum/organ/external/head/H = affectedorgan
						if (H.headwrenched == 0  && (attack_result == GP_CRITSUCCESS || attack_result == GP_SUCCESS))
							H.wrenchedhead()
							AS.visible_message("<span class='hitbold'>[AF]</span> <span class='hit'>[affectedorgan.display_name] rotates at an unnatural angle!</span>")
					else
						AS.visible_message("<span class='hitbold'>[AF]</span> <span class='hit'>[affectedorgan.display_name] was fractured!</span>")
						affectedorgan.fracture()
			else

				AS.visible_message("<span class='hitbold'>[assailant]</span> <span class='hit'>wrenches</span> <span class='hitbold'>[AF]</span> <span class='hit'>[affectedorgan.display_name]!</span>")
				playsound(AF.loc, 'bite.ogg', 75, 0, -1)

				var/baseDamage = 25
				var/chanceToFracture = 10
				var/attack_mod = 0
				var/target_mod = 0

				if(AF.isChild())
					attack_mod += 25
				if(AS.isChild())
					attack_mod -= 25

				var/list/attack_roll = roll3d6(AS,SKILL_UNARM,attack_mod)
				var/list/target_roll = roll3d6(AF,SKILL_UNARM,target_mod)

				var/attack_result = attack_roll[GP_RESULT]
				var/attack_margin = attack_roll[GP_MARGIN]

				var/target_result = target_roll[GP_RESULT]
				var/target_margin = target_roll[GP_MARGIN]

				baseDamage += attack_margin
				chanceToFracture += attack_margin

				if(attack_result < target_result)
					chanceToFracture -= target_margin
					baseDamage 	-= target_margin


				AF.apply_damage(baseDamage, BRUTE, affectedorgan)
				AS.adjustStaminaLoss(rand(8,13))

				if(prob(chanceToFracture) || attack_result == GP_CRITSUCCESS)
					if(istype(affectedorgan, /datum/organ/external/head))
						var/datum/organ/external/head/H = affectedorgan
						if(!H.headwrenched && attack_result == GP_CRITSUCCESS)
							H.wrenchedhead()
							AS.visible_message("<span class='hitbold'>[AF]</span> <span class='hit'>[affectedorgan.display_name] rotates at an unnatural angle!</span>")

					else
						AS.visible_message("<span class='hitbold'>[AF]</span> <span class='hit'>[affectedorgan.display_name] was fractured!</span>")
						affectedorgan.fracture()
		else
			AS.visible_message("<span class='hitbold'>[assailant]</span> <span class='hit'>tries to wrench</span> <span class='hitbold'>[AF]</span> <span class='hit'>[affectedorgan.display_name]!</span>")
			AS.adjustStaminaLoss(rand(3,8))

	if(AS.a_intent == "help")
		if(iszombie(AS)) return
		if(istype(AS?.species, /datum/species/human/alien)) return
		if (affectedorgan.cripple_left > 0)
			if(skillcheck(AS.my_skills.GET_SKILL(SKILL_SURG), 30, 0, AS) || prob(40))
				AS.visible_message("<span class='combatbold'>[assailant]</span> <span class='combat'>fixes</span> <span class='combatbold'>[AF]</span> <span class='combat'>[affectedorgan.display_name]!</span>")
				playsound(AF.loc, 'bone_crack.ogg', 75, 0, -1)
				affectedorgan.cripple_left = 0
				AS.adjustStaminaLoss(rand(5,10))
			else
				AS.visible_message("<span class='combatbold'>[assailant]</span> <span class='combat'>fails to fix</span> <span class='combatbold'>[AF]</span> <span class='combat'>[affectedorgan.display_name]!</span>")
				playsound(AF.loc, 'bite.ogg', 75, 0, -1)
				AF.apply_damage(rand(10, 20)+AS.my_stats.st-AF.my_stats.ht, BRUTE, affectedorgan)
				AS.adjustStaminaLoss(rand(10,15))
		if(istype(affectedorgan, /datum/organ/external/head))
			var/datum/organ/external/head/H = affectedorgan
			if(H.headwrenched)
				H.unwrenchedhead()

	AS.setClickCooldown(DEFAULT_SLOW_COOLDOWN)

/obj/item/weapon/grab/stucked
	name = "stucked"
	icon_state = "tear"
	throw_range = 3

/obj/item/weapon/grab/stucked/New(mob/user, mob/victim)
	..()
	loc = user
	assailant = user
	affecting = victim
/*
	if(affecting.anchored)
		qdel(src)
		return
*/
	if(ishuman(affecting))
		var/mob/living/carbon/human/H = affecting
		H.lastDir = assailant.dir
	hud = new /obj/screen/grab(src)
	hud.icon_state = "tear"
	hud.name = "stucked grab"
	hud.master = src

/obj/item/weapon/grab/stucked/s_click(obj/screen/S)//(obj/screen/S)
	var/mob/living/carbon/human/AS = assailant
	var/mob/living/carbon/human/AF = affecting
	if(!affecting)
		return
	if(state == GRAB_UPGRADING)
		return
	if(assailant.next_move > world.time)
		return
	if(world.time < (last_upgrade + UPGRADE_COOLDOWN))
		return
	/*
	if(!assailant.canmove || assailant.lying)
		qdel(src)
		return*/
	AF.yank_out_object(AS)
	qdel(src)

/obj/item/weapon/grab/New(mob/user, mob/victim)
	..()
	loc = user
	assailant = user
	affecting = victim
/*
	if(affecting.anchored)
		qdel(src)
		return
*/
	if(ishuman(affecting))
		var/mob/living/carbon/human/H = affecting
		H.lastDir = assailant.dir

		if(ishuman(assailant))
			var/mob/living/carbon/human/HH = assailant

			aforgan = H.get_organ(HH.zone_sel.selecting)
	hud = new /obj/screen/grab(src)
	hud.icon_state = "reinforce"
	hud.name = "reinforce grab"
	hud.master = src


//Used by throw code to hand over the mob, instead of throwing the grab. The grab is then deleted by the throw code.
/obj/item/weapon/grab/proc/throw_mob()
	if(affecting == assailant)
		return null
	if(state == GRAB_NECK)
		return null
	if(affecting)
		if(affecting.buckled)
			return null
		if(state >= GRAB_AGGRESSIVE)
			return affecting
	return null


//This makes sure that the grab screen object is displayed in the correct hand.
/obj/item/weapon/grab/proc/synch()
	if(affecting)
		if(assailant.r_hand == src)
			if(istype(assailant,/mob/living/carbon/human))
				if(assailant.client.prefs.UI_type == "Retro")
					hud.screen_loc = "SOUTH,1"
				else
					hud.screen_loc = ui_rhand
			else if(istype(assailant,/mob/living/carbon/alien))
				hud.screen_loc = ui_id
			else
				hud.screen_loc = ui_rhand
		else
			if(istype(assailant,/mob/living/carbon/human))
				if(assailant.client.prefs.UI_type == "Retro")
					hud.screen_loc = "SOUTH,3"
				else
					hud.screen_loc = ui_lhand
			else if(istype(assailant,/mob/living/carbon/alien))
				hud.screen_loc = ui_belt
			else
				hud.screen_loc = ui_lhand
	process()


/obj/item/weapon/grab/process()
	confirm()

	if(assailant?.client)
		assailant.client.screen -= hud
		assailant.client.screen += hud

	if(assailant?.pulling == affecting)
		assailant?.stop_pulling()

	if(state <= GRAB_AGGRESSIVE)
		allow_upgrade = 0
		if((assailant?.l_hand && assailant?.l_hand != src && istype(assailant?.l_hand, /obj/item/weapon/grab)))
			var/obj/item/weapon/grab/G = assailant?.l_hand
			if(G.affecting != affecting)
				allow_upgrade = 0
		if((assailant?.r_hand && assailant?.r_hand != src && istype(assailant?.r_hand, /obj/item/weapon/grab)))
			var/obj/item/weapon/grab/G = assailant?.r_hand
			if(G.affecting != affecting)
				allow_upgrade = 0
		if(state == GRAB_AGGRESSIVE)
			var/h = affecting?.hand
			affecting?.hand = 0
			affecting?.hand = 1
			affecting?.hand = h
			for(var/obj/item/weapon/grab/G in affecting?.grabbed_by)
				if(G == src) continue
				if(G?.state == GRAB_AGGRESSIVE)
					allow_upgrade = 0
/*		if(allow_upgrade)
			hud.icon_state = "reinforce"
		else
			hud.icon_state = "!reinforce"*/
	else
		return


		//affecting.buckled = assailant
		//affecting.pixel_y = 19

/*
		affecting.Stun(5)	//It will hamper your voice, being choked and all.
		if(isliving(affecting))
			var/mob/living/L = affecting
			L.adjustOxyLoss(1)
*/
	/*if(state >= GRAB_KILL)
		affecting.Weaken(5)	//Should keep you down unless you get help.
		affecting.losebreath = min(affecting.losebreath + 2, 3)*/

/mob/living/carbon/human/attackby(obj/item/I, mob/user)
	if(!istype(I, /obj/item/weapon/grab))
		return ..()
	if(user != src)
		return ..()

	var/obj/item/weapon/grab/G = I
	var/mob/living/carbon/human/H = G.affecting

	if(!ishuman(G.affecting))
		return ..()
	if(G.aforgan.name != "head")
		return ..()
	if(G.assailant == H)
		return ..()

	var/damage = my_stats.st * 2.3
	H.apply_damage(damage, BRUTE, G.aforgan)
	apply_damage(damage / 2.5, BRUTE, get_organ("head"))
	visible_message("<span class='combatbold'>[G.assailant] headbutts [H.name]!</span>")
	var/list/headbuttEffects = list('sound/combat2020/headbutt.ogg', 'sound/combat2020/hard_fist.ogg')
	playsound(user.loc, pick(headbuttEffects), 100, 1, -1)
	G.dropped()
	qdel(G)

/obj/screen/grab/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/grab))
		if(!ishuman(user))
			return

		var/mob/living/carbon/human/attacker = user
		var/obj/item/weapon/grab/G = W
		var/obj/item/weapon/grab/GG = attacker.hand ? attacker.l_hand : attacker.r_hand

		if(G.aforgan.name != "head" && GG.aforgan.name != "head")
			return

		if(!ishuman(G.assailant) || !ishuman(G.affecting) || !ishuman(GG.assailant) || !ishuman(GG.affecting))
			return
		if(G.assailant == user || G.affecting == user || GG.assailant == user || GG.affecting == user)
			return

		var/mob/living/carbon/human/firstHeadbutter = G.affecting
		var/mob/living/carbon/human/secondHeadbutter = GG.affecting
		if(firstHeadbutter == secondHeadbutter)
			return
		var/damage = firstHeadbutter.my_stats.ht + secondHeadbutter.my_stats.ht + attacker.my_stats.st

		visible_message("<span class='combatbold'>[attacker.name] hits [firstHeadbutter.name]'s head with [secondHeadbutter.name]'s head!</span>")
		firstHeadbutter.apply_damage(damage, BRUTE, G.aforgan)
		secondHeadbutter.apply_damage(damage, BRUTE, GG.aforgan)
		if(prob(25))
			firstHeadbutter.CU()
			firstHeadbutter.ear_damage += rand(0, 3)
			firstHeadbutter.ear_deaf = max(firstHeadbutter.ear_deaf,6)
		attacker.adjustStaminaLoss(rand(8,13))

		var/list/headbuttEffects = list('sound/combat2020/headbutt.ogg', 'sound/combat2020/hard_fist.ogg')
		playsound(user, pick(headbuttEffects), 80, 1, -1)

/obj/item/weapon/grab/proc/s_click(obj/screen/S)
	if(!affecting)
		return
	if(state == GRAB_UPGRADING)
		return
	if(assailant.next_move > world.time)
		return
	if(world.time < (last_upgrade + UPGRADE_COOLDOWN))
		return
	if(iszombie(assailant)) return
	if(istype(assailant?:species, /datum/species/human/alien)) return
/*
	if(!assailant.canmove || assailant.lying)
		qdel(src)
		return
*/
	last_upgrade = world.time

	if(state < GRAB_AGGRESSIVE)
		if(!allow_upgrade)
			return
		assailant.visible_message("<span class='combatbold'>[assailant]</span> <span class='combat'>has grabbed</span> <span class='combatbold'>[affecting]</span> <span class='combat'>aggressively!</span>")
		state = GRAB_AGGRESSIVE
		icon_state = "grabbed1"
	else
		if(state < GRAB_NECK)
			assailant.visible_message("<span class='combatbold'>[assailant]</span> <span class='combat'>begins to put </span> <span class='combatbold'>[affecting]</span> <span class='combat'> on \his back!</span>")
			if(do_after(assailant, 30))
				state = GRAB_NECK
				if(!affecting.buckled)
					if(istype(assailant, /mob/living/carbon/human))
						var/mob/living/carbon/human/H = assailant
						H.buckle_mob(affecting)
						affecting.resting = 0
						affecting.update_canmove()

						affecting.plane = initial(affecting.plane)
						affecting.layer = 3.9
						affecting.pixel_y = 7
						switch(assailant.dir)
							if(NORTH)
								affecting.layer = 4.1
								affecting.pixel_x = 0
								affecting.pixel_y = 7
							if(EAST)
								affecting.layer = 3.9
								affecting.pixel_x = -5
								affecting.pixel_y = 7
							if(WEST)
								affecting.layer = 3.9
								affecting.pixel_x = 5
								affecting.pixel_y = 7
							if(SOUTH)
								affecting.layer = 3.9
								affecting.pixel_x = 0
								affecting.pixel_y = 7

				affecting.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their neck grabbed by [assailant.name] ([assailant.ckey])</font>"
				assailant.attack_log += "\[[time_stamp()]\] <font color='red'>Grabbed the neck of [affecting.name] ([affecting.ckey])</font>"
				log_attack("<font color='red'>[assailant.name] ([assailant.ckey]) grabbed the neck of [affecting.name] ([affecting.ckey])</font>")
				hud.icon_state = "reinforce2"
				hud.name = "piggyback"
		/*
		else
			if(state < GRAB_UPGRADING)
				assailant.visible_message("<span class='hitbold'>[assailant]</span> <span class='hit'>starts to tighten \his grip on</span> <span class='hitbold'>[affecting]'s</span> <span class='hit'>neck!</span>")
				hud.icon_state = "disarm/kill1"
				state = GRAB_UPGRADING
				if(do_after(assailant, UPGRADE_KILL_TIMER))
					if(state == GRAB_KILL)
						return
					if(!affecting)
						qdel(src)
						return
					if(!assailant.canmove || assailant.lying)
						qdel(src)
						return
					state = GRAB_KILL
					assailant.visible_message("<span class='danger'>[assailant] has tightened \his grip on [affecting]'s neck!</span>")
					affecting.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been strangled (kill intent) by [assailant.name] ([assailant.ckey])</font>"
					assailant.attack_log += "\[[time_stamp()]\] <font color='red'>Strangled (kill intent) [affecting.name] ([affecting.ckey])</font>"
					log_attack("<font color='red'>[assailant.name] ([assailant.ckey]) Strangled (kill intent) [affecting.name] ([affecting.ckey])</font>")

					assailant.next_move = world.time + 10
					affecting.losebreath += 1
				else
					assailant.visible_message("<span class='combatbold'>[assailant]</span> <span class='combat'>was unable to tighten \his grip on</span> <span class='combatbold'>[affecting]'s</span> <span class='combat'>neck!</span>")
					hud.icon_state = "disarm/kill"
					state = GRAB_NECK
		*/


//This is used to make sure the victim hasn't managed to yackety sax away before using the grab.
/obj/item/weapon/grab/proc/confirm()
	if(assailant == affecting)
		return 1

	if(!assailant || !affecting)
		qdel(src)
		return 0

	if(affecting)
		if(!isturf(assailant.loc) || ( !isturf(affecting.loc) || assailant.loc != affecting.loc && get_dist(assailant, affecting) > 1) )
			qdel(src)
			return 0

	return 1


/obj/item/weapon/grab/attack(mob/M, mob/user)
	if(!affecting)
		return

	if(M == affecting)
		s_click(hud)
		return
/*
	if(M == assailant && state >= GRAB_AGGRESSIVE)
		var/can_eat

		if((FAT in user.mutations) && ismonkey(affecting))
			can_eat = 1
		else
			var/mob/living/carbon/human/H = user
			if(istype(H) && iscarbon(affecting) && H.species.gluttonous)
				if(H.species.gluttonous == 2)
					can_eat = 2
				else if(!ishuman(affecting))
					can_eat = 1
		if(can_eat)
			var/mob/living/carbon/attacker = user
			user.visible_message("<span class='danger'>[user] is attempting to devour [affecting]!</span>")
			if(can_eat == 2)
				if(!do_mob(user, affecting)||!do_after(user, 30)) return
			else
				if(!do_mob(user, affecting)||!do_after(user, 100)) return
			user.visible_message("<span class='danger'>[user] devours [affecting]!</span>")
			affecting.loc = user
			//var/datum/organ/internal/stomach/Stomach = attacker.internal_organs_by_name[pick("stomach")]
			//Stomach.stomach_contents.Add(affecting)
			qdel(src)
*/

/obj/item/weapon/grab/dropped()
	qdel(src)

/obj/item/weapon/grab/Destroy()
	if(ishuman(assailant))
		var/mob/living/carbon/human/assailante = assailant
		assailant.client.screen -= hud
		if(assailante.buckled_mob)
			var/mob/living/carbon/human/affectano = affecting
			assailante.unbuckle_someone(affectano)
	if(ishuman(affecting))
		var/mob/living/carbon/human/affectante = affecting
		for(var/x = 1; x <= affectante.grabbed_by.len; x++)
			if(affectante.grabbed_by[x])
				if(istype(affectante.grabbed_by[x], /obj/item/weapon/grab))
					var/obj/item/weapon/grab/G = affectante.grabbed_by[x]
					if(G.assailant == assailant)
						affectante.grabbed_by[x] = null

	affecting = null
	aforgan = null
	assailant = null
	contents = null
	hud.master = null
	qdel(hud)
	qdel(reagents)
	return ..()

/mob/living/carbon/human/proc/wrenchTry(mob/living/carbon/human/atacante, mob/living/carbon/human/defensor)

	if(!ishuman(atacante)) return

	var/modifier = 10

	if(atacante.combat_mode)
		modifier += 15
	else
		modifier -= 10

	if(atacante.lying && !defensor.lying)
		modifier -= 20

	if(!atacante.lying && defensor.lying)
		modifier += 20

	if(atacante.isChild() && !(defensor.isChild()))
		modifier -= 20

	if(defensor.isChild())
		modifier += 15
	if(FAT in defensor.mutations)
		modifier -= 15

	if(!defensor.combat_mode)
		modifier += 38

	var/diff = atacante.my_stats.st - defensor.my_stats.ht

	if(diff < 0)
		var/parsedDiff = diff * -1
		for(var/x = 0; x < parsedDiff; x++)
			modifier += rand(10, 13)
	if(diff > 0)
		for(var/x = 0; x < diff; x++)
			modifier -= rand(-10, -13)

	if(modifier <= 0)
		modifier = 15
	if(modifier >= 90)
		modifier = 90

	if(prob(modifier))
		return 1
	return 0


/mob/living/carbon/human/Life()
	..()

	if(species?.name == "Human" || isChild(src) && !mind?.changeling){
		if(neckXommed){
			return
		}
		var/datum/organ/external/head/H = get_organ("head")

		if(H.headwrenched){
			death_door()
		}
	}
