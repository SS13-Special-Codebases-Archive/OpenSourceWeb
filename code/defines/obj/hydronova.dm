#define poucaagua 5
#define estoumeafogando 70
#define GROUND_HARD 0
#define GROUND_SOFT 1
#define GROUND_VERY_HARD -1

//fodase eu fiz o meu
/datum/plantstate
	var/speciesgrowing = ""
	var/growingstate = 0
	var/maxgrowth = 0
	var/list/minrange = list()
	var/productpath
	var/image/plantsprite
	var/weed = 0 //0 NAO TEM
	//1 tem

/turf/simulated/floor/plating/dirt2
	var/datum/plantstate/plantgrowing = new
	var/sede = 0
	var/jacresciumavez = 0
	var/ground_state = GROUND_HARD
	var/wetted_state = 0
	var/old_state = 0

/turf/simulated/floor/plating/dirt2/ex_act(severity)
	return

/turf/simulated/floor/plating/dirt2/proc/updateplantoverlay()
	if(!plantgrowing.growingstate)
		return

	overlays -= plantgrowing.plantsprite

	if(plantgrowing.growingstate == -1)
		plantgrowing.plantsprite = image('icons/obj/hydroponics.dmi', icon_state="[plantgrowing.speciesgrowing]-dead")
		overlays += plantgrowing.plantsprite
		return

	var/stategrowth = plantgrowing.growingstate == plantgrowing.maxgrowth ? "harvest" : "grow[plantgrowing.growingstate]"
	var/newiconstate = "[plantgrowing.speciesgrowing]-[stategrowth]"
	plantgrowing.plantsprite = image('icons/obj/hydroponics.dmi', icon_state=newiconstate)

	overlays += plantgrowing.plantsprite

/obj/item/seedsn
	name = "seeds"
	icon = 'icons/obj/seeds.dmi'
	icon_state = ""
	flags = FPRINT | TABLEPASS
	w_class = 1.0 // Makes them pocketable
	var/species = ""
	var/maxstate = 3
	var/product = /obj/item/weapon/reagent_containers/food/snacks/grown/potato
	var/list/minrange = list(1, 3)

/obj/item/seedsn/Destroy()
	qdel(reagents)
	species = null
	maxstate = null
	product = null
	minrange = null
	return ..()

/obj/item/seedsn/New()
	..()
	if(!species)
		species = icon_state
	name = "pack of [species] seeds"

/obj/item/seedsn/apple
	icon_state = "apple"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/apple
	minrange = list(1, 6)
	maxstate = 6


/obj/item/seedsn/tomato
	icon_state = "tomato"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/tomato
	maxstate = 6

/obj/item/seedsn/carrot
	icon_state = "carrot"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/carrot
	maxstate = 5

/obj/item/seedsn/corn
	icon_state = "corn"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/corn
	maxstate = 3

/obj/item/seedsn/potato
	icon_state = "potato"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/potato
	maxstate = 4

/obj/item/seedsn/pumpkin
	icon_state = "pumpkin"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/pumpkin
	maxstate = 2

/obj/item/seedsn/wheat
	icon_state = "wheat"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/wheat
	maxstate = 6

/obj/item/seedsn/weed
	icon_state = "wheat"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/weed
	maxstate = 2


/obj/item/seedsn/wheat
	icon_state = "wheat"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/wheat
	maxstate = 6

/obj/item/seedsn/eggplant
	icon_state = "eggplant"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/eggplant
	maxstate = 6

/obj/item/seedsn/sweetpod
	species = "sweetpod"
	icon_state = "sweetpod"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/sweetpod
	maxstate = 3

/obj/item/seedsn/pigtail
	icon_state = "pigtail"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/pigtail
	maxstate = 3

/obj/item/seedsn/beet
	icon_state = "beet"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/beet
	maxstate = 3

/obj/item/seedsn/turnip
	icon_state = "turnip"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/turnip
	maxstate = 3

/obj/item/seedsn/onion
	icon_state = "onion"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/onion
	maxstate = 2

/obj/item/seedsn/garlic
	icon_state = "garlic"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/garlic
	maxstate = 2

/obj/item/seedsn/plump
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/plumphelmet
	maxstate = 3
	species = "plump"

