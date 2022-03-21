/datum/thanati/thanatiGlobal
	var/list/knowsTheObjective = list()
	var/datum/thanati/objective/objective = null

var/global/datum/thanati/thanatiGlobal/thanatiGlobal //Set in world.New()

/datum/thanati/thanatiGlobal/proc/addKnower(var/mob/living/carbon/human/H)
	if(!knowsTheObjective.Find(H))
		knowsTheObjective.Add(H)

/datum/thanati/thanatiGlobal/proc/isKnower(var/mob/living/carbon/human/H)
	if(knowsTheObjective.Find(H))
		return 1
	return 0

/datum/thanati/thanatiGlobal/proc/setup()
	objective = pick_objective()

/datum/thanati/thanatiGlobal/proc/pick_objective()
	var/objectives = pick(subtypesof(/datum/thanati/objective))
	if (objectives)
		var/objective = new objectives
		return objective
	else
		warning("Error on setting up thanati objectives")

/datum/thanati/objective
	var/name = "Special"
	var/reward = 2

/datum/thanati/objective/proc/checkCompletion()
	return 0

/datum/thanati/objective/killChurch
	name = "Kill the inquisitor, his practicus and the rest of the church."

/datum/thanati/objective/killChurch/checkCompletion()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.stat == 2) continue //its dead
		if(H.job == "Bishop") return 0
		if(H.job == "Inquisitor") return 0
		if(H.job == "Practicus") return 0
		if(H.job == "Nun") return 0
	return 1

/datum/thanati/objective/bombChurch
	name = "Blow up the church, destroying the sun of eternal light."

/datum/thanati/objective/bombChurch/checkCompletion()
	var/completed = 1
	var/turf/T = bombchurch_loc
	if(!T)
		return completed
	for(var/obj/structure/sign/signnew/web/church/sunofeternalnight/S in T)
		if(S)
			completed = 0
	return completed
/*
/datum/thanati/objective/summonTbog
	name = "Summon a manifestation of Tzchernobog."

/datum/thanati/objective/summonTbog/checkCompletion()
	return 0 // LMAAAAAAAAAAAAO RAUFDIASNFJUIASDINJASDNASNJASNFASKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
*/
/datum/thanati/objective/atleastTen
	name = "Have atleast ten of our own inside the fortress."

/datum/thanati/objective/atleastTen/checkCompletion()
	var/amount = 0
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.religion == "Thanati")
			amount += 1
	if(amount >= 10)
		return 1
	else
		return 0

/datum/thanati/objective/atleastTwelve
	name = "Have atleast twelve of our own inside the fortress."

/datum/thanati/objective/atleastTen/checkCompletion()
	var/amount = 0
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.religion == "Thanati")
			amount += 1
	if(amount >= 12)
		return 1
	else
		return 0