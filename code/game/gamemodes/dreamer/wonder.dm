var/global/list/SeenWonder = list()
/obj/structure/wonder
	name = "Wicked Creation"
	desc = "Who could have done something like this?!!?"
	icon = 'icons/life/creations.dmi'
	icon_state = "creation1"
	var/key
	var/heart_key
	density = TRUE
	anchored = TRUE

/obj/structure/wonder/New()
	. = ..()
	processing_objects.Add(src)

/obj/structure/wonder/first

/obj/structure/wonder/second
	icon_state = "creation2"

/obj/structure/wonder/third
	icon_state = "creation3"

/obj/structure/wonder/fourth
	icon_state = "creation4"

/obj/structure/wonder/examine()
	..()
	if(!is_dreamer(usr))
		usr << 'sound/lfwbsounds/seen_wonder.ogg'
		to_chat(usr, "<span class='passiveglow'><big>Who could have done something like this?!!?</big></b>")
/obj/structure/wonder/process()
	for(var/mob/living/carbon/human/H in view(src, world.view))
		if(ismonster(H)) continue
		if(H.stat == DEAD) continue
		if(istype(H, /mob/living/carbon/human/bumbot)) continue
		if(!is_dreamer(H) && !H.seen_key || !is_dreamer(H) && !H.seen_heart_key)
			H.seen_key = key
			H.seen_heart_key = heart_key
			var/datum/organ/internal/heart/Heart = locate() in H.internal_organs
			Heart.escritura = key
			H << 'sound/lfwbsounds/seen_wonder.ogg'
			H.rotate_plane()
			H.emote("scream")
			H.add_event("wonder", /datum/happiness_event/wonder)
			SeenWonder.Add(H)

/obj/structure/wonder/attack_hand(mob/user)
	visible_message("<span class='passivebold'>[user]</span> <span class='passive'>starts dismantling the Wicked Creation!</span>")
	if(do_after(user, 50))
		PoolOrNew(/obj/effect/decal/cleanable/blood/gibs/normal, src)
		qdel(src)