/obj/item/seedsn/gryab
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/gryab
	maxstate = 3
	species = "gryab"

/obj/item/seedsn/podgnylnik
	species = "podgnylnik"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/podgnylnik
	maxstate = 3

/obj/item/seedsn/angel
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/ljutogreeb
	maxstate = 3
	species = "curer"

/obj/item/seedsn/libertycap
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/otorvyannik
	maxstate = 3

/obj/item/seedsn/ovrajnik
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/ovrajnik
	maxstate = 3
	species = "fshroom"

/obj/item/seedsn/slezjak
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/slezjak
	maxstate = 3
	species = "eshroom"

/obj/item/seedsn/zelegreeb
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/zelegreeb
	maxstate = 3
	species = "cshroom"

/obj/item/seedsn/bezglaznik
	species = "bezglaznik"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/bezglaznik
	maxstate = 3

/obj/item/seedsn/barhovik
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/barhovik
	maxstate = 3
	species = "dshroom"

/obj/item/seedsn/krovnik
	species = "krovnik"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/krovnik
	maxstate = 3
	species = "krovnik"

/obj/item/seedsn/corniy
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/corniy
	maxstate = 3
	species = "ashroom"

/obj/item/seedsn/zheleznyak
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/zheleznyak
	maxstate = 3
	species = "bshroom"

/turf/simulated/floor/plating/dirt2/proc/crescer()
	if(plantgrowing.growingstate <= 0 || plantgrowing.growingstate == plantgrowing.maxgrowth)
		return
	plantgrowing.growingstate++
	if(plantgrowing.growingstate + 1 >= plantgrowing.maxgrowth)
		plantgrowing.growingstate = plantgrowing.maxgrowth
		jacresciumavez++

	if(jacresciumavez >= 1)
		if(prob(20 * jacresciumavez))
			plantgrowing.growingstate = -1
	return updateplantoverlay()

/turf/simulated/floor/plating/dirt2/proc/ficarcomsede()
	if(plantgrowing.growingstate > 0)
		return
	if(sede > estoumeafogando)
		var/chancedeafogar = sede - estoumeafogando
		if(prob(chancedeafogar * 3))
			plantgrowing.growingstate = -1
			return updateplantoverlay()
	if(sede < poucaagua && plantgrowing.weed)
		if(prob(30))
			plantgrowing.growingstate = -1
			return updateplantoverlay()
	if(sede - 1 <= 0)
		plantgrowing.growingstate = -1
		sede = 0
		return updateplantoverlay()

	sede--

/turf/simulated/floor/plating/dirt2/proc/weed()
	if(!plantgrowing.speciesgrowing)
		return
	if(!plantgrowing.weed)
		return
	var/chance = 18
	if(jacresciumavez > 0)
		chance *= jacresciumavez * 2
	if(prob(chance))
		plantgrowing.weed = 1

/turf/simulated/floor/plating/dirt2/New()
	..()
	processing_turfs.Add(src)
	wetted_state = "dirt[rand(1,16)]"
	old_state = "[rand(1,16)]"

/turf/simulated/proc/process_turf()
	return

/turf/simulated/floor/plating/dirt2/process_turf()
	..()

	if(prob(1) && prob(4) && !plantgrowing.speciesgrowing)
		var/tipo = pick(/obj/item/seedsn/gryab, /obj/item/seedsn/bezglaznik, /obj/item/seedsn/corniy, /obj/item/seedsn/slezjak, /obj/item/seedsn/zelegreeb, /obj/item/seedsn/zheleznyak)
		var/obj/item/seedsn/S = new tipo(src)
		src.sede = 50
		src.ground_state = GROUND_SOFT
		plant_seed(S)

	if(diggability == 4)
		switch(sede)
			if(-INFINITY to poucaagua)
				icon = initial(icon)
				icon_state = old_state
			if(poucaagua to INFINITY)
				icon = 'icons/obj/hydroponics.dmi'
				icon_state = wetted_state

