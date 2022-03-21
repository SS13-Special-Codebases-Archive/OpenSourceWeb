var/global/list/datum/ring_account/rings_account = list()
var/datum/ring_account/treasuryworth
//var/list/treasuryitem = list()
//var/list/treasuryareas = list()

/area/dunwell/station/treasury
	name = "Treasury"
	icon_state = "treasury"
	hum = 1

/datum/controller/gameticker/proc/set_treasury()
	treasuryworth = new /datum/ring_account
	treasuryworth.money = rand(250, 500)

/*/area/dunwell/station/treasury/New()
	..()
	treasuryareas.Add(src)
	for(var/obj/item/O in src)
		if(O.item_worth && !treasuryitem.Find(O))
			treasuryitem.Add(O)
			treasuryworth += O.item_worth

/area/dunwell/station/treasury/proc/updatetreasury()
	for(var/area/dunwell/station/treasury/T in treasuryareas)
		for(var/obj/O in T)
			if(O.item_worth && !treasuryitem.Find(O))
				treasuryitem.Add(O)
				treasuryworth += O.item_worth

/area/dunwell/station/treasury/proc/updatetreasurybankrupt()
	for(var/obj/item/O in treasuryareas)
		if(O.item_worth)
			qdel(O)
	treasuryworth = 0

/area/dunwell/station/treasury/Entered(A)
	if(istype(A,/mob/dead))	return
	if(istype(A,/obj/structure))	return
	if(istype(A,/mob/living/carbon/human))
		var/mob/living/carbon/human/M = A
		for(var/obj/OO in M.contents)
			if(OO.item_worth && !treasuryitem.Find(OO))
				treasuryitem.Add(OO)
				treasuryworth += OO.item_worth
	var/obj/O = A
	if(O.item_worth && !treasuryitem.Find(O))
		treasuryitem.Add(O)
		treasuryworth += O.item_worth

/area/dunwell/station/treasury/Exited(A)
	if(istype(A,/mob/dead))	return
	if(istype(A,/obj/structure))	return
	if(istype(A,/mob/living/carbon/human))
		var/mob/living/carbon/human/M = A
		for(var/obj/OO in M.contents)
			if(OO.item_worth && OO in treasuryitem)
				treasuryitem.Remove(OO)
				treasuryworth -= OO.item_worth
	var/obj/O = A
	if(O.item_worth && treasuryitem.Find(O))
		treasuryitem.Remove(O)
		treasuryworth -= O.item_worth*/

//We don't need shit like this!
