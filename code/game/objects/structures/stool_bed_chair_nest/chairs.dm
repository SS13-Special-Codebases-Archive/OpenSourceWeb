/obj/structure/stool/bed/chair	//YES, chairs are a type of bed, which are a type of stool. This works, believe me.	-Pete
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon_state = "chair"
	can_leave = FALSE

/obj/structure/stool/MouseDrop(atom/over_object)
	return

/obj/structure/stool/bed/chair/New()
	if(anchored)
		src.verbs -= /atom/movable/verb/pull
	..()
	spawn(3)	//sorry. i don't think there's a better way to do this.
		handle_rotation()
	return

/obj/structure/stool/bed/chair/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/assembly/shock_kit))
		var/obj/item/assembly/shock_kit/SK = W
		if(!SK.status)
			user << "<span class='notice'>[SK] is not ready to be attached!</span>"
			return
		user.drop_item()
		var/obj/structure/stool/bed/chair/e_chair/E = new /obj/structure/stool/bed/chair/e_chair(src.loc)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		E.dir = dir
		E.part = SK
		SK.loc = E
		SK.master = E
		qdel(src)

/obj/structure/stool/bed/chair/attack_tk(mob/user as mob)
	if(buckled_mob)
		..()
	else
		rotate()
	return

/obj/structure/stool/bed/chair/proc/handle_rotation()	//making this into a seperate proc so office chairs can call it on Move()
	if(src.dir == NORTH)
		src.layer = FLY_LAYER
	else
		src.layer = OBJ_LAYER
	if(buckled_mob)
		buckled_mob.dir = dir

/obj/structure/stool/bed/chair/verb/rotate()
	set name = "Rotate Chair"
	set category = "Object"
	set src in oview(1)

	if(config.ghost_interaction)
		src.dir = turn(src.dir, 90)
		handle_rotation()
		return
	else
		if(istype(usr,/mob/living/simple_animal/mouse))
			return
		if(!usr || !isturf(usr.loc))
			return
		if(usr.stat || usr.restrained())
			return

		src.dir = turn(src.dir, 90)
		handle_rotation()
		return

/obj/structure/stool/bed/chair/MouseDrop_T(mob/M as mob, mob/user as mob)
	if(!istype(M)) return
	buckle_mob(M, user)
	return

// Chair types
/obj/structure/stool/bed/chair/wood/normal
	icon_state = "wooden_chair"
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."

/obj/structure/stool/bed/chair/wood/wings
	icon_state = "wooden_chair_wings"
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."

/obj/structure/stool/bed/chair/wood/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		new /obj/item/stack/sheet/wood(src.loc)
		qdel(src)
	else
		..()

/obj/structure/stool/bed/chair/goon
	icon_state = "g-chair"

/obj/structure/stool/bed/chair/New()
	if(src.dir == NORTH)
		plane = 15//Statues plane, blocks characters

/obj/structure/stool/bed/chair/comfy
	name = "comfy chair"
	desc = "It looks comfy."
	density = 1
	var/falls = 0 //se cai ou nao
	var/fallen = 0 //caiu no chao

/obj/structure/stool/bed/chair/comfy/proc/fall(atom/movable/mover)
	if(ishuman(mover))
		var/matrix/M = matrix()
		M.Turn(90)
		M.Translate(0, -6)
		src.transform = M
		density = 0
		playsound(src, 'sound/misc/chairfall.ogg', 100, 1)
		fallen = 1

/obj/structure/stool/bed/chair/comfy/buckle_mob()
	if(fallen)
		return 0
	..()

/obj/structure/stool/bed/chair/comfy/attack_hand()
	..()
	if(fallen)
		src.transform = initial(src.transform)
		density = 1
		fallen = 0

/obj/structure/stool/bed/chair/comfy/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover,/obj/item))
		return 1
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	if(get_dir(loc, target) == turn(dir, 180)) //Make sure looking at appropriate border
		if(!fallen && falls)
			fall(mover)
			return 0
		if(air_group) return 0
		return !density
	else
		return 1