/turf/simulated/floor/plating/dirt2/examine()
	..()
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(plantgrowing.weed)
		to_chat(usr, "<br><span class='combatbold'>This soil is infested with <b>maggots.</b></span>")
	if(H.my_skills.GET_SKILL(SKILL_FARM) < 5) return

	var/desc = ""
	switch(sede)
		if(-INFINITY to poucaagua)
			desc = "<span class='combatbold'>The soil seems <b>dry.</b></span>"
		if(poucaagua to estoumeafogando)
			desc = "<spán class='passivebold'>The soil seems <b>sufficiently wet.</b></span>"
		if(estoumeafogando to INFINITY)
			desc = "<span class='combatbold'>The soil is <b>overwet.</b></span>"
	to_chat(usr, desc)

/turf/simulated/floor/plating/dirt2/attack_hand(mob/user)
	if(!plantgrowing.speciesgrowing)
		return ..()
	if(!ishuman(user))
		return ..()

	var/mob/living/carbon/human/H = user
	if(plantgrowing.growingstate == -1)
		var/list/roll = roll3d6(H,SKILL_FARM,null,TRUE) //suffer
		var/result = roll[GP_RESULT]
		var/margin = roll[GP_MARGIN]
		switch(result)
			if(GP_CRITSUCCESS)
				user.visible_message("<span class ='passivebold'>[user]</span><span class ='passive'> <B> INSTANTLY</B> rips the dead plant out of \the <span class ='passivebold'>[src]</span>!</span>")
				qdel(plantgrowing)
				overlays = list()
				plantgrowing = new
				return
			if(GP_SUCCESS)
				user.visible_message("<span class ='passivebold'>[user]</span><span class ='passive'> begins removing the dead plant from \the <span class ='passivebold'>[src]</span></span>")
				if(do_after(user, (13 - margin)))
					src.visible_message("<span class ='passivebold'>[user]</span><span class ='passive'> removes the dead plant from \the <span class ='passivebold'>[src]</span></span>")
					qdel(plantgrowing)
					overlays = list()
					plantgrowing = new
					return
			if(GP_FAILED)
				user.visible_message("<span class ='passivebold'>[user]</span><span class ='passive'> begins removing the dead plant from \the <span class ='passivebold'>[src]</span></span>")
				if(do_after(user, (13 - margin)))
					src.visible_message("<span class ='passivebold'> [user]</span><span class ='passive'> removes the dead plant from \the <span class ='passivebold'>[src]</span></span>")
					qdel(plantgrowing)
					overlays = list()
					plantgrowing = new
					return
			if(GP_CRITFAIL)
				user.visible_message("<span class ='passivebold'>[user]</span><span class ='passive'> begins removing the dead plant from \the <span class ='passivebold'>[src]</span></span>")
				if(do_after(user, (13 - margin)))
					user.visible_message("<span class ='combatbold'> [user]</span> <span class ='combat'> fails to remove the dead plant from \the <span class ='combatbold'>[src]</span> ruining the ground in the process!</span>")
					if(src.ground_state > GROUND_VERY_HARD)
						ground_state--
					return

	if(plantgrowing.growingstate < plantgrowing.maxgrowth)
		return ..()

	var/rangetospawn = plantgrowing.minrange
	var/farming = max(1,H.my_skills.GET_SKILL(SKILL_FARM))
	user.visible_message("<span class ='passivebold'>[user]</span><span class ='passive'> begins harvesting the plant.</span>")
	if(do_after(H,20))
		var/list/roll = roll3d6(H,SKILL_FARM,null)
		var/result = roll[GP_RESULT]
		var/margin = roll[GP_MARGIN]
		switch(result)
			if(GP_CRITSUCCESS)
				rangetospawn = list(rangetospawn[1], rangetospawn[2] + (round(farming / 2) + margin))
			if(GP_SUCCESS)
				rangetospawn = list(rangetospawn[1], rangetospawn[2] + round(farming / 2))
			if(GP_FAILED)
				rangetospawn = list(rangetospawn[1], rangetospawn[2] + margin)
			if(GP_CRITFAIL)
				to_chat(H,"<span class='combatbold'>[pick(nao_consigoen)]</span><span class='combat'> I've <span class='combatbold'>RUINED</span> the plant!</span>")
				qdel(plantgrowing)
				overlays = list()
				plantgrowing = new

		if(rangetospawn[2] <= 0)
			to_chat(H,"<span class='combatbold'>[pick(nao_consigoen)]</span><span class='combat'> I've failed to harvest the plant!</span>")
			return

		for(var/x = rangetospawn[1]; x != rangetospawn[2]; x++)
			playsound(user, pick('hydro_harvest1.ogg','hydro_harvest2.ogg','hydro_harvest3.ogg','hydro_harvest4.ogg'), rand(35, 45), 0)
			new plantgrowing.productpath(src)

		overlays = list()
		plantgrowing = new

