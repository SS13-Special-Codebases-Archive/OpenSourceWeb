
/obj/item/weapon/gun
	name = "gun"
	desc = "Its a gun. It's pretty terrible, though."
	icon = 'icons/obj/gun.dmi'
	icon_state = "detective"
	item_state = "gun"
	var/caliber = ""
	flags = FPRINT | TABLEPASS | CONDUCT | USEDELAY
	slot_flags = SLOT_BELT
	m_amt = 2000
	w_class = 3
	var/is_exploding = 0
	var/explode_chance = 0
	var/is_malfunction = 0
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5.0
	origin_tech = "combat=1"
	attack_verb = list("struck", "hit", "bashed")
	drawsound = 'sound/effects/unholster.ogg'

	var/light_ra = 2 //RANGE DA LUZ DO TIRO
	var/light_pw = 14  //FORCA DA LUZ DO TIRE
	var/light_color_b = "#e0dcd1"//COR DA LUZ DO TIRO

	var/misfire_chance
	var/fire_sound = 'sound/weapons/Gunshot.ogg'
	var/reload_sound = 'sound/items/webbers/reload.ogg'
	var/unload_sound = 'sound/webbers/weapons/unload.ogg'
	var/jam_sound = 'sound/webbers/weapons/jam.ogg'
	var/unjam_sound = 'sound/webbers/weapons/unjam.ogg'
	var/jam_chance = 2
	var/is_jammed = 0
	var/obj/item/projectile/in_chamber = null
	var/silenced = 0
	var/recoil = 0.5
	var/ejectshell = 1
	var/loud = FALSE //PARA ARMAS QUE FODEM OS OUVIDOS.
	var/clumsy_check = 1
	var/tmp/list/mob/living/target //List of who yer targeting.
	var/tmp/lock_time = -100
	var/tmp/mouthshoot = 0 ///To stop people from suiciding twice... >.>
	var/automatic = 0 //Used to determine if you can target multiple people.
	var/tmp/mob/living/last_moved_mob //Used to fire faster at more than one person.
	var/tmp/told_cant_shoot = 0 //So that it doesn't spam them with the fact they cannot hit them.
	var/firerate = 1 	// 0 for one bullet after tarrget moves and aim is lowered,
						//1 for keep shooting until aim is lowered
	var/fire_delay = 3
	var/safety = TRUE
	var/last_fired = 0
	var/has_safety = 1
	var/emptysound = 'sound/weapons/empty.ogg'
	var/safetysound = 'sound/items/safety.ogg'
	var/cocksound = 'sound/lfwbsounds/smallpistolcock.ogg'
	var/should_sound = 1
	var/recoil_type = 1
	var/no_trigger_guard = FALSE // Can fire with gloves that block firing.

	proc/ready_to_fire()
		if(world.time >= last_fired + fire_delay)
			last_fired = world.time
			return 1
		else
			return 0

	proc/process_chambered()
		return 0

	proc/special_check(var/mob/M) //Placeholder for any special checks, like detective's revolver.
		return 1

	proc/aim_at(mob/living/carbon/human/H)
		if(!istype(H, /mob/living/carbon/human))
			return
		H.beingaimedby = src
		H.add_aim()
		if(H.combat_mode)
			H.rotate_plane()

	emp_act(severity)
		for(var/obj/O in contents)
			O.emp_act(severity)

/obj/item/weapon/gun/afterattack(atom/A as mob|obj|turf|area, mob/living/user as mob|obj, flag, params)
	if(flag)	return //we're placing gun on a table or in backpack
	if(istype(target, /obj/machinery/recharger) && istype(src, /obj/item/weapon/gun/energy))	return//Shouldnt flag take care of this?
