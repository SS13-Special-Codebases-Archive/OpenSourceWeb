/obj/structure/portrait
	name = "Baron's Portrait"
	desc = "A portait with the photo of the Baron of Firethorn."
	icon  = 'icons/obj/portrait.dmi'
	icon_state = "portrait"
	anchored = 1
	var/icon/preview_icon = null
	plane = 21

/obj/structure/portrait/New()
	. = ..()
	processing_objects.Add(src)

/obj/structure/portrait/process()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.job == "Baron")
			var/icon/front = get_id_photo(H)
			overlays += front

/obj/structure/portrait/process()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.job == "Baron")
			var/image/baroninperson
			var/icon/front = get_portrait_photo(H)
			baroninperson = image('icons/obj/portrait.dmi', src, "blank", 2.8)
			baroninperson.pixel_y = -8
			baroninperson.icon = front
			overlays += baroninperson
			processing_objects.Remove(src)


proc/get_portrait_photo(var/mob/living/carbon/human/H)
	var/icon/preview_icon = null

	var/g = "m"
	if (H.gender == FEMALE)
		g = "f"

	var/icon/icobase = H.species.icobase

	preview_icon = new /icon(icobase, "head_[g]")

	var/icon/background
	background = new /icon('icons/obj/portrait.dmi', "background")
	preview_icon.Blend(background, ICON_OVERLAY)

	var/icon/temp
	temp = new /icon(icobase, "head_[g]")
	preview_icon.Blend(temp, ICON_OVERLAY)

	for(var/datum/organ/external/E in H.organs)
		if(E.status & ORGAN_CUT_AWAY || E.status & ORGAN_DESTROYED) continue
		temp = new /icon(icobase, "[E.name]")
		if(E.status & ORGAN_ROBOT)
			temp.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
		preview_icon.Blend(temp, ICON_OVERLAY)

	// Skin tone
	if(H.species.flags & HAS_SKIN_TONE)
		if (H.s_tone >= 0)
			preview_icon.Blend(rgb(H.s_tone, H.s_tone, H.s_tone), ICON_ADD)
		else
			preview_icon.Blend(rgb(-H.s_tone,  -H.s_tone,  -H.s_tone), ICON_SUBTRACT)

	var/icon/eyes_s = new/icon("icon" = 'icons/mob/human_face.dmi', "icon_state" = H.species ? H.species.eyes : "eyes_s")

	eyes_s.Blend(rgb(H.r_eyes, H.g_eyes, H.b_eyes), ICON_ADD)

	var/datum/sprite_accessory/hair_style = hair_styles_list[H.h_style]
	if(hair_style)
		var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
		hair_s.Blend(rgb(H.r_hair, H.g_hair, H.b_hair), ICON_ADD)
		eyes_s.Blend(hair_s, ICON_OVERLAY)

	var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[H.f_style]
	if(facial_hair_style)
		var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
		facial_s.Blend(rgb(H.r_facial, H.g_facial, H.b_facial), ICON_ADD)
		eyes_s.Blend(facial_s, ICON_OVERLAY)

	var/datum/sprite_accessory/facial_details_style = facial_details_list[H.d_style]
	if(facial_details_style)
		var/icon/detail_s = new/icon("icon" = facial_details_style.icon, "icon_state" = "[facial_details_style.icon_state]_s")
		detail_s.Blend(rgb(H.r_detail, H.g_detail, H.b_detail), ICON_ADD)
		eyes_s.Blend(detail_s, ICON_OVERLAY)

	var/icon/clothes_s = null
	switch(H.mind.assigned_role)
		if("Head of Personnel")
			clothes_s = new /icon('icons/obj/portrait.dmi', "photosuit")
			clothes_s.Blend(new /icon('icons/obj/portrait.dmi', ""), ICON_UNDERLAY)
		else
			clothes_s = new /icon('icons/obj/portrait.dmi', "photosuit")
			clothes_s.Blend(new /icon('icons/obj/portrait.dmi', ""), ICON_UNDERLAY)

	if(clothes_s)
		preview_icon.Blend(clothes_s, ICON_OVERLAY)

	preview_icon.Blend(eyes_s, ICON_OVERLAY)
	qdel(eyes_s)
	qdel(clothes_s)

	return preview_icon