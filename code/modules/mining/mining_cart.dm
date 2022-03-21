/obj/structure/miningcar
	name = "Mining car"
	desc = "A mining car. This one doesn't work on rails, but has to be dragged."
	icon = 'icons/obj/storage.dmi'
	icon_state = "miningcar"
	density = 1
	var/list/mob/living/mob_storage = list()
	var/mob_capacity = 5 //This is so that someone can't pack hundreds players and ganbang the entire fortress.

/obj/structure/miningcar/proc/dump_contents(var/mob/user)
	playsound(src.loc, 'sound/mcar_empty.ogg', 50, 1)
	if(length(mob_storage))
		for(var/mob/living/L in mob_storage)
			L.loc = src.loc
			if(L.client)
				L.client.eye = L.client.mob
			mob_storage -= L
		return

	for(var/obj/I in src)
		I.loc = user.loc

/obj/structure/miningcar/ex_act(severity)
	switch(severity)
		if(1)
			for(var/atom/movable/A as mob|obj in src)//pulls everything out of the car and hits it with an explosion
				A.loc = src.loc
				A.ex_act(severity++)
			qdel(src)
		if(2)
			if(prob(50))
				for (var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					A.ex_act(severity++)
				qdel(src)
		if(3)
			if(prob(5))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					A.ex_act(severity++)
				qdel(src)

/obj/structure/miningcar/attack_animal(mob/living/simple_animal/user as mob)
	if(user.wall_smash)
		visible_message("\red [user] destroys the [src]. ")
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.loc
		del(src)

/obj/structure/miningcar/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if(user.restrained() || user.stat || user.weakened || user.stunned || user.paralysis)
		return
	if(!(istype(O, /mob/living)) || !(istype(user, /mob/living)))
		return
	var/mob/living/M = O
	var/mob/living/U = user
	if(U.loc==null) // just in case someone manages to get a closet into the blue light dimension, as unlikely as that seems
		return
	if(M.buckled)
		return
	if(ishuman(M))
		if(istype(M:species, /datum/species/human/alien))
			return
	if(length(mob_storage) >= mob_capacity)
		to_chat(U, "<span class='combat'>There isn't space for another body!</span>")
		return
	if(user != O)
		U.show_viewers("<span class='combat'>[user] stuffs [O] into [src]!</span>")
	else
		U.show_viewers("<span class='combat'>[U] stuffs [U.gender == FEMALE ? "herself" : "himself"] into [src]!</span>")
	if(M.client)
		M.client.eye = src
	M.loc = src
	mob_storage += M
	mob_capacity++
	src.add_fingerprint(U)
	playsound(src.loc, "sound/mcar_add.ogg", 50, 5)
	return

/obj/structure/miningcar/proc/collect_items(var/mob/user)
	var/items_count = 0

	for(var/obj/item/weapon/ore/lw/F in user.loc)
		if(!F.anchored)
			F.loc = src
			items_count++

	if(items_count)
		user.show_viewers("<span class='passive'>[user] stuffs a [items_count] [items_count > 1 ? "ores" : "ore"] into [src].</span>")
		return

	for(var/obj/item/I in user.loc)
		if(!I.anchored)
			I.loc = src
			items_count++

	user.show_viewers("<span class='passive'>[user] stuffs a [items_count] [items_count > 1 ? "items" : "item"] into [src].</span>")
	playsound(src.loc, "sound/mcar_add.ogg", 50, 3)
	return

/obj/structure/miningcar/relaymove(mob/user as mob)
		src.go_out(user)
		return

// leave the car
/obj/structure/miningcar/proc/go_out(mob/user)
	if (user.client)
		user.client.eye = user.client.mob
		mob_storage -= user
		user.loc = src.loc
		return

/obj/structure/miningcar/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/miningcar/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	collect_items(user)

/obj/structure/miningcar/RightClick(mob/user)
	if(!(istype(user, /mob/living)))
		return
	src.add_fingerprint(user)
	src.dump_contents(user)

/obj/structure/miningcar/wooden
	name = "Wooden mining car"
	icon_state = "wminingcar"