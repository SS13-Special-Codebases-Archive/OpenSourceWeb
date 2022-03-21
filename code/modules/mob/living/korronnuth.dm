/mob/living/sirenhead
	name = "Korronnuth"
	desc = "A statue.."
	icon = 'icons/monsters/korronnuth.dmi'
	icon_state = "korro"

	maxHealth = 5000
	health = 5000
	density = 1
	var/last_snap = 0
	var/amIBeingWatched
	var/next_shit = 0
	var/list/next_blinks = list()
	a_intent = "hurt"
	var/last_player_shit = 0

/mob/living/sirenhead/examine()
	usr << "<b class='danger'><big>I MUST KEEP LOOKING AT IT...</big></b>"

/mob/living/sirenhead/Destroy()
	..()

/mob/living/sirenhead/say()
		visible_message("<b class='danger'><h3>[pick("BZZZZZT", "HZNBBBBBBZZZZ", "UHZZZZZZ", "HUHHHHHH")]<h3></b>")
		var/selectedSound = pick('sound/effects/radio1.ogg', 'sound/effects/radio2.ogg', 'sound/effects/radio3.ogg')
		playsound(src.loc, selectedSound, 40, 1)
		sleep(100)

/mob/living/sirenhead/proc/IsBeingWatched()
	for(var/mob/living/carbon/human/H in view(7, src))
		var/datum/organ/internal/humanEyes = H.internal_organs_by_name["eyes"]
		if(src in H.hidden_mobs)
			continue
		if(H.lying)
			continue
		if(humanEyes.damage > 50)
			continue
		return 1
	return 0

/mob/living/sirenhead/Move()
	if(src.amIBeingWatched)
		return 0
	else
		return ..()

/mob/living/sirenhead/movement_delay()
	return -5

/mob/living/sirenhead/UnarmedAttack(var/atom/A)
	if(!IsBeingWatched() && ishuman(A))
		var/mob/living/carbon/human/H = A
		visible_message("<span class='danger'>[src] snaps [H]'s neck!</span>")
		H.apply_damage(350, BRUTE, "head")

/mob/living/sirenhead/proc/blindness()
	for(var/mob/living/carbon/human/H in view(7, src))
		var/datum/organ/internal/humanEyes = H.internal_organs_by_name["eyes"]
		var/originalDamage = humanEyes.damage
		humanEyes.damage = 60
		sleep(500)
		humanEyes.damage = originalDamage

/mob/living/sirenhead/Life()
	..()
	for(var/mob/living/carbon in view(7, src))
		carbon.update_vision_cone()
	amIBeingWatched = IsBeingWatched()