/obj/effect/decal/cleanable/urine/New()
	..()
	if(!istype(loc, /turf/simulated/floor/plating/dirt2))
		return
	var/turf/simulated/floor/plating/dirt2/F = loc
	F.sede += rand(2, 5)
	spawn(15)
		qdel(src)

/obj/effect/fakewater/New()
	..()
	if(!istype(loc, /turf/simulated/floor/plating/dirt2))
		return
	var/turf/simulated/floor/plating/dirt2/F = loc
	F.sede += rand(6, 12)
	spawn(15)
		qdel(src)

/obj/item/weapon/ore/dirt/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/weapon/shovel))
		var/obj/item/weapon/shovel/S = C
		if(!S.contents.len)
			S.contents += src
			src.loc = S
			playsound(user, 'sound/effects/dig_shovel.ogg', 50, 1)
			S.update_icon()

//SISTEMA DE FERTILIZAR E TACAR AGUA
/turf/simulated/floor/plating/dirt2/attackby(obj/item/C, mob/user)
	//FERTLIZANTE
	. = ..()

	if(plantgrowing.speciesgrowing)
		return
	if(istype(C, /obj/item/seedsn))
		plant_seed(C,user)
	if(istype(C, /obj/item/weapon/reagent_containers/food/snacks/grown/potato))
		var/obj/item/seedsn/potato/P = new()
		if(plant_seed(P,user))
			qdel(C)

	var/turf/simulated/floor/plating/dirt2/D = src
	if(istype(C, /obj/item/weapon/shovel))
		var/obj/item/weapon/shovel/S = C
		if(S.contents.len)
			if(D.diggability < 4) // NAO TA CHEIO DA PRA BOTAR MAIS
				if(locate(/obj/structure/pit) in D)
					to_chat(user, "I already dug a pit there.")
					return
				D.diggability += 1
				S.contents.Cut()
				playsound(D, 'sound/effects/empty_shovel.ogg', 50, 1)
				D.update_icon()
				S.update_icon()
				return
			if(D.diggability >= 4)
				for(var/obj/item/I in S)
					S.contents -= I
					I.loc = D
				playsound(D, 'sound/effects/empty_shovel.ogg', 50, 1)
				D.update_icon()
				S.update_icon()
				return
		else
			if(D.diggability > 1)
				var/obj/item/weapon/ore/dirt/chao = new(user.loc)
				S.contents += chao
				chao.loc = S
				D.diggability -= 1
				playsound(D, 'sound/effects/dig_shovel.ogg', 50, 1)
				if(D.diggability == 1)
					new/obj/structure/pit(D)
				D.update_icon()
				S.update_icon()
				return

	if(istype(C,/obj/item/weapon/reagent_containers/food/snacks/poo))
		if(jacresciumavez - 1 <= -2)
			jacresciumavez = -2
			return
		jacresciumavez--
		qdel(C)
		return

	if(istype(C,/obj/item/weapon/reagent_containers/food/snacks/bone))
		if(jacresciumavez - 1 <= -2)
			jacresciumavez = -2
			return
		jacresciumavez--
		qdel(C)
		return


	//TACAR AGUA
	if(istype(C, /obj/item/weapon/reagent_containers))
		var/obj/item/weapon/reagent_containers/R = C
		var/reagentResult = R.reagents.get_reagent_amount("water")
		if(reagentResult <= 0)
			return
		if(reagentResult > 2)
			reagentResult /= 2
		user.visible_message("<span class='passivebold'>[user.name] wets the soil.</span>")
		R.reagents.remove_reagent("water", reagentResult)
		sede += reagentResult
		return

	if(istype(C, /obj/item/weapon/minihoe))
		if(!ishuman(user))
			return
		var/mob/living/carbon/human/H = user
		if(ground_state == GROUND_SOFT)
			to_chat(user,"<span class='combatbold'>[pick(nao_consigoen)]</span><span class='combat'> The soil is already soft!</span>")
			return
		var/obj/item/weapon/W = C
		var/mod = 0
		mod += sede
		mod += W.quality
		if(C.wielded == FALSE)
			mod -= 10
		var/list/roll = roll3d6(H,SKILL_FARM,mod,TRUE)
		user.visible_message("<span class ='passivebold'>[user]</span><span class ='passive'> begins softening \the <span class ='passivebold'>[src]</span> with \the <span class ='passivebold'>[C]</span>.</span>")
		var/result = roll[GP_RESULT]
		var/margin = roll[GP_MARGIN]
		switch(result)
			if(GP_CRITSUCCESS)
				to_chat(user,"<span class = 'legendary'>Amazing!</span><span class='passive'> I've instantly softened \the <span class ='passivebold'>[src]</span>!</span>")
				ground_state++
				playsound(user, pick('pitchfork.ogg','pitchfork2.ogg'), rand(35, 45), 0)
			if(GP_SUCCESS)
				if(do_after(user, (25 - margin)))
					to_chat(user,"<span class = 'passivebold'>There</span><span class='passive'>, \the <span class ='passivebold'>[src]</span> is now softer.</span>")
					playsound(user, pick('pitchfork.ogg','pitchfork2.ogg'), rand(35, 45), 0)
					if(ground_state < GROUND_SOFT)
						ground_state++
					return

			if(GP_FAILED)
				if(do_after(user, (25 - margin)))
					to_chat(user,"<span class='combatbold'>[pick(nao_consigoen)]</span><span class='combat'> I haven't managed to soften \the <span class ='combatbold'>[src]</span>!</span>")
					return

			if(GP_CRITFAIL)
				if(do_after(user, (25 - margin)))
					to_chat(user,"<span class='combatbold'>[pick(nao_consigoen)]</span><span class='combat'> I've ruined \the <span class ='combatbold'>[src]</span>!</span>")
					ground_state = GROUND_VERY_HARD
					return
	..()

