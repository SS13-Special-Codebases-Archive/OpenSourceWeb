/obj/item/mob_holder
	name = ""
	desc = ""
	icon = null
	icon_state = ""
	var/mob/living/held_mob

/obj/item/mob_holder/New(var/mob/living/M,var/mob/living/carbon/human/H)
	. = ..()
	M.loc = H
	deposit(M)

/obj/item/mob_holder/proc/deposit(mob/living/M)
	M.dir = SOUTH
	update_visuals(M)
	held_mob = M
	name = M.name
	desc = M.desc
	src.contents |= M
	return TRUE

/obj/item/mob_holder/proc/update_visuals(mob/living/L)
	appearance = L.appearance

/obj/item/mob_holder/Destroy()
	if(held_mob)
		release(FALSE)
	return ..()

/obj/item/mob_holder/proc/release()
	if(!held_mob)
		QDEL_NULL(src)
		return FALSE
	if(isliving(loc))
		var/mob/living/L = loc
		to_chat(L, "<span class='combat'>[pick(nao_consigoen)] \the [held_mob] has escaped my grasp!</span>")
		L.drop_from_inventory(src)
	held_mob.forceMove(get_turf(src))
	held_mob.dir = SOUTH
	src.contents -= held_mob
	held_mob = null
	QDEL_NULL(src)
	return TRUE

/obj/item/mob_holder/relaymove()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(prob(40) || !H.combat_mode)
			release()
	else
		release()

/obj/item/mob_holder/dropped(mob/user)
	..()
	release()

/obj/item/mob_holder/proc/show_message(var/message, var/m_type)
	held_mob.show_message(message,m_type)



