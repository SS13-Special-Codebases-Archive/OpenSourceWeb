/*
/mob/living/carbon/human/proc/show_to(mob/user as mob)
	if(user.s_active != src)
		for(var/obj/item/I in src)
			if(I.on_found(user))
				return
	if(user.s_active)
		user.s_active.hide_from(user)
	user.client.screen -= src.boxes
	user.client.screen -= src.closer
	user.client.screen -= src.items_organ
	user.client.screen += src.boxes
	user.client.screen += src.closer
	user.client.screen += src.items_organ
	user.s_active = src
	return

/mob/living/carbon/human/proc/orient2hud(mob/user as mob)

	var/adjusted_contents = items_organ.len

	//Numbered contents display
	var/list/datum/numbered_display/numbered_contents
	if(1)
		numbered_contents = list()
		adjusted_contents = 0
		for(var/obj/item/I in items_organ)
			var/found = 0
			for(var/datum/numbered_display/ND in numbered_contents)
				if(ND.sample_object.type == I.type)
					ND.number++
					found = 1
					break
			if(!found)
				adjusted_contents++
				numbered_contents.Add( new/datum/numbered_display(I) )

	//var/mob/living/carbon/human/H = user
	var/row_num = 0
	var/col_count = min(7,5) -1
	if (adjusted_contents > 7)
		row_num = round((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
	src.standard_orient_objs(row_num, col_count, numbered_contents)
	return

/mob/living/carbon/human/proc/standard_orient_objs(var/rows, var/cols, var/list/obj/item/display_contents)
	var/cx = 1+rows
	var/cy = 5+cols
	src.boxes.screen_loc = "1,4 to [1+rows],[5+cols]"

	if(0)
		for(var/datum/numbered_display/ND in display_contents)
			ND.sample_object.screen_loc = "[cx],[cy]"
			ND.sample_object.maptext = "<font color='white'>[(ND.number > 1)? "[ND.number]" : ""]</font>"
			ND.sample_object.layer = 20
			ND.sample_object.plane = 30
			cx++
			if (cx > (5+cols))
				cx = 5
				cy--
	else
		for(var/obj/O in items_organ)
			O.screen_loc = "[cx],[cy]"
			O.maptext = ""
			O.layer = 20
			O.plane = 30

			cy--
			if (cx > (5+cols))
				cx = 5
				cy--
	src.closer.screen_loc = "[rows+1],3"
	return

/mob/living/carbon/human/New()
	..()
	src.boxes = new /obj/screen/storage(  )
	src.boxes.name = "storage"
	src.boxes.master = src
	src.boxes.icon_state = "block"
	src.boxes.screen_loc = "7,7 to 10,8"
	src.boxes.layer = 19
	src.boxes.plane = 30
	src.closer = new /obj/screen/close(  )
	src.closer.master = src
	src.closer.icon_state = "x"
	src.closer.layer = 20
	src.closer.plane = 30
	return
/mob/living/carbon/human/proc/close(mob/user as mob)

	src.hide_from(user)
	user.s_active = null
	return

/mob/living/carbon/human/proc/hide_from(mob/user as mob)

	if(!user.client)
		return
	user.client.screen -= src.boxes
	user.client.screen -= src.closer
	user.client.screen -= src.items_organ
	if(user.s_active == src)
		user.s_active = null
	return


/mob/living/carbon/human/proc/remove_from_storage(obj/item/W as obj, atom/new_location)
	if(!istype(W)) return 0

	if(istype(src, /obj/item/weapon/storage/fancy))
		var/obj/item/weapon/storage/fancy/F = src
		F.update_icon(1)

	for(var/mob/M in range(1, src.loc))
		if (M.s_active == src)
			if (M.client)
				M.client.screen -= W

	if(new_location)
		if(ismob(loc))
			W.dropped(usr)
		if(ismob(new_location))
			W.layer = 20
			W.plane = 30
		else
			W.layer = initial(W.layer)
			W.plane = initial(W.plane)
		W.loc = new_location
	else
		W.loc = get_turf(src)
		W.layer = initial(W.layer)
		W.plane = initial(W.plane)
		src.items_organ -= W

	if(usr)
		src.orient2hud(usr)
		if(usr.s_active)
			usr.s_active.show_to(usr)
	if(W.maptext)
		W.maptext = ""
	W.on_exit_storage(src)
	return 1

/mob/living/carbon/human/proc/handle_item_insertion(obj/item/organ/W as obj, prevent_warning = 0)
	if(!istype(W)) return 0
	W.on_enter_storage(src)
	if(usr)
		usr.u_equip(W)
		usr.update_icons()	//update our overlays
	W.loc = src
	items_organ.Add(W)
	if(usr)
		if (usr.client && usr.s_active != src)
			usr.client.screen -= W
		W.dropped(usr)
		add_fingerprint(usr)

		if(!prevent_warning && !istype(W, /obj/item/weapon/gun/energy/crossbow))
			for(var/mob/M in viewers(usr, null))
				if (M == usr)
					usr << "<span class='notice'>You put the [W] into [src].</span>"
				else if (M in range(1)) //If someone is standing close enough, they can tell what it is...
					M.show_message("<span class='notice'>[usr] puts [W] into [src].</span>")
				else if (W && W.w_class >= 3.0) //Otherwise they can only see large or normal items from a distance...
					M.show_message("<span class='notice'>[usr] puts [W] into [src].</span>")

		src.orient2hud(usr)
		if(usr.s_active)
			usr.s_active.show_to(usr)
	W.update_icon()
	return 1

/mob/living/carbon/human/proc/can_be_inserted(obj/item/W as obj, stop_messages = 0)
	if(!istype(W)) return //Not an item
	if(src.loc == W)
		return 0 //Means the item is already in the storage item
	if(!W.organ)
		return 0
	if(items_organ.len >= 6)
		if(!stop_messages)
			usr << "<span class='notice'>[src] is full, make some space.</span>"
		return 0 //Storage item is full

	if (W.w_class > 4)
		if(!stop_messages)
			usr << "<span class='notice'>[W] is too big for this [src].</span>"
		return 0

	var/sum_w_class = W.w_class
	for(var/obj/item/I in contents)
		sum_w_class += I.w_class //Adds up the combined w_classes which will be in the storage item if the item is added to it.

	if(sum_w_class > 24)
		if(!stop_messages)
			usr << "<span class='notice'>[src] is full, make some space.</span>"
		return 0

	if(W.w_class >= 4 && (istype(W, /obj/item/weapon/storage)))
		if(!istype(src, /obj/item/weapon/storage/backpack/holding))	//bohs should be able to hold backpacks again. The override for putting a boh in a boh is in backpack.dm.
			if(!stop_messages)
				usr << "<span class='notice'>[src] cannot hold [W] as it's a storage item of the same size.</span>"
			return 0 //To prevent the stacking of same sized storage items.

	return 1
*/
proc/coisa(var/obj/item/weapon/reagent_containers/food/snacks/organ/O, var/mob/living/carbon/human/who, var/arme = 0)
	var/organ_name = initial(O.name)
	if(arme == 0)
		who.internal_organs_by_name[organ_name] = null
		who.internal_organs_by_name -= organ_name
		for(var/datum/organ/internal/I in who.internal_organs)
			if(I.name == organ_name)
				who.internal_organs -= I
		processing_objects.Remove(O.organ_data)
	else
		O.organ_data:owner = who
		if(!(organ_name in who.internal_organs_by_name))
			who.internal_organs_by_name += organ_name
		who.internal_organs_by_name[organ_name] = O.organ_data
		who.internal_organs += O.organ_data
		processing_objects.Add(O.organ_data)