//	if(user && user.client && user.client.gun_mode && !(A in target))
//		PreFire(A,user,params) //They're using the new gun system, locate what they're aiming at.
//	else
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.hasActiveShield(1))
			user.visible_message("<span class='hitbold'>[user]'s [src] projectile</span> <span class='hit'>is deflected by \his own energy shield!</span>")
			playsound(H.loc, 'sound/effects/energyparrylas.ogg', 100, 1)
			Fire(user,user,params)
			return
		if(H?:loc?:liquid?:depth >= 145 || H?.resting && H?:loc?:liquid?:depth >= 85)
			to_chat(user, "<span class='malfunction'>Misfire!</span>")
			src.is_jammed = 1
			user.visible_message("<span class='hitbold'>[user]</span> <span class='hit'>tries to shoot at</span> <span class='hitbold'>[target]</span><span class='hit'>, but</span> <span class='hitbold'>[src]</span> <span class='hit'>just makes a click.</span>")
			playsound(user, jam_sound, 100, 1)
			if(istype(src, /obj/item/weapon/gun/energy/taser/leet))
				to_chat(user, "<span class='malfunction'>OH [uppertext(H.god_text())] OH FUCK!!</span>")
				explosion(src.loc,0,3,5,7,10)
			return
		else
			Fire(A,user,params)
	else
		Fire(A,user,params) //Otherwise, fire normally.

/obj/item/weapon/gun/proc/isHandgun()
	return 1
//SAFETY DO IS12
/obj/item/weapon/gun/RightClick(mob/user)

	if(user.get_active_hand() == null || istype(user.get_active_hand(), /obj/item/weapon/gun/))

		if(usr.next_move >= world.time)
			return

		if(usr.stat == 1)
			return

		if(usr.restrained())
			return

		user.next_move = world.time + 6

		toggle_safety(user)
		if(istype(src, /obj/item/weapon/gun/projectile/revolver))
			var/obj/item/weapon/gun/projectile/revolver/R = src
			R.spin()

/obj/item/weapon/gun/proc/toggle_safety(mob/user)
	if(src != user.get_active_hand())
		return

	if(!src.has_safety)
		return

	else
		safety = !safety
		playsound(user, safetysound, 50, 1)
		update_icon()
		to_chat(user, "I toggle the safety [safety ? "on":"off"].")

