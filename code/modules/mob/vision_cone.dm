/////////////VISION CONE///////////////
//Vision cone code by Matt and Honkertron. This vision cone code allows for mobs and/or items to blocked out from a players field of vision.
//This code makes use of the "cone of effect" proc created by Lummox, contributed by Jtgibson. More info on that here:
//http://www.byond.com/forum/?post=195138
///////////////////////////////////////

//"Made specially for Otuska"
// - Honker



//Defines.
#define OPPOSITE_DIR(D) turn(D, 180)

mob/
	var/list/hidden_mobs = list()

client/
	var/list/hidden_atoms = list()

atom/proc/InCone(atom/center = usr, dir = NORTH)
	if(get_dist(center, src) == 0 || src == center) return 0
	var/d = get_dir(center, src)

	if(!d || d == dir) return 1
	if(dir & (dir-1))
		return (d & ~dir) ? 0 : 1
	if(!(d & dir)) return 0
	var/dx = abs(x - center.x)
	var/dy = abs(y - center.y)
	if(dx == dy) return 1
	if(dy > dx)
		return (dir & (NORTH|SOUTH)) ? 1 : 0
	return (dir & (EAST|WEST)) ? 1 : 0

mob/dead/InCone(mob/center = usr, dir = NORTH)
	return

mob/living/InCone(mob/center = usr, dir = NORTH)
	. = ..()
	for(var/obj/item/weapon/grab/G in center)//TG doesn't have the grab item. But if you're porting it and you do then uncomment this.
		if(src == G.affecting)
			return 0
		else
			return .


proc/cone(atom/center = usr, dir = NORTH, list/list = oview(center))
	for(var/turf/T in list)
		for(var/mob/M in T.contents)
			if(!M.InCone(center, dir)) list -= M
	return list

mob/proc/update_vision_cone()
	return

mob/living/carbon/human/update_vision_cone()
	var/datum/organ/external/head/E = get_organ("head")
	var/delay = 10
	var/image/I = null
	for(I in src?.client?.hidden_atoms)
		I.override = 0
		spawn(delay)
			qdel(I)
		delay += 10
	src.check_fov()
	src.hidden_mobs = list()
	src?.client?.hidden_atoms = list()
	if(client)
		if(E?.headwrenched)
			src.fov.dir = turn(src.dir, 180)
			src.fov_mask.dir = turn(src.dir, 180)
			src.fov_mask_two.dir = turn(src.dir, 180)
		else
			src.fov.dir = src.dir
			src.fov_mask.dir = src.dir
			src.fov_mask_two.dir = src.dir
		if(right_eye_fucked && !left_eye_fucked)
			src.fov.icon_state = "right_eye"
			src.fov_mask_two.icon_state = "right_eye_mask"
		else if(!right_eye_fucked && left_eye_fucked)
			src.fov.icon_state = "left_eye"
			src.fov_mask_two.icon_state = "left_eye_mask"
		else if(right_eye_fucked && left_eye_fucked)
			src.fov.icon_state = "helmet"
			src.fov_mask_two.icon_state = "helmet_mask"
		else if(istype(src.head, /obj/item/clothing/head/helmet))
			var/obj/item/clothing/head/helmet/H = src.head
			if(H.blocks_vision)
				src.fov.icon_state = "helmet"
				src.fov_mask_two.icon_state = "helmet_mask"
		else if(istype(src.glasses, /obj/item/clothing/glasses/Leyepatch))
			src.fov.icon_state = "left_eye"
			src.fov_mask_two.icon_state = "left_eye_mask"
		else if(istype(src.glasses, /obj/item/clothing/glasses/Reyepatch))
			src.fov.icon_state = "right_eye"
			src.fov_mask_two.icon_state = "right_eye_mask"
		else
			src.fov.icon_state = initial(src.fov.icon_state)
			src.fov_mask_two.icon_state = initial(src.fov_mask_two.icon_state)
	if(client && fov.alpha || !client && !resting || !client && !lying)
		var/mob/living/carbon/human/M
		var/direcao = src.dir
		if(E?.headwrenched)
			direcao = turn(src.dir, 180)
		for(M in cone(src, OPPOSITE_DIR(direcao), view(1, src)))
			I = image("split", M)
			I.override = 1
			src?.client?.images += I
			src?.client?.hidden_atoms += I
			src.hidden_mobs += M
			M.in_vision_cones[src.client] = 1
			if(src.pulling == M)
				I.override = 0
	else
		return

mob/living/carbon/human/proc/SetFov(var/n)
	if(!n)
		hide_cone()
	else
		show_cone()

mob/living/carbon/human/proc/check_fov()
	if(resting || lying || zoomed || isLeaning)
		hide_cone()
	else
		show_cone()

//Making these generic procs so you can call them anywhere.
mob/living/carbon/human/proc/show_cone()
	if(src.fov)
		src.fov.alpha = 255
		src.fov_mask.alpha = 255
		src.fov_mask_two.alpha = 255

mob/living/carbon/human/proc/hide_cone()
	if(src.fov)
		src.fov.alpha = 0
		src.fov_mask.alpha = 0
		src.fov_mask_two.alpha = 0