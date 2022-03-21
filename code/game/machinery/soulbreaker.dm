/obj/machinery/computer/soulbreaker
	name = "Soulbreaker Teleporter"
	desc = "Used to control a linked teleportation Hub and Station."
	icon_state = "teleport"
	circuit = "/obj/item/weapon/circuitboard/teleporter"

/obj/machinery/computer/soulbreaker/attack_hand(mob/living/carbon/human/M as mob)
	if(M.handcuffed || M.legcuffed)
		return
	if(!M.canmove)
		return
	to_chat(M, "Searching...")
	playsound(src.loc, 'console_interact7.ogg', 60, 0)
	for(var/mob/living/carbon/human/H in mob_list)
		if(istype(H.amulet, /obj/item/clothing/head/amulet/breaker))
			H.forceMove(src.loc)
			to_chat(M, "[H] found!")

/obj/machinery/computer/sellbreaker
	name = "Soulbreaker Slave Seller"
	desc = "Used to control a linked teleportation Hub and Station."
	icon_state = "teleport"
	circuit = "/obj/item/weapon/circuitboard/teleporter"
	var/list/slavetype = "Work"
	var/totalpoints = 0
	var/requiredpoints = 800
	var/allpointsgathered = FALSE

/obj/machinery/computer/sellbreaker/New()
	requiredpoints = rand(650,900)

/obj/machinery/computer/sellbreaker/examine()
	to_chat(usr, "It's in [slavetype] mode. [totalpoints]/[requiredpoints] points left!")

/obj/machinery/computer/sellbreaker/attack_hand(mob/living/carbon/human/M as mob)
	to_chat(M, "Searching...")
	playsound(src.loc, 'console_interact7.ogg', 60, 0)
	for(var/obj/structure/stool/bed/chair/breaker/B in range(src,2))
		if(istype(B.buckled_mob, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = B.buckled_mob
			var/randomamount = 0
			if(H.job == "Soulbreaker" || H.old_job == "Soulbreaker")
				to_chat(M, "HARAM! you can't sell your own brothers!")
				return
			if(H.stat != DEAD)
				switch(slavetype)
					if("Sexual")
						if(H.virgin)
							randomamount = rand(135,160)
						else
							randomamount = rand(125,130)
					if("Noble")
						if(H.job == "Baron" || H.job == "Heir" || H.job == "Successor" || H.job == "Marduk" || H.job == "Guest" || H.royalty)
							randomamount = rand(200,300)
						else
							randomamount = rand(100,125)
					if("Work")
						randomamount = rand(100,125)
			soulbroken.Add(H.real_name)
			H.buckled = null
			H:anchored = initial(H.anchored)
			H.update_canmove()
			qdel(H)
			H = null
			B.buckled_mob = null
			totalpoints += randomamount
			to_chat(M, "[H] sold for [randomamount] points, we have [totalpoints] / [requiredpoints] points!")
			if(totalpoints >= requiredpoints)
				allpointsgathered = TRUE

/obj/machinery/computer/sellbreaker/RightClick(mob/living/carbon/human/user as mob)
	switch(slavetype)
		if("Work")
			slavetype = "Sexual"
		if("Sexual")
			slavetype = "Noble"
		if("Noble")
			slavetype = "Work"
	to_chat(user, "SLAVE TYPE: [slavetype]")
	playsound(src.loc, 'console_interact7.ogg', 60, 0)