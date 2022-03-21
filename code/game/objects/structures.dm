obj/structure
	icon = 'icons/obj/structures.dmi'
	var/breakable
	var/parts
	var/list/drops = list(/obj/item/weapon/stone, /obj/item/weapon/stone)
	var/list/break_sounds = list('npc_human_pickaxe_01.ogg','npc_human_pickaxe_02.ogg','npc_human_pickaxe_03.ogg','npc_human_pickaxe_05.ogg')

	var/hitstake = 0
	var/hits = 10

obj/structure/blob_act()
	if(prob(50))
		qdel(src)

obj/structure/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			return
/obj/structure/attackby(obj/item/weapon/W as obj, mob/living/carbon/human/user as mob)
	if(user.a_intent != "hurt" || !breakable)
		return ..()
	if(!istype(W) || !ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	var/mod_hit = 0
	H.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(W.wielded) mod_hit += 1
	switch(W.speciality)
		if(SKILL_KNIFE)
			mod_hit -= 5
		if(SKILL_SWING)
			mod_hit += 3
		if(SKILL_SWORD)
			mod_hit += 1
		if(SKILL_UNARM)
			mod_hit -= 2
		if(SKILL_STAFF)
			mod_hit += 2
	var/list/roll_result = roll3d6(H, H.my_stats.st, mod_hit, FALSE, TRUE)
	switch(roll_result[GP_RESULT])
		if(GP_CRITSUCCESS)
			H.visible_message("<span class='passivebold'>[H] hits [src] with [W]</span>")
			hitstake += 2
			W.damageItem("SOFT")
		if(GP_SUCCESS)
			H.visible_message("<span class='passive'>[H] hits [src] with [W]</span>")
			hitstake += 1
			W.damageItem("SOFT")
		if(GP_FAILED)
			H.visible_message("<span class='combat'>[H] hits [src] with [W]</span>")
			W.damageItem("SOFT")
		if(GP_CRITFAIL)
			H.visible_message("<span class='combatbold'>[H] hits [src] with [W]</span>")
			W.damageItem("MEDIUM")
	playsound(loc, pick(break_sounds), 80, 1)
	update_hits()

/obj/structure/proc/update_hits()
	if(hitstake >= hits)
		destroy()

/obj/structure/proc/destroy()
	if(parts)
		new parts(loc)
	if(length(drops))
		for(var/D in drops)
			new D(src.loc)
	density = 0
	qdel(src)

/obj/structure/attack_hand(mob/user)
	if(breakable)
		if(HULK in user.mutations)
			user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
			visible_message("<span class='danger'>[user] smashes the [src] apart!</span>")
			destroy()
		else if(istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(user))
				visible_message("<span class='danger'>[H] slices [src] apart!</span>")
				destroy()

/obj/structure/attack_animal(mob/living/user)
	if(breakable)
		if(user.wall_smash)
			visible_message("<span class='danger'>[user] smashes [src] apart!</span>")
			destroy()

/obj/structure/attack_paw(mob/user)
	if(breakable) attack_hand(user)

obj/structure/meteorhit(obj/O as obj)
	qdel(src)







