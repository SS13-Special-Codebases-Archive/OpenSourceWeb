#define USERLESS_LAYER			31
/mob/living/carbon/human/proc/add_lifewebchain(var/update_icons=1)
	overlays_standing[USERLESS_LAYER] = null
	var/image/standing = overlay_image('icons/obj/LW2.dmi', "STUCK")
	overlays_standing[USERLESS_LAYER] = standing

	if(update_icons)	update_icons()

/mob/living/carbon/human/proc/remove_lifewebchain(var/update_icons=1)
	overlays_standing[USERLESS_LAYER] = null
	var/image/standing = null
	overlays_standing[USERLESS_LAYER] = standing

	if(update_icons)	update_icons()

/mob/living/carbon/human/verb/unchainLfwbVictim()
	set name = "unchainLFWB"
	set hidden = 1
	if(!lifewebChair || !lifewebChair.Victim)
		return FALSE
	var/obj/structure/stool/bed/chair/altar/A = lifewebChair
	var/mob/living/carbon/human/H = A.Victim

	A.Victim = null
	A.buckled_mob = null
	playsound(src.loc, 'lw_free.ogg', 100, 0, -1)
	H.buckled = null
	H.lifeweb_locked = FALSE
	H.anchored = null
	H.remove_lifewebchain()
	H.update_canmove()
	H.update_icons()
	H.update_body()
	sleep(5)
	step(H, SOUTH)
	return TRUE

/mob/living/carbon/human/verb/toggleLFWB()
	set name = "toggleLFWB"
	set hidden = 1
	var/obj/structure/stool/bed/chair/altar/A = lifewebChair
	var/mob/living/carbon/human/H = A.Victim

	if(A.Victim)
		if(A.status)
			A.status = FALSE
			client << output(list2params(list(0, 0, "ERROR", "ERROR", "ERROR", "ERROR", "[lifewebChair.powerOutput]")), "lifeweb_terminal.browser1:updateLWValues")
			return TRUE
		A.status = TRUE
		client << output(list2params(list("1", H.suitable, H.bloodlevel, H.mortido, H.libido, "[lifewebChair.powerOutput]")), "lifeweb_terminal.browser1:updateLWValues")
	return FALSE


/mob/living/carbon/human/verb/closeLfwb()
	set name = "closeLFWB"
	set hidden = 1
	if(src.client)
		var/client/C = src.client

		C.CloseLfwbC(0)
		return 1
	return 0

/mob/living/carbon/human/verb/updateLfwb()
	set name = "updateLFWB"
	set hidden = 1
	var/obj/structure/stool/bed/chair/altar/A = lifewebChair
	var/mob/living/carbon/human/H = A.Victim

	if(src.client)
		var/client/C = src.client
		if(A.status && A.Victim)
			C << output(list2params(list("1", H.suitable, H.bloodlevel, H.mortido, H.libido, "[lifewebChair.powerOutput]")), "lifeweb_terminal.browser1:updateLWValues")
			return 1
		return

/client/proc/CloseLfwbC(var/sound = 1)
	set name = "closeLFWBC"
	set hidden = 0
	winshow(usr, "lifeweb_terminal", 0)
	lfwbopen = FALSE
	if(mob && sound)
		for(var/obj/machinery/lifeweb/control/C in view(1, mob))
			playsound(C.loc, 'sound/lfwbsounds/lw_key2.ogg', 100, 1)