/obj/effect/trap
	name = "trap"
	desc = "I Better stay away from that."
	density = 0
	anchored = 1
	layer = 3
	icon = 'icons/mining.dmi'
	icon_state = "trap"
	var/triggerproc = "trapcatch" //name of the proc thats called when the mine is triggered
	var/isactive = TRUE
	var/trap_path = null
	var/trap_type = "KNIFE"

/obj/effect/trap/New()
	icon_state = "trap"
	if(ticker?.eof?.id != "safecaves")
		trap_type = pick("STONE","CLUB","AMBUSH")
	else
		trap_type = pick("STONE","CLUB")
	switch(trap_type)
		if("STONE")
			trap_path = /obj/item/weapon/stone
		if("CLUB")
			trap_path = /obj/item/weapon/melee/classic_baton/boneclub
		if("AMBUSH")
			trap_path = /mob/living/carbon/human/monster/strygh

/obj/effect/trap/Crossed(mob/living/carbon/human/M as mob|obj)
	if(istype(M, /mob/living/carbon/human))
		if(!M.jumping)
			if(isactive)
				for(var/mob/O in viewers(world.view, src.loc))
					to_chat(O,"<font color='combat'>[M] was caught by \the [src]!</font>")
				call(src,triggerproc)(M)
		else
			for(var/mob/O in viewers(world.view, src.loc))
				to_chat(O,"<font color='info'>[M] jumps over [src]</font>")

/obj/effect/trap/proc/trapcatch(AM)
	var/mob/living/carbon/human/H = AM
	if(trap_type == "AMBUSH")
		if(H.m_intent == "run")
			playsound(H.loc, pick('ambush1.ogg','ambush2.ogg','ambush3.ogg','ambush4.ogg','ambush5.ogg','ambush6.ogg'), 50, 0, -1)
			for(var/mob/living/M in view(src))
				to_chat(M,"<font color='red'><h2>AMBUSH!</h2></font>")
				to_chat(M,"<font color='red'><h3>Curse them!</h3></font>")
			isactive = FALSE
			var/monster = pick(/mob/living/carbon/human/monster/loge,/mob/living/carbon/human/skinless,/mob/living/carbon/human/monster/graga,/mob/living/carbon/human/monster/strygh, /mob/living/carbon/human/monster/eelo)
			new monster(src.loc)
			if(istype(monster, /mob/living/carbon/human/skinless))
				new monster(src.loc)
				new monster(src.loc)
			qdel(src)
	else
		playsound(H.loc, 'trap.ogg', 60, 0)
		new trap_path(src.loc)
		var/chosenOrgan = pick(H.organs_by_name)
		playsound(src, 'klevec.ogg', 50, 1, -1)
		H.apply_damage(rand(10,65), BRUTE, chosenOrgan)
		isactive = FALSE
		//IMPROVISO
		qdel(src)

/obj/effect/trap/attack_hand(mob/user as mob)
	if(!isactive)
		to_chat(usr,"<i>You arm the trap.</i>")
		playsound(src.loc, 'trap_arm.ogg', 30, 0)
		isactive = TRUE
	else
		to_chat(usr,"<i>You disarm the trap.</i>")
		playsound(src.loc, 'trap_arm.ogg', 30, 0)
		isactive = FALSE

/mob/living/carbon/human/proc/check_for_traps()
	visible_message(src, "<span class='bname'>[src]</span> begins to gaze around!", \
	"You begin gazing around.")
	if(do_after(src,20-src.my_stats.dx))
		for(var/obj/effect/trap/O in view(9, src))
			to_chat(src,"<i>There are traps nearby!</i>")
			flick('attention.dmi',O)

/obj/effect/trap/skinless/trapcatch(AM)
	var/mob/living/carbon/human/H = AM
	playsound(H.loc, pick('ambush1.ogg','ambush2.ogg','ambush3.ogg','ambush4.ogg','ambush5.ogg','ambush6.ogg'), 100, 1)
	for(var/mob/living/M in view(7, src))
		to_chat(M,"<span class='combatbold'><h2>AMBUSH!</h2></span>")
		to_chat(M,"<span class='combatbold'><h3>Curse them!</h3></span>")
		isactive = FALSE
	new /mob/living/carbon/human/skinless(src.loc)
	new /mob/living/carbon/human/skinless(src.loc)
	new /mob/living/carbon/human/skinless(src.loc)
	new /mob/living/carbon/human/skinless(src.loc)
	qdel(src)