/* Beds... get your mind out of the gutter, they're for sleeping!
 * Contains:
 * 		Beds
 *		Roller beds
 */

/*
 * Beds
 */
/obj/structure/stool/bed
	name = "bed"
	desc = "This is used to lie in, sleep in or strap on."
	icon_state = "bed"
	var/mob/living/buckled_mob
	flammable = 1
	can_leave = TRUE

/obj/structure/stool/bed/brothel
	icon_state = "brobed"

/obj/structure/stool/bed/cerb1
	icon_state = "cerb1"

/obj/structure/stool/bed/cerb0
	icon_state = "cerb0"

/obj/structure/stool/bed/redebahia
	icon_state = "redebahia"

/obj/structure/stool/bed/pigbed
	icon_state = "pigbed"

/obj/structure/stool/bed/heirbed
	icon_state = "heirbed"

/obj/structure/stool/bed/migbed
	icon_state = "migbed"

/obj/structure/stool/bed/bedcons
	icon_state = "bedcons"

/obj/structure/stool/bed/couple1
	icon = 'bigbed.dmi'
	icon_state = "bed"

/obj/structure/stool/bed/couple2
	icon = 'bigbed.dmi'
	icon_state = "bed2"
	pixel_y = -13

/obj/structure/stool/bed/couple2/manual_unbuckle(mob/user as mob)
	..()
	buckled_mob.pixel_y = 0
	buckled_mob.old_y = 0
	return

/obj/structure/stool/bed/couple2/buckle_mob(mob/M as mob, mob/user as mob)
	..()
	buckled_mob.pixel_y = -13
	buckled_mob.old_y = -13
	return

/obj/structure/stool/bed/psych
	name = "psych bed"
	desc = "For prime comfort during psychiatric evaluations."
	icon_state = "psychbed"

/obj/structure/stool/bed/alien
	name = "resting contraption"
	desc = "This looks similar to contraptions from earth. Could aliens be stealing our technology?"
	icon_state = "abed"

/obj/structure/stool/bed/Destroy()
	unbuckle()
	..()
	return

/obj/structure/stool/bed/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/stool/bed/attack_hand(mob/user as mob)
	manual_unbuckle(user)
	return

/obj/structure/stool/bed/MouseDrop(atom/over_object)
	return

/obj/structure/stool/bed/MouseDrop_T(mob/M as mob, mob/user as mob)
	if(!istype(M)) return
	buckle_mob(M, user)
	return

/obj/structure/stool/bed/proc/unbuckle()
	if(buckled_mob)
		if(buckled_mob.buckled == src)	//this is probably unneccesary, but it doesn't hurt
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.update_canmove()
			buckled_mob = null
	return

/obj/structure/stool/bed/proc/manual_unbuckle(mob/user as mob)
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			if(buckled_mob != user)
				buckled_mob.visible_message(\
					"<span class='passivebold'>[buckled_mob.name]</span> <span class='passive'>was unbuckled by</span> <span class='passivebold'>[user.name]</span><span class='passive'>!</span>",\
					"<span class='passive'>You were unbuckled from [src] by</span> <span class='passivebold'>[user.name]</span><span class='passive'>.</span>",\
					"<span class='passive'>You hear metal clanking</span>")
			else
				if(ishuman(buckled_mob))
					var/mob/living/carbon/human/H = buckled_mob
					if(H.handcuffed)
						return
				buckled_mob.visible_message(\
					"<span class='passivebold'>[buckled_mob.name]</span> <span class='passive'>unbuckled \himself!</span>",\
					"<span class='passive'>You unbuckle yourself from [src].</span>",\
					"<span class='passive'>You hear metal clanking</span>")
			unbuckle()
			src.add_fingerprint(user)
	return

/obj/structure/stool/bed/proc/buckle_mob(mob/M as mob, mob/user as mob)
	if (!ticker)
		user << "You can't buckle anyone in before the game starts."
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || user.stat || M.buckled || istype(user, /mob/living/silicon/pai) )
		return

	unbuckle()

	if (M == usr)
		M.visible_message(\
			"<span class='passivebold'>[M.name]</span> <span class='passive'>buckles in!</span>",\
			"<span class='passive'>You buckle yourself to [src].</span>",\
			"<span class='passive'>You hear metal clanking</span>")
	else
		M.visible_message(\
			"<span class='passivebold'>[M.name]</span> <span class='passive'>is buckled in to [src] by</span> <span class='passivebold'>[user.name]</span><span class='passive'>!</span>",\
			"<span class='passivebold'>You are buckled in to [src] by</span> <span class='passivebold'>[user.name]</span><span class='passive'>.</span>",\
			"<span class='passive'>You hear metal clanking</span>")
	M.buckled = src
	M.loc = src.loc
	M.dir = src.dir
	M.update_canmove()
	src.buckled_mob = M
	src.add_fingerprint(user)
	return

/*
 * Roller beds
 */
/obj/structure/stool/bed/roller
	name = "roller bed"
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "down"
	anchored = 0

/obj/item/roller
	name = "roller bed"
	desc = "A collapsed roller bed that can be carried around."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded"
	w_class = 4.0 // Can't be put in backpacks. Oh well.

	attack_self(mob/user)
		var/obj/structure/stool/bed/roller/R = new /obj/structure/stool/bed/roller(user.loc)
		R.add_fingerprint(user)
		qdel(src)

/obj/structure/stool/bed/roller/Move()
	..()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.loc = src.loc
		else
			buckled_mob = null
	playsound(src.loc, 'rollermove.ogg', 50, 1)

/obj/structure/stool/bed/roller/buckle_mob(mob/M as mob, mob/user as mob)
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || user.stat || M.buckled || istype(usr, /mob/living/silicon/pai) )
		return
//	M.pixel_y = 6
	density = 1
	icon_state = "up"
	..()
	return

/obj/structure/stool/bed/roller/manual_unbuckle(mob/user as mob)
	if(buckled_mob)
		if(buckled_mob.buckled == src)	//this is probably unneccesary, but it doesn't hurt
//			buckled_mob.pixel_y = 0
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.buckled = null
			buckled_mob.update_canmove()
			buckled_mob = null
	density = 0
	icon_state = "down"
	..()
	return

/obj/structure/stool/bed/roller/MouseDrop(over_object, src_location, over_location)
	..()
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))	return
		if(buckled_mob)	return 0
		visible_message("[usr] collapses \the [src.name]")
		new/obj/item/roller(get_turf(src))
		spawn(0)
			qdel(src)
		return