/obj/structure/stool/bed/chair/comfy/CheckExit(atom/movable/mover as mob|obj, turf/target as turf)
	if(istype(mover,/obj/item))
		return 1
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	if(get_dir(loc, target) == turn(dir, 180))
		if(!fallen && falls)
			fall(mover)
			return 0
		return !density
	else
		return 1

/obj/structure/stool/bed/chair/comfy/judge
	name = "judge chair"
	desc = "It looks comfy."
	icon_state = "judge"

/obj/structure/stool/bed/chair/jail
	name = "jail cell"
	icon_state = "comfychair_brown"

/obj/structure/stool/bed/chair/breaker
	name = "slave chair"
	icon_state = "breaker"

/obj/structure/stool/bed/chair/comfy/judge/buckle_mob(mob/M as mob, mob/user as mob)
	if (!ticker)
		user << "You can't buckle anyone in before the game starts."
	if (fallen)
		return
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || user.lying || user.stat || M.buckled || istype(user, /mob/living/silicon/pai) )
		return

	unbuckle()

	if (M == usr)
		M.visible_message("<span class='passivebold'>[M.name]</span> <span class='passive'>sits majestically on [src]!</span>")
	else
		M.visible_message("<span class='passivebold'>[M.name]</span> <span class='passive'>sits majestically on [src]!</span>")
	M.buckled = src
	M.loc = src.loc
	M.dir = src.dir
	M.update_canmove()
	src.buckled_mob = M
	src.add_fingerprint(user)
	var/mob/living/carbon/human/H = usr
	if(H.job == "Patriarch")
		H.verbs += /mob/living/carbon/human/proc/execution
		H.verbs += /mob/living/carbon/human/proc/great_hunt
		H.verbs += /mob/living/carbon/human/proc/duel

/obj/structure/stool/bed/chair/comfy/judge/unbuckle(mob/M as mob, mob/user as mob)
	if(buckled_mob)
		if(buckled_mob.buckled == src)	//this is probably unneccesary, but it doesn't hurt
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.update_canmove()
			buckled_mob = null
	var/mob/living/carbon/human/H = usr
	if(H.job == "Patriarch")
		H.verbs -= /mob/living/carbon/human/proc/execution
		H.verbs -= /mob/living/carbon/human/proc/great_hunt
		H.verbs -= /mob/living/carbon/human/proc/duel

/obj/structure/stool/bed/chair/comfy/brown
	icon_state = "comfychair_brown"

/obj/structure/stool/bed/chair/comfy/brown/RightClick(mob/living/M as mob)
	rotate()

/obj/structure/stool/bed/chair/comfy/babylon
	icon_state = "babylonchair"
	var/locked = FALSE

/obj/structure/stool/bed/chair/comfy/babylon/unbuckle()
	if(!locked)
		..()
	else
		return

/obj/structure/stool/bed/chair/comfy/babylon/manual_unbuckle()
	if(!locked)
		..()
	else
		return

/obj/structure/stool/bed/chair/comfy/babylon/RightClick(mob/living/M as mob)
	if(!locked)
		locked = TRUE
		var/image/I = image(icon=src.icon, icon_state="babylonchair-overlay", dir=src.dir)
		I.plane = 15
		src.overlays += I
		playsound(src.loc, 'sound/webbers/metswitch.ogg', 80, 1)
		return
	if(locked)
		locked = FALSE
		src.overlays.Cut()
		playsound(src.loc, 'sound/webbers/metswitch.ogg', 80, 1)
		return

/obj/structure/stool/bed/chair/comfy/torture
	icon_state = "torturechair"

/obj/structure/stool/bed/chair/comfy/wooden
	icon = 'icons/lifeplat/comigo.dmi'
	icon_state = "wooden_chair"
	falls = 1
	flammable = 1
	anchored = 0

/obj/structure/stool/bed/chair/comfy/wooden/RightClick(mob/living/M as mob)
	rotate()

/obj/structure/stool/bed/chair/comfy/woodencave
	icon = 'icons/lifeplat/comigo.dmi'
	icon_state = "cave_wooden_chair"
	falls = 1

/obj/structure/stool/bed/chair/comfy/capchair
	icon = 'icons/lifeplat/cFale.dmi'
	icon_state = "capchair"

