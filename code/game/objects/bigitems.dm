/obj/item/countflag
	name = "count flag"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "count_banner"
	item_state = "count_banner"
	bigitem = TRUE

/obj/item/countflag/pickup(mob/user)
	..()
	if(ticker.mode.config_tag != "siege")
		return
	var/datum/game_mode/siege/S = ticker.mode
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/U = user
	if(!U.siegesoldier)
		return
	S.flagdropped = FALSE
	for(var/mob/living/carbon/human/H in S.siegerslist)
		H.clear_event("flag")

/obj/item/countflag/dropped()
	..()
	if(ticker.mode.config_tag != "siege")
		return
	var/datum/game_mode/siege/S = ticker.mode
	S.flagdropped = TRUE
	for(var/mob/living/carbon/human/H in S.siegerslist)
		H.add_event("flag", /datum/happiness_event/flag)