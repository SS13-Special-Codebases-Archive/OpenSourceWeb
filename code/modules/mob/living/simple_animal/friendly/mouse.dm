/mob/living/simple_animal/mouse
	name = "rat"
	real_name = "rat"
	desc = "It's a small, disease-ridden rodent."
	icon_state = "mouse"
	icon_living = "mouse"
	icon_dead = "mouse_dead"
	speak = list("Squeek!","SQUEEK!","Squeek?")
	speak_emote = list("squeeks","squeeks","squiks")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")
	pass_flags = PASSTABLE
	small = 1
	speak_chance = 0
	turns_per_move = 5
	see_in_dark = 6
	maxHealth = 5
	health = 5
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "stamps on the"
	density = 0
	var/body_color //brown, gray and white, leave blank for random
	layer = MOB_LAYER
	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius
	universal_speak = 0
	universal_understand = 1
	var/growthneed = 5
	var/eaten = 0

/mob/living/simple_animal/mouse/Life()
	..()
	if(eaten >= growthneed)
		new /mob/living/carbon/human/monster/rat(src.loc)
		qdel(src)

	if(!stat && prob(speak_chance))
		for(var/mob/M in view())
			playsound(M, pick('sound/effects/rat_life.ogg','sound/effects/rat_life2.ogg','sound/effects/rat_life3.ogg'), 40, 0)
	for(var/obj/item/I in range(1,src))
		if(istype(I, /obj/item/weapon/reagent_containers/food/snacks) || istype(I, /obj/item/trash))
			if(prob(15))
				visible_message("<span class='passivebold'>[src]</span><span class='passive'> eats \the [I]</span>")
				eaten += 1
				qdel(I)
	if(!ckey && stat == CONSCIOUS && prob(0.5))
		stat = UNCONSCIOUS
		icon_state = "mouse_sleep"
		wander = 0
		speak_chance = 0
		//snuffles
	else if(stat == UNCONSCIOUS)
		if(ckey || prob(1))
			stat = CONSCIOUS
			icon_state = "mouse"
			wander = 1
		else if(prob(5))
			emote("snuffles")

/datum/reagent/Destroy() // This should only be called by the holder, so it's already handled clearing its references
	holder = null
	. = ..()

/datum/reagents/Destroy()
	. = ..()

	for(var/datum/reagent/R in reagent_list)
		qdel(R)
	reagent_list.Cut()
	reagent_list = null
	if(my_atom && my_atom.reagents == src)
		my_atom.reagents = null

/mob/living/simple_animal/mouse/New()
	..()

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide
	growthneed = rand(1,6)
	name = "[name]"
	icon_state = "mouse"
	icon_living = "mouse"
	icon_dead = "mouse_dead"
	desc = "It's a small rodent, often seen hiding in maintenance areas and making a nuisance of itself."


/mob/living/simple_animal/mouse/proc/splat()
	src.health = 0
	src.stat = DEAD
	src.icon_dead = "mouse_splat"
	src.icon_state = "mouse_splat"
	layer = MOB_LAYER
	if(client)
		client.time_died_as_mouse = world.time

//make mice fit under tables etc? this was hacky, and not working
/*
/mob/living/simple_animal/mouse/Move(var/dir)

	var/turf/target_turf = get_step(src,dir)
	//CanReachThrough(src.loc, target_turf, src)
	var/can_fit_under = 0
	if(target_turf.ZCanPass(get_turf(src),1))
		can_fit_under = 1

	..(dir)
	if(can_fit_under)
		src.loc = target_turf
	for(var/d in cardinal)
		var/turf/O = get_step(T,d)
		//Simple pass check.
		if(O.ZCanPass(T, 1) && !(O in open) && !(O in closed) && O in possibles)
			open += O
			*/

///mob/living/simple_animal/mouse/restrained() //Hotfix to stop mice from doing things with MouseDrop
//	return 1

/mob/living/simple_animal/mouse/start_pulling(var/atom/movable/AM)//Prevents mouse from pulling things
	src << "<span class='warning'>You are too small to pull anything.</span>"
	return

/mob/living/simple_animal/mouse/Crossed(AM as mob|obj)
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			playsound(M, pick('sound/effects/rat_life.ogg','sound/effects/rat_life2.ogg','sound/effects/rat_life3.ogg'), 40, 0, -1)
	..()

/mob/living/simple_animal/mouse/Die()
	layer = MOB_LAYER
	playsound(src, 'sound/effects/rat_death.ogg', 40, 0, -1)
	new /obj/item/weapon/reagent_containers/food/snacks/deadrat(src.loc)
	qdel(src)
	..()

/*
 * Mouse types
 */

/mob/living/simple_animal/mouse/white
	body_color = "white"
	icon_state = "mouse_white"

/mob/living/simple_animal/mouse/gray
	body_color = "gray"
	icon_state = "mouse_gray"

/mob/living/simple_animal/mouse/brown
	body_color = "brown"
	icon_state = "mouse_brown"

//TOM IS ALIVE! SQUEEEEEEEE~K :)
/mob/living/simple_animal/mouse/brown/Tom
	name = "Tom"
	desc = "Jerry the cat is not amused."
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "splats"

/mob/living/simple_animal/mouse/can_use_vents()
	return