/obj/structure/stool/bed/chair/comfy/capchairmulti
	icon = 'icons/lifeplat/aPor.dmi'
	icon_state = "capchair"

/obj/structure/stool/bed/chair/comfy/capchairmulti/left
	icon = 'icons/lifeplat/aPor.dmi'
	icon_state = "capchair_left"

/obj/structure/stool/bed/chair/comfy/capchairmulti/left/north
	dir = NORTH

/obj/structure/stool/bed/chair/comfy/capchairmulti/right
	icon = 'icons/lifeplat/aPor.dmi'
	icon_state = "capchair_right"

/obj/structure/stool/bed/chair/comfy/capchairmulti/right/north
	dir = NORTH

/obj/structure/stool/bed/chair/comfy/capchairmulti/center
	icon = 'icons/lifeplat/aPor.dmi'
	icon_state = "capchair_center"

/obj/structure/stool/bed/chair/comfy/capchairmulti/center/north
	dir = NORTH

/obj/structure/stool/bed/chair/comfy/churchair/right
	icon = 'icons/lifeplat/bfavor.dmi'
	icon_state = "church_right"

/obj/structure/stool/bed/chair/comfy/churchair/right/north
	dir = NORTH

/obj/structure/stool/bed/chair/comfy/churchair/left/north
	dir = NORTH

/obj/structure/stool/bed/chair/comfy/churchair/left
	icon = 'icons/lifeplat/bfavor.dmi'
	icon_state = "church_left"



/obj/structure/stool/bed/chair/comfy/churchair/right
	icon = 'icons/lifeplat/bfavor.dmi'
	icon_state = "church_right"


/obj/structure/stool/bed/chair/comfy/brown/throne_minor
	icon = 'icons/obj/throne.dmi'
	icon_state = "smallthrone"

/obj/structure/stool/bed/chair/comfy/beige
	icon_state = "comfychair_beige"

/obj/structure/stool/bed/chair/comfy/teal
	icon_state = "comfychair_teal"

/obj/structure/stool/bed/chair/office
	anchored = 0

/obj/structure/stool/bed/chair/comfy/black
	icon_state = "comfychair_black"

/obj/structure/stool/bed/chair/comfy/cavethrone
	icon_state = "comfychair_black"

/obj/structure/stool/bed/chair/comfy/lime
	icon_state = "comfychair_lime"

/obj/structure/stool/bed/chair/sofa
	name = "sofa"
	icon = 'icons/life/chairs.dmi'
	icon_state = "sofamiddle"
	anchored = TRUE

/obj/structure/stool/bed/chair/sofa/left
	icon_state = "sofaend_left"

/obj/structure/stool/bed/chair/sofa/right
	icon_state = "sofaend_right"

/obj/structure/stool/bed/chair/sofa/corner
	icon_state = "sofacorner"

/obj/structure/stool/bed/chair/office/Move()
	..()
	if(buckled_mob)
		buckled_mob.buckled = null //Temporary, so Move() succeeds.
		var/moved = buckled_mob.Move(src.loc)
		buckled_mob.buckled = src
		if(!moved)
			unbuckle()
	handle_rotation()

/obj/structure/stool/bed/chair/office/light
	icon_state = "officechair_white"

/obj/structure/stool/bed/chair/office/dark
	icon_state = "officechair_dark"

/obj/structure/stool/bed/chair/shuttle
	name = "Shuttle chair"
	desc = "A strong chair welded to the floor."
	icon_state = "schair"
	anchored = 1

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if (istype(W, /obj/item/weapon/wrench))
			if (src.anchored)
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				user << "\blue You begin to unfasten \the [src] from the floor..."
				if (do_after(user, 20))
					user.visible_message( \
						"[user] unfastens \the [src].", \
						"\blue You have unfastened \the [src].", \
						"You hear ratchet.")
					src.anchored = 0
			else
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				user << "\blue You begin to fasten \the [src] to the floor..."
				if (do_after(user, 20))
					user.visible_message( \
						"[user] fastens \the [src].", \
						"\blue You have fastened \the [src].", \
						"You hear ratchet.")
					src.anchored = 1
		else
			..()
			return