/obj/item/weapon/gun/proc/ShootSelf(var/mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.apply_damage(rand(70,90), BURN, "r_hand")
		if(wielded)
			H.apply_damage(rand(70,90), BURN, "l_hand")
			H.apply_damage(rand(70,90), BURN, "r_hand")
			return
	return

/obj/item/weapon/gun/proc/Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, pointblank=0, reflex = 0)//TODO: go over this
	//Exclude lasertag guns from the CLUMSY check.
	var/mob/living/carbon/human/HHC = user
	if(HHC.consyte == TRUE)
		HHC.vomit()
		return
	if(HHC.gloves)
		var/obj/item/clothing/gloves/G = HHC.gloves
		if(!no_trigger_guard && G.blocks_firing)
			to_chat(user,"<span class='combatbold'><span class='combat'>[pick(nao_consigoen)]</span> I can't pull the trigger in these gloves!</span>")
			return
	if(safety)
		click_empty(user, target)
		return 0
	if(is_malfunction)
		return 0
	var/list/new3d6Roll = roll3d6(HHC,SKILL_RANGE,null)
	switch(new3d6Roll[GP_RESULT])
		if(GP_CRITFAIL)
			if(istype(src, /obj/item/weapon/gun/energy))
				if (!is_malfunction && prob(explode_chance))
					is_malfunction = 1
					to_chat(usr, "<span class='malfunction'>Malfunction!</span>")
					playsound(src.loc, 'sound/weapons/sparqmalfunction.ogg', 100, 1)
					spawn(80)
						is_malfunction = 0
					return 0
			if(!is_jammed && prob(jam_chance))
				if (user)
					to_chat(user, "<span class='malfunction'>Misfire!</span>")
					user.visible_message("<span class='hitbold'>[user]</span> <span class='hit'>tries to shoot at</span> <span class='hitbold'>[target]</span><span class='hit'>, but</span> <span class='hitbold'>[src]</span> <span class='hit'>just makes a click.</span>")
					playsound(user, jam_sound, 100, 1)
				else
					src.visible_message("<span class='hitbold'>[src]</span> <span class='hit'>just makes a click.</span>")
					playsound(src.loc, jam_sound, 100, 1)
				is_jammed = 1
				return 0
		if(GP_FAILED)
			if(istype(src, /obj/item/weapon/gun/energy))
				if (!is_malfunction && prob(explode_chance))
					is_malfunction = 1
					to_chat(usr, "<span class='malfunction'>Malfunction!</span>")
					playsound(src.loc, 'sound/weapons/sparqmalfunction.ogg', 100, 1)
					spawn(80)
						is_malfunction = 0
					return 0
			if(!is_jammed && prob(jam_chance))
				if (user)
					to_chat(user, "<span class='malfunction'>Misfire!</span>")
					user.visible_message("<span class='hitbold'>[user]</span> <span class='hit'>tries to shoot at</span> <span class='hitbold'>[target]</span><span class='hit'>, but</span> <span class='hitbold'>[src]</span> <span class='hit'>just makes a click.</span>")
					playsound(user, jam_sound, 100, 1)
				else
					src.visible_message("<span class='hitbold'>[src]</span> <span class='hit'>just makes a click.</span>")
					playsound(src.loc, jam_sound, 100, 1)
				is_jammed = 1
				return 0

	if(is_jammed)
		click_empty(user, target)
		return 0

	if (!user.IsAdvancedToolUser())
		user << "\red You don't have the dexterity to do this!"
		return

	add_fingerprint(user)

	var/turf/curloc = get_turf(user)
	var/turf/targloc = get_turf(target)
	if (!istype(targloc) || !istype(curloc))
		return

	if(!special_check(user))
		return

	if (!ready_to_fire() && !istype(src, /obj/item/weapon/gun/projectile/automatic) && !istype(src, /obj/item/weapon/gun/energy/taser/MERCY))
		if (world.time % 3) //to prevent spam
			to_chat(user, "<span class='bname'>[src] is not ready to fire again!</span>")
		return

	if(!process_chambered() && !pointblank) //Ta, isso aqui checa se tem bala na camara da arma e tem o bagulho do pointblank, se for pointblank n precisa checar pq o proprio pointblank ja faz isso
		return click_empty(user, target)

	if(!in_chamber)
		return

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.job == "Francisco's Advisor") // He is the protagonist from the show, you can't just kill him! (INCREDIBLE PLOTARMOR)
			if(prob(95))
				src.visible_message("<span class='hitbold'>[src]</span> <span class='hit'>just makes a click.</span>")
				playsound(src.loc, jam_sound, 100, 1)
				is_jammed = 1

	in_chamber.firer = user
	in_chamber.def_zone = user.zone_sel.selecting
	if(targloc == curloc)
		user.bullet_act(in_chamber)
		qdel(in_chamber)
		update_icon()
		return
	var/mob/living/carbon/human/H = user
	if(recoil)
		spawn()
			if(H.my_skills.GET_SKILL(SKILL_RANGE) <= 3)
				shake_camera(H, recoil + 1, recoil)
				if(prob(50))
					H.blur(1, 6)
					H.CU()
			else
				if(recoil_type == 1 && should_sound)
					recoil_two(H)
				else
					if(recoil_type == 2 && should_sound)
						recoil_two(H)

	spawn(0)
		set_light(light_ra, light_pw, light_color_b)

		spawn(3)
			set_light(0)

	if(silenced)
		playsound(user, fire_sound, 10, 1)
	else
		if(should_sound)
			playsound(user, fire_sound, 1000, 1)

			if(istype(target, /mob))
				user.visible_message("<span class='hitbold'>[user] shoots at [target] with [src][reflex ? " by reflex":""]!</span>")
			else
				user.visible_message("<span class='hitbold'>[user] shoots at [target] with [src][reflex ? " by reflex":""]!</span>")

	if(!wielded && weight >= 6 && prob(75))
		user.drop_from_inventory(src)
	in_chamber.original = target
	in_chamber.loc = get_turf(user)
	in_chamber.starting = get_turf(user)
	in_chamber.shot_from = src
	user.next_move = world.time + 4
	in_chamber.silenced = silenced
	in_chamber.current = curloc
	in_chamber.yo = targloc.y - curloc.y
	in_chamber.xo = targloc.x - curloc.x
	if(params)
		var/list/mouse_control = params2list(params)
		if(mouse_control["icon-x"])
			in_chamber.p_x = text2num(mouse_control["icon-x"])
		if(mouse_control["icon-y"])
			in_chamber.p_y = text2num(mouse_control["icon-y"])

	spawn()
		if(in_chamber)
			in_chamber.process()
	sleep(1)
	in_chamber = null

	update_icon()

	user.sound2()

	if(user.hand)
		user.update_inv_l_hand()
	else
		user.update_inv_r_hand()

	user.newtonian_move(get_dir(target, user))

