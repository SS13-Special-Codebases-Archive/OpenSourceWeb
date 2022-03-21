/mob/living/carbon
	var/isVampire = 0
	var/ExposedFang = 0
	var/DeadEyes = 0
	var/vampireBuffFortitude = 0
	var/vampireBuffCelerity = 0

/mob/living/carbon/human/proc/vampire_me()
	to_chat(src, "<span class='combat'>You're now a</span> <span class='combatglow'>vampire</span>. ")
	to_chat(src, "<span class='bname'>Secret masters of the human race, relying on secrecy and centuries-old wisdom.</span>")
	log_game("[src]([src?.key]) is now a vampire.")
	//src << 'theater-gargoyle.ogg'
	//src.combat_music = 'disturbed-and-twisted-combat.ogg'
	src.isVampire = 1
	src.vice = null
	src.favorite_beverage = "Blood"
	src.verbs += /mob/living/carbon/human/proc/expose_fangs
	src.verbs += /mob/living/carbon/human/proc/blood_strength
	src.verbs += /mob/living/carbon/human/proc/fortitude
	src.verbs += /mob/living/carbon/human/proc/celerety
	src.verbs += /mob/living/carbon/human/proc/dead_eyes
	src.verbs += /mob/living/carbon/human/proc/heal
	src.my_stats.it += 5
	src.my_stats.initit = src.my_stats.it


/mob/living/carbon/human/proc/expose_fangs()
	set category = "Vampire"
	set name = "ExposeFangs"
	if(ExposedFang == TRUE)
		playsound(src.loc, 'sound/effects/fangs0.ogg', 50, 0, -1)
		src.visible_message("<span class='combatbold'>[src]</span> <span class='combat'>hides fangs!</span>")
		src.ExposedFang = FALSE
		src.update_body()
	else
		playsound(src.loc, 'sound/effects/fangs1.ogg', 50, 0, -1)
		src.visible_message("<span class='combatbold'>[src]</span> <span class='combat'>exposes fangs!</span>")
		src.ExposedFang = TRUE
		src.update_body()
	return

/mob/living/carbon/human/proc/heal()
	set category = "Vampire"
	set name = "Heal"
	if(stat == 2) return
	if(src.vessel.total_volume <= 150)
		to_chat(src, "<span class='excomm'>I need more blood!</span>")
		return
	src << 'sound/effects/discipline.ogg'
	src.vessel.remove_reagent("blood",150)
	src.dizziness = 0
	rejuvenate(TRUE)
	return

/mob/living/carbon/human/proc/blood_strength()
	set category = "Vampire"
	set name = "BloodStrength"
	var/maximum = 30
	if(src.vessel.total_volume <= 50)
		to_chat(src, "<span class='excomm'>I need more blood!</span>")
		return
	if(src.my_stats.st < maximum)
		src.my_stats.st += 4
		src.vessel.remove_reagent("blood",50)
		src << 'sound/effects/discipline.ogg'
		spawn(1200)
			src.my_stats.st = src.my_stats.initst
	else
		to_chat(src, "<span class='excomm'>I can't get more than that!</span>")


/mob/living/carbon/human/proc/fortitude()
	set category = "Vampire"
	set name = "Fortitude"
	var/maximum = 30
	if(src.vessel.total_volume <= 50)
		to_chat(src, "<span class='excomm'>I need more blood!</span>")
		return
	if(src.my_stats.ht < maximum)
		src.vessel.remove_reagent("blood",50)
		src.my_stats.ht += 4
		src << 'sound/effects/discipline.ogg'
		vampireBuffFortitude = 1
		spawn(1200)
			vampireBuffFortitude = 0
			src.my_stats.ht = src.my_stats.initht
	else
		to_chat(src, "<span class='excomm'>I can't get more than that!</span>")

/mob/living/carbon/human/proc/celerety()
	set category = "Vampire"
	set name = "Celerety"
	if(src.vessel.total_volume <= 250)
		to_chat(src, "<span class='excomm'>I need more blood!</span>")
		return
	if(vampireBuffCelerity != 1)
		src.my_stats.dx += 6
		src.movement_speed_modifier = 3
		src.vessel.remove_reagent("blood",250)
		src << 'sound/effects/discipline.ogg'
		vampireBuffCelerity = 1
		spawn(900)
			src.my_stats.dx = src.my_stats.initdx
			vampireBuffCelerity = 0
			src.movement_speed_modifier = 1
	else
		to_chat(src, "<span class='excomm'>I can't get more than that!</span>")

/mob/living/carbon/human/proc/dead_eyes()
	set name = "DeadEyes"
	set category = "Undead"

	if (see_invisible == SEE_INVISIBLE_OBSERVER_NOLIGHTING)
		see_invisible = SEE_INVISIBLE_OBSERVER
		src.DeadEyes = 0
		src.regenerate_icons()
	else
		see_invisible = SEE_INVISIBLE_OBSERVER_NOLIGHTING
		src.DeadEyes = 1
		src.regenerate_icons()

/mob/living/carbon/human/proc/handle_vampire()
	stamina_loss = 0
	nutrition = 450
	hidratacao = 700
	src.vessel.remove_reagent("blood", 0.15)
	src.status_flags |= STATUS_NO_PAIN

	for(var/obj/structure/fire/F in view(1, src))
		src.rotate_plane(1)
		to_chat(src, pick("<span class='combatglow'><b>GET THIS OUT OF HERE!</b></span>", "<span class='combatglow'><b>FIRE FIRE FIRE!</b></span>", "<span class='combatglow'><b>AAAAAAAAAAAAAAAAAAAAAAAAH!</b></span>"))

	/*for(var/obj/structure/torchwall/T in view(1, src))
		if(T.on)
			src.rotate_plane(1)
			to_chat(src, pick("<span class='combatglow'><b>GET THIS OUT OF HERE!</b></span>", "<span class='combatglow'><b>FIRE FIRE FIRE!</b></span>", "<span class='combatglow'><b>AAAAAAAAAAAAAAAAAAAAAAAAH!</b></span>"))*/

	for(var/obj/structure/fireplace/F in view(1, src))
		if(F.lit)
			src.rotate_plane(1)
			to_chat(src, pick("<span class='combatglow'><b>GET THIS OUT OF HERE!</b></span>", "<span class='combatglow'><b>FIRE FIRE FIRE!</b></span>", "<span class='combatglow'><b>AAAAAAAAAAAAAAAAAAAAAAAAH!</b></span>"))

/obj/item/attack_hand(mob/user as mob)
	..()
	var/mob/living/carbon/human/H = user
	var/vamp_hand = H.l_hand ? "l_hand" : "r_hand"
	if(H.isVampire)
		if(src.silver && !H.gloves)
			if(vamp_hand)
				to_chat(H, pick("<span class='combatglow'><b>GET THIS OUT OF HERE!</b></span>", "<span class='combatglow'><b>ACCURSED SILVER!</b></span>", "<span class='combatglow'><b>IT BURNS! IT BURNS!</b></span>"))
				H.drop_from_inventory(H.get_active_hand())
				H.apply_damage(rand(5, 10), BRUTE, vamp_hand)
				H.flash_pain()
				H.rotate_plane(1)