/obj/structure/stool/bed/chair/comfy/church
	name = "bishop's throne"
	desc = "A strong chair welded to the floor."
	icon = 'icons/obj/bishop.dmi'
	icon_state = "bchair"
	anchored = 1
//Church pews

/obj/structure/stool/bed/chair/comfy/church/buckle_mob(mob/M as mob, mob/user as mob)
	if (!ticker)
		user << "You can't buckle anyone in before the game starts."
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || user.lying || user.stat || M.buckled || istype(user, /mob/living/silicon/pai) )
		return

	unbuckle()

	if (M == usr)
		M.visible_message("<span class='passivebold'>[M.name]</span> <span class='passive'>sits majestically on [src]!</span>")
	else
		M.visible_message("<span class='passivebold'>[M.name]</span> <span class='passive'>sits majestically on [src]!</span>")
	M.buckled = src
	M.loc = src.loc
	M.dir = src.dir
	M.update_canmove()
	src.buckled_mob = M
	src.add_fingerprint(user)

/obj/structure/stool/bed/chair/comfy/church/unbuckle(mob/M as mob, mob/user as mob)
	if(buckled_mob)
		if(buckled_mob.buckled == src)	//this is probably unneccesary, but it doesn't hurt
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.update_canmove()
			buckled_mob = null

/obj/structure/stool/bed/chair/wood/pew
	name = "pew"
	desc = "A bench for sleeping at masses."
	icon_state = "pews"

/obj/structure/stool/bed/chair/comfy/brown
	icon_state = "comfychair_brown"

/obj/structure/stool/bed/chair/comfy/beige
	icon_state = "comfychair_beige"

/obj/structure/stool/bed/chair/comfy/teal
	icon_state = "comfychair_teal"

/obj/structure/stool/bed/chair/office
	anchored = 0

/obj/structure/stool/bed/chair/comfy/black
	icon_state = "comfychair_black"

/obj/structure/stool/bed/chair/comfy/lime
	icon_state = "comfychair_lime"

/obj/structure/stool/bed/chair/office/Move()
	..()
	handle_rotation()

/obj/structure/stool/bed/chair/office/light
	icon_state = "officechair_white"

/obj/structure/stool/bed/chair/office/dark
	icon_state = "officechair_dark"

//COUCHES:
/obj/structure/stool/bed/chair/comfy/couch
	name = "couch"
//BLACK///////////////////////////////////////////////
/obj/structure/stool/bed/chair/comfy/couch/black/right
	icon_state = "couchblack_right"

/obj/structure/stool/bed/chair/comfy/couch/black/left
	icon_state = "couchblack_left"

/obj/structure/stool/bed/chair/comfy/couch/black/middle
	icon_state = "couchblack_middle"

//BROWN///////////////////////////////////////////////
/obj/structure/stool/bed/chair/comfy/couch/brown/right
	icon_state = "couchbrown_right"

/obj/structure/stool/bed/chair/comfy/couch/brown/left
	icon_state = "couchbrown_left"

/obj/structure/stool/bed/chair/comfy/couch/brown/middle
	icon_state = "couchbrown_middle"

//BEIGE///////////////////////////////////////////////
/obj/structure/stool/bed/chair/comfy/couch/beige/right
	icon_state = "couchbeige_right"

/obj/structure/stool/bed/chair/comfy/couch/beige/left
	icon_state = "couchbeige_left"

/obj/structure/stool/bed/chair/comfy/couch/beige/middle
	icon_state = "couchbeige_middle"

//TEAL//////////////////////////////////////////////////
/obj/structure/stool/bed/chair/comfy/couch/teal/right
	icon_state = "couchteal_right"

/obj/structure/stool/bed/chair/comfy/couch/teal/left
	icon_state = "couchteal_left"

/obj/structure/stool/bed/chair/comfy/couch/teal/middle
	icon_state = "couchteal_middle"

/obj/structure/stool/bed/chair/wheelchair
	name = "wheelchair"
	desc = "You sit in this. Either by will or force."
	icon_state = "wchair"
	layer = 4
	anchored = 0

/obj/structure/stool/bed/chair/wheelchair/Move()
	..()
	playsound(src.loc, 'rollermove.ogg', 50, 1)