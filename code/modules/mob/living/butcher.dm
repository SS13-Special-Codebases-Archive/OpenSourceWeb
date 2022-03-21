/mob/living/butcher
	desc = "What the hell is that thing?! It looks like a fucking monster bodybuilder!?"
	icon = 'icons/monsters/critter.dmi'
	icon_state = "graga"
	maxHealth = 750
	health = 750

/mob/living/butcher/say()
		visible_message("<b class='danger'><h3>[pick("AHHHHHH", "UHHHHHHH", "HGHHHH")]<h3></b>")
		var/selectedSound = pick('sound/effects/graga_life1.ogg', 'sound/effects/graga_life2.ogg', 'sound/effects/graga_life3.ogg')
		playsound(src.loc, selectedSound, 100, 1)
		sleep(100)

/mob/living/butcher/Move()
	var/selectedSound = pick('sound/effects/graga_life1.ogg', 'sound/effects/graga_life2.ogg', 'sound/effects/graga_life3.ogg')
	if(prob(5))
		visible_message("<b class='danger'><h3>[pick("AHHHHHH", "UHHHHHHH", "HGHHHH")]<h3></b>")
		playsound(src.loc, selectedSound, 100, 1)
	return ..()

/mob/living/butcher/movement_delay()
	var/tally = 0
	return tally + 5

/mob/living/butcher/UnarmedAttack(var/atom/A)
	var/selectedSound = 'sound/effects/graga_attack6.ogg'
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		var/chosenOrgan = pick(H.organs_by_name)
		H.apply_damage(90, BRUTE, chosenOrgan)
		var/edgeTurf = get_edge_target_turf(src, src.dir)
		H.throw_at(edgeTurf, 4,	 2)
		playsound(src.loc, selectedSound, 100, 1)
	else
		A.Destroy()
		playsound(src.loc, selectedSound, 100, 1)