/obj/item/weapon/gun/proc/can_fire()
	return process_chambered()

/obj/item/weapon/gun/examine(mob/user)
	. = ..()
	if(safety)
		to_chat(user, "<span class='jogtowalk'>The safety is on.</span>")
	else
		to_chat(user, "<span class='jogtowalk'>The safety is off.</span>")

/obj/item/weapon/gun/proc/can_hit(var/mob/living/target as mob, var/mob/living/user as mob)
	return in_chamber.check_fire(target,user)

/obj/item/weapon/gun/proc/click_empty(mob/user = null, target)
	if (user && should_sound)
		if(is_jammed)
			user.visible_message("<span class='hitbold'>[user]</span> <span class='hit'>tries to shoot at</span> <span class='hitbold'>[target]</span><span class='hit'>, but</span> <span class='hitbold'>[src]</span> <span class='hit'>just makes a click.</span>")
			playsound(src, jam_sound, 100, 1)
		else
			user.visible_message("<span class='hitbold'>[user]</span> <span class='hit'>tries to shoot at</span> <span class='hitbold'>[target]</span><span class='hit'>, but</span> <span class='hitbold'>[src]</span> <span class='hit'>just makes a click.</span>")
			playsound(src, emptysound, 100, 1)
	else
		src.visible_message("<span class='hitbold'>[src]</span> <span class='hit'>just makes a click.</span>")
		playsound(src.loc, emptysound, 100, 1)

/obj/item/weapon/gun/attack(atom/A, mob/living/user, def_zone)
	if (process_chambered())
		//Point blank shooting if on harm intent or target we were targeting.
		if(user.a_intent == "hurt")
			if(in_chamber)
				in_chamber.damage *= 2.90

			if(Fire(A, user, 0, 1))
				user.visible_message("<span class='hitbold'>\The [user]</span> <span class='hit'>fires \the</span> <span class='hitbold'>[src]</span> <span class='hit'>point blank at</span> <span class='hitbold'>[A]</span><span class='hit'>!</span>")
			return
		else
			return ..()
	else
		return ..() //Pistolwhippin'

/obj/item/weapon/gun/proc/unjam(var/mob/M)
	if(is_jammed)
		M.visible_message("<span class='hitbold'>[M.name]</span> <span class='hit'>is trying to unjam</span> <span class='hitbold'>[src]!</span>")
		if(do_after(M, 15))
			is_jammed = 0
			playsound(src.loc, unjam_sound, 50, 1)
			return
		else
			return

/obj/item/weapon/gun/proc/check_gun_safety(mob/user)//Used in inventory.dm to see whether or not you fucking shoot someone when you drop your gun on the ground.
	if(!safety && prob(10))
		user.visible_message("<span class='hitbold'>[src] goes off!</span>")
		var/list/targets = list(user)
		targets += range(2, src)
		afterattack(pick(targets), user)