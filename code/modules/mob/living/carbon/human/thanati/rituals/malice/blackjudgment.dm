/proc/blackJudgment(var/text = null, var/mob/usr, var/turf/C)
	for(var/atom/A in C.contents)
		if(istype(A, /obj/item/weapon/spacecash/c1))
			qdel(A)
			new /obj/item/weapon/spacecash/c1/thanati(C)
			to_chat(usr, "<i><b>You feel something happening</b></i>")
			break

/obj/item/weapon/spacecash/c1/thanati
	var/victim = null

/obj/item/weapon/spacecash/c1/thanati/hear_talk(mob/M as mob, msg, var/verb, var/datum/language/speaking = null)
	src.victim = replacetext(replacetext(replacetext(msg, ".", ""), "!", ""), "?", "")
	return



/obj/item/weapon/spacecash/c1/thanati/attack_self(var/mob/living/carbon/human/user)
	..()

	if(last)
		var/datum/organ/external/affected = user.get_organ("head")
		to_chat(user, "<b style='color:darkred'>JINXED!</b>")
		sleep(10)
		user.death()
		user.ghostize(1)
		affected.droplimb(1, 0)

	for(var/mob/living/carbon/human/H in player_list)
		if(H.name == src.victim)
			if(H.job == "Bishop" || H.job == "Priest" || H.job == "Baron" || H.job == "Count")
				return
			if(istype(H.amulet, /obj/item/clothing/head/amulet/holy/cross))
				return
			if(is_dreamer(H))
				return
			to_chat(H, "<b style='color:darkred'>You have received judgement.</b>")
			var/datum/organ/external/affectedH = H.get_organ("head")
			sleep(10)
			H.death()
			H.ghostize(1)
			return affectedH.droplimb(1, 0)