/turf/simulated/floor/plating/dirt2/proc/plant_seed(var/obj/item/seedsn/S, var/mob/user)
	if(sede <= 0)
		if(user)
			to_chat(user, "<span class='combatbold'>This soil is too dry. I should make it wet somehow.</span>")
		return FALSE

	if(ground_state < GROUND_SOFT)
		if(user)
			to_chat(user, "<span class='combatbold'>This soil is too hard. I should break it up somehow.</span>")
		return FALSE

	plantgrowing.speciesgrowing = S.species
	plantgrowing.growingstate = 1
	plantgrowing.maxgrowth = S.maxstate
	plantgrowing.productpath = S.product
	plantgrowing.minrange = S.minrange

	qdel(S)
	spawn while(plantgrowing.speciesgrowing)
		sleep(35)
		ficarcomsede()
	spawn while(plantgrowing.speciesgrowing)
		sleep(600)
		crescer()
	spawn while(plantgrowing.speciesgrowing)
		sleep(35)
		weed()
	updateplantoverlay()
	return TRUE


/obj/item/weapon/reagent_containers/food/snacks/grown/attackby(obj/item/weapon/W, mob/user)
	if(!W.isBlunts() || no_seeds)
		return ..()
	if(!isturf(src.loc))
		return ..()

	var/pathh = "/obj/item/seedsn/[plantname]"
	pathh = text2path(pathh)

	visible_message("<span class='bname'>[user]</span> crushes [src].")
	playsound(user, pick('itm_ingredient_mushroom_up_01.ogg','itm_ingredient_mushroom_up_02.ogg','itm_ingredient_mushroom_up_03.ogg','itm_ingredient_mushroom_up_04.ogg'), 70, 0)
	if(ispath(pathh)) //temp fix
		var/obj/item/seedsn/N = new pathh(user.loc)
		N.icon_state = ""
		N.name = "[plantname] seeds"
	else
		to_chat(user,"<span class='combat'>There are no seeds inside \the [src]!</span>")
	qdel(src)

#undef GROUND_HARD
#undef GROUND_SOFT
#undef GROUND_VERY_HARD