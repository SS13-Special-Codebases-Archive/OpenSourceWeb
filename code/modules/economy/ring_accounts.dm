/datum/ring_account
	var/registered_name
	var/assignment
	var/money = 0
	var/mob/living/carbon/human/owner

/datum/ring_account/proc/get_money()
	return money

/datum/ring_account/proc/set_money(var/M)
	money = M
	return money

/datum/ring_account/proc/add_money(var/M)
	money += M
	return money

/datum/ring_account/proc/set_account(var/mob/living/carbon/human/H, var/r_name, var/assig, var/M)
	registered_name = r_name
	assignment = assig
	owner = H
	money = M

/proc/found_account_by_human(var/mob/living/carbon/human/H)
	for(var/obj/item/weapon/card/id/ID in rings_account)
		var/datum/ring_account/RA = rings_account[ID]
		if(RA.owner == H)
			return RA
	return null

/proc/found_ring_by_human(var/mob/living/carbon/human/H)
	for(var/obj/item/weapon/card/id/ID in rings_account)
		var/datum/ring_account/RA = rings_account[ID]
		if(RA.owner == H)
			return ID
	return null