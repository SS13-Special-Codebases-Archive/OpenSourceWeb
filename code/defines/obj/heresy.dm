/obj/item/weapon/reagent_containers/food/tzchenoflesh
	name = "Tzchernobog's flesh"
	desc = "What the hell is this?"
	icon

/obj/item/weapon/reagent_containers/syringe/blood_snatcher
	name = "blood snatcher"
	desc = "blood snatcher used by religion folks."
	icon = 'icons/lifeplat/reallynigga.dmi'
	icon_state = "bsnatcher0"
	g_amt = 5
	maybreak = 0
	slot_flags = SLOT_TWOEARS
	//mode_locked = TRUE //Wtf? It's impossible to use it with this

/obj/item/weapon/reagent_containers/syringe/blood_snatcher/update_icon()
	if(reagents && reagents.total_volume)
		icon_state = "bsnatcher1"
	else
		icon_state = "bsnatcher0"

/obj/item/weapon/reagent_containers/glass/beaker/chalice
	name = "chalice"
	desc = "A chalice used to pour blood."
	icon = 'icons/lifeplat/p.dmi'
	icon_state = "chalice"
	item_state = "chalice"

/obj/item/weapon/reagent_containers/glass/beaker/chalice/update_icon()
	if(reagents && reagents.total_volume)
		icon_state = "chalice_full"
	else
		icon_state = "chalice"



/obj/machinery/chem_master/holy_altar
	name = "holy altar"
	desc = "A holy altar used to perform rites."
	icon = 'icons/lifeplat/p.dmi'
	icon_state = "altar"
	var/used = 0

/obj/machinery/chem_master/holy_altar/update_icon()
	if(beaker)
		var/datum/reagents/R = beaker:reagents
		if(!R.reagent_list.len)
			icon_state = "altar_empty"
			return

		for(var/datum/reagent/G in R.reagent_list)
			if(G.volume >= 1)
				icon_state = "altar_chalice"
	else
		icon_state = "altar"

/obj/machinery/chem_master/holy_altar/attackby(obj/item/I, mob/living/carbon/human/user)
	if(used)
		return
	if(istype(I, /obj/item/weapon/reagent_containers/glass/beaker/chalice))
		var/obj/item/weapon/reagent_containers/glass/beaker/chalice/C = I
		src.beaker = C
		user.drop_item(sound = 0)
		C.loc = src
		src.update_icon()
	if(istype(I, /obj/item/weapon))
		var/obj/item/weapon/W = I
		if(W.sharp || W.edge)
			if(src.beaker && istype(src.beaker, /obj/item/weapon/reagent_containers/glass/beaker/chalice))
				var/obj/item/weapon/reagent_containers/glass/beaker/chalice/C = src.beaker
				var/datum/reagents/R = C:reagents
				if(C && R.reagent_list.len)
					for(var/datum/reagent/blood/B in R.reagent_list)
						var/mob/living/carbon/human/D = B.data["donor"]
						if(D.religion  != "Gray Church" || D.falsetarget == 1)
							user.visible_message("<span class='examinebold'>[user] begins carving religious symbols crying out for the Lord.</span>")
							playsound(src.loc, 'sound/lfwbsounds/obj_stone_generic_switch_enter_01.ogg', 100, 1)
							if(do_after(user,30))
								playsound(src.loc, 'sound/misc/altar.ogg', 100, 1)
								used = 1
								for(var/mob/living/carbon/human/H in view(7, src))
									if(H.job == "Inquisitor" && Inquisitor_Type == "Fanatic")
										used = 0
								var/obj/machinery/light/L = locate(/obj/machinery/light) in view(7, src)
								if(L)
									L.flicker()
								for(var/mob/living/carbon/human/H in view(7))
									if(H.job == "Inquisitor" && Inquisitor_Type == "Month's Inquisitor")
										H.gainWP(1,1)
								src.darken()
						else
							user.visible_message("<span class='examinebold'>[user] begins carving religious symbols crying out for the Lord.</span>")
							playsound(src.loc, 'sound/lfwbsounds/obj_stone_generic_switch_enter_01.ogg', 100, 1)
							if(do_after(user,30))
								used = 1
								for(var/mob/living/carbon/human/H in view(7, src))
									if(H.job == "Inquisitor" && Inquisitor_Type == "Fanatic")
										used = 0
								if(prob(5))
									playsound(src.loc, 'sound/misc/altar.ogg', 100, 1)
									var/obj/machinery/light/L = locate(/obj/machinery/light) in view(5, src)
									if(L)
										L.flicker()
									for(var/mob/living/carbon/human/H in view(7))
										if(H.job == "Inquisitor" && Inquisitor_Type == "Month's Inquisitor")
											H.gainWP(1,1)
										src.darken()
/obj/item/weapon/whip
	name = "whip"
	desc = "A whip used to self flagelation."
	icon_state = "whip1"
	item_state = "chain"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 7.0
	damtype = BRUTE
	slot_flags = SLOT_BELT
	throwforce = 2.0
	throw_speed = 3
	throw_range = 6
	hitsound= 'sound/lfwbsounds/shlep.ogg'

/obj/machinery/chem_master/holy_altar/attack_hand(mob/user as mob)
	if(user)
		beaker?:loc = src.loc
		beaker = null
		icon_state = "altar"

/mob/living/carbon/human/var
	gods_martyr = FALSE

/obj/item/weapon/melee/classic_baton/crossofravenheart/attack_self(mob/living/carbon/human/user as mob)
	if(user && !user.stat && user.gods_martyr == FALSE)
		user.visible_message("<span class='looksatbold'>[user]</span> <span class='looksat'>Cries out to the Lord, raising the cross!</span>")
		spawn(5)
			playsound(user.loc, 'sound/webbers/crosslift.ogg', 1000, 1)
		sleep(5)
		var/candles = 0
		var/thanati = 0

		for(var/mob/living/carbon/human/H in world)
			if(H.religion == "Thanati")
				thanati++

		for(var/obj/item/weapon/flame/candle/C in view(world.view, user))
			if(C.lit)
				candles++

		if(candles >= 3)
			user.add_event("martyr", /datum/happiness_event/martyr)
			user.gods_martyr = TRUE

		for(var/obj/item/weapon/flame/candle/C in view(world.view, user))
			if(C.lit)
				if(thanati)
					if(C.lit)
						thanati--
						C.lit = 0
						C.update_icon()
						C.set_light(0)


/obj/structure/lifeweb/statue/wcross/attack_hand(mob/living/carbon/human/user as mob)
	for(var/obj/item/weapon/grab/G in user.grabbed_by)
		var/mob/living/carbon/human/H = G.assailant
		var/mob/living/carbon/human/HH = G.affecting
		if(H.job != "Bishop" || H.job != "Priest")
			return
		if(HH.religion == "Gray Church")
			return
		if(HH.religion == "Thanati")
			return
		if(istype(HH.loc, /turf/simulated/floor/exoplanet/water/shallow))
			switch(alert("Do you want to be baptized?", "Baptized", "Yes", "No"))
				if("Yes")
					HH.visible_message("<span class='looksatbold'>[user]</span> <span class='looksat'>passionately kisses the cross, denying his pagans beliefs.</span>")
					if(do_after(H, 50))
						HH.visible_message("<span class='looksatbold'>[user]</span> <span class='looksat'>accepts the spirit of God!</span>")
						HH.religion = "Gray Church"
						playsound(HH.loc, 'sound/lfwbsounds/oldways_convert.ogg', 1000, 1)
				if("No")
					return

/obj/structure/lifeweb/statue/dummy
	name = "training dummy"
	pixel_x = -4
	desc = "A training dummy."
	icon_state = "dummy"
	display_hiding = FALSE
	var/teaching_mod = 1
	var/max_level = 3
	donation_storage = FALSE

/obj/structure/lifeweb/statue/dummy/attackby(obj/item/weapon/W as obj, mob/living/carbon/human/user as mob)
	if(W.speciality)
		if(user.my_skills.GET_SKILL(W.speciality) >= max_level)
			to_chat(user, "I can't learn anything new with that.")
			return
		src.sound2()
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
		playsound(W.loc, pick('fence_hit1.ogg','fence_hit2.ogg','fence_hit3.ogg'), 25, 1, -1)
		user.adjustStaminaLoss(rand(2,8))
		animate(src, pixel_y=rand(-5,5), pixel_x=rand(-5,5), time = 1)
		spawn(5)
			animate(src, pixel_y=0, pixel_x=-4, time=1)
		user.learn_skill(W.speciality, src, 0, TRUE)
		return
	else
		to_chat(user, "[pick(nao_consigoen)] I can't learn anything with [W]")
		return

/obj/structure/lifeweb/statue/dummy/comicursed
	icon = 'dummyBig.dmi'
	icon_state = ""

/obj/machinery/chem_master/holy_altar/proc/darken()
	for(var/i = 0; i <= 30; i++)
		sleep(10)
		icon_state = "altardarken"
		if(i == 30)
			icon_state = "altardefiled"
			break

/obj/structure/aibots
	name = "flying orb"
	desc = "a flying orb"
	icon = 'icons/lifeplat/aiBots.dmi'
	icon_state = "orb2"
	layer = 4.1

/obj/structure/aibots/New()
	var/colorList = list("#FFA07A", "#008000", "#008080", "#000080", "#800080", "#FF0000", "#F08080")
	var/actualColor = pick(colorList)
	color = pick(actualColor)
	set_light(3, 3, actualColor)

/obj/structure/aibots/stronger/New()
	var/colorList = list("#FFA07A", "#008000", "#008080", "#000080", "#800080", "#FF0000", "#F08080")
	var/actualColor = pick(colorList)
	color = pick(actualColor)
	set_light(7, 4, actualColor)

/obj/structure/aibots/white/New()
	color = "#636363"
	set_light(7, 4, "#636363")

/obj/item/device/blood_snatcher
	icon = 'icons/lifeplat/reallynigga.dmi'
	icon_state = "bsnatcher0"
	name = "blood snatcher"
	desc = "Draws blood from heretics for testing."
	w_class = 1.0
	flags = FPRINT | TABLEPASS
	var/filledblood = FALSE
	var/taintedblood = FALSE

/obj/item/device/blood_snatcher/update_icon()
	if(filledblood)
		icon_state = "bsnatcher1"
	else
		icon_state = "bsnatcher0"

/obj/item/weapon/sonic_screwdriver
	name = "Weird Screwdriver"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "screwdriver"
	w_class = 2

/obj/item/weapon/sonic_screwdriver/sniffer
	icon_state = "screwdriversniffer"

/obj/item/weapon/sonic_screwdriver/afterattack(atom/A, mob/user as mob, proximity) //i could've just done a for() i'm a retard holy fck
	if(!proximity) return
	if(istype(A, /obj/machinery/door/airlock))
		playsound(src.loc, 'sscrew.ogg', 100, 0)
		playsound(src.loc, "sparks", 100, 1)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1,src)
		s.start()
		if(do_after(user, 20))
			playsound(src.loc, 'sscrew.ogg', 100, 0)
			playsound(src.loc, "sparks", 100, 1)
			if(do_after(user, 20))
				playsound(src.loc, 'sscrew.ogg', 100, 0)
				playsound(src.loc, "sparks", 100, 1)
				var/obj/machinery/door/airlock/AA = A
				AA.locked = 0
				playsound(AA.loc, 'sound/airlock_boltswitch.ogg', 100, 1)

/obj/item/device/blood_snatcher/attack(mob/living/L, mob/user)
	var/mob/living/carbon/human/H = L
	if(filledblood)
		usr << "<span class>This is full already!</span>"
		src.update_icon()
	else
		filledblood = 1
		src.update_icon()
		if(H.religion == "Thanati")
			src.taintedblood = TRUE
		else
			src.taintedblood = FALSE
	..()
/obj/machinery/heresy_scan
	name = "Heretic scanner machine"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "heretic"
	density = 1
	anchored = 1

/obj/machinery/heresy_scan/attackby(var/obj/item/I, var/mob/user)
	var/obj/item/device/blood_snatcher/S = I
	if(istype(I,/obj/item/device/blood_snatcher))
		if(S.filledblood)
			src.visible_message("\red <B>Processing...</B>", 1)
			if(S.taintedblood)
				src.visible_message("\red <B>Tainted Blood detected!</B>", 1)
				playsound(src.loc, 'thanati_key.ogg', 30, 0)
				S.filledblood = FALSE
				S.icon_state = "bsnatcher0"
			else
				src.visible_message("\red <B>This blood is pure!</B>", 1)
				playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 30, 0)
				S.filledblood = FALSE
				S.icon_state = "bsnatcher0"
		else
			src.visible_message("\red <B>The snatcher is empty!</B>", 1)
			S.icon_state = "bsnatcher0"





/obj/structure/closet/secure_closet/inquisition
	name = "Inquisition's Locker"
	req_access = list(church)
	icon_state = "inqsec1"
	icon_closed = "inqsec"
	icon_locked = "inqsec1"
	icon_opened = "inqsecopen"
	icon_broken = "inqsecbroken"
	icon_off = "inqsecoff"

	New()
		..()
		sleep(2)
		if(prob(40))
			new/obj/item/weapon/reagent_containers/glass/beaker/chalice(src)
		if(prob(40))
			new/obj/item/weapon/whip(src)
		if(prob(60))
			new/obj/item/weapon/reagent_containers/syringe/blood_snatcher(src)
		if(prob(70))
			new/obj/item/weapon/handcuffs(src)
		if(prob(10))
			new/obj/item/weapon/storage/backpack/minisatchelchurch(src)
		if(prob(20))
			new/obj/item/weapon/storage/backpack/beltsatchelchurch(src)
		if(prob(13))
			new/obj/item/weapon/storage/backpack/minisatchelchurch2(src)
		return


/obj/machinery/obol_give
	name = "almsgiving machine"
	icon = 'icons/obj/objects.dmi'
	icon_state = "5obol"
	density = 1
	anchored = 1
	var/moneystored = 0

/obj/machinery/obol_give/attackby(obj/item/W as obj, mob/living/carbon/human/user as mob)
	if(istype(W, /obj/item/weapon/spacecash))
		var/obj/item/weapon/spacecash/C = W
		if(!(C.worth < 5))
			moneystored += C.worth
			src.visible_message("<span class='passiveboldsmaller'>[user]</span> <span class='passivesmaller'>puts [C.worth] obols in [src].</span>")
			playsound(src.loc, 'sound/effects/coininsert.ogg', 40, 0)
			qdel(C)
			user.add_event("donate", /datum/happiness_event/misc/donate)
			if(user.check_event("epitemia"))
				var/datum/happiness_event/epitemia/mood = user.events["epitemia"]
				if(mood?.epitemia_type == DONATE_CHURCH)
					user.free_sins()

/obj/machinery/obol_give/RightClick(mob/user)
	if(user.job == "Bishop" && moneystored > 0)
		spawn_money(moneystored, src)
		moneystored = 0
		playsound(src.loc, pick('sound/webbers/console_input1.ogg', 'sound/webbers/console_input2.ogg', 'sound/webbers/console_input3.ogg'), 100, 0, -5)
	else if((user.job == "Bishop" && moneystored == 0))
		to_chat(user, "The donations are lacking.")
		return


/obj/machinery/confession_machine
	name = "confession machine"
	icon = 'icons/obj/objects.dmi'
	icon_state = "confes"
	density = 1
	anchored = 1

/obj/item/weapon/avowal
	name = "guilt certificate"
	icon = 'icons/life/avowal.dmi'
	icon_state = "guilt"
	var/kindofguilt = null
	var/signedby = null
	desc = "A statement of guilt."


/obj/item/weapon/avowal/New(var/guilt)
	. = ..()
	kindofguilt = guilt
	desc = "A confession of guilt, the guilt being:[kindofguilt]. [signedby == null ? "It's yet to be signed" : "It's been signed by [signedby]"]"


/obj/item/weapon/avowal/attackby(obj/item/weapon/W as obj, mob/living/carbon/human/user as mob)
	if(istype(W, /obj/item/weapon/pen))
		switch(alert("Do you REALLY want to sign?", "Sign certificate", "Yes", "No"))
			if("Yes")
				if(user.job == "Inquisitor") return
				if(user.real_name == signedby) return
				playsound(src.loc, 'sound/lfwbsounds/sign_this.ogg', 50, 1)
				visible_message("<span class='passiveboldsmaller'>[user]</span> <span class='passivesmaller'>signs the [src]!</span>")
				src.icon_state = "guilt_signed"
				signedby = user.real_name
				for(var/mob/living/carbon/human/H in view(7))
					if(H.job == "Inquisitor")
						if(Inquisitor_Type == "Month's Inquisitor")
							H.gainWP(1,1)
						if(Inquisitor_Type == "Corrupt")
							H?.client?.ChromieWinorLoose(H.client, 1)
				user.add_event("damned", /datum/happiness_event/damned)
			if("No")
				return

/obj/machinery/confession_machine/attack_hand(mob/living/carbon/human/user as mob)
	var/list/pecados = list("Blasphemy", "Slander", "Greed", "Lechery", "Debauchery")
	var/chosen
	chosen = input(user, "What sin has been committed?", "Choose a sin" , "") as null|anything in pecados
	if(chosen)
		var/obj/item/weapon/avowal/A = new/obj/item/weapon/avowal(src.loc)
		A.New(chosen)
		playsound(A.loc, 'sound/effects/confession_print.ogg', 100, 1)

/obj/machinery/confession_machine/attackby(obj/item/weapon/W as obj, mob/living/carbon/human/user as mob)
	if(istype(W, /obj/item/weapon/avowal))
		var/obj/item/weapon/avowal/A = W
		var/guilt_check = "Heresy"
		if(A.kindofguilt == guilt_check && A.signedby)
			for(var/mob/living/carbon/human/H in mob_list)
				if(H.job == "Inquisitor")
					Inquisitor_Points += 5
					H.mind.avowals_of_guilt_sent += 1
	if(istype(W, /obj/item/weapon/paper))
		var/obj/item/weapon/paper/A = W
		if(A.thanatos())
			for(var/mob/living/carbon/human/H in mob_list)
				if(H.job == "Inquisitor")
					Inquisitor_Points += 5
					H.mind.avowals_of_guilt_sent += 1

/obj/item/weapon/heart_beater
	name = "pulse machine"
	desc = "A machine to read pulses."
	icon_state = "heartbeatoff"
	item_state = "shaker"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 7.0
	damtype = BRUTE
	throwforce = 2.0
	throw_speed = 3
	throw_range = 6
	var/on = 0

/obj/item/weapon/heart_beater/attack_self(mob/living/carbon/human/user as mob)
	if(!on)
		on = 1
		icon_state = "heartbeaton"
	else
		on = 0
		icon_state = "heartbeatoff"
	playsound(user, pick('confirm1.ogg', 'confirm2.ogg', 'confirm3.ogg', 'confirm5.ogg', 'confirm7.ogg', 'confirm8.ogg', 'confirm9.ogg'), 100)


/obj/item/weapon/heart_beater/attack(mob/living/carbon/human/M as mob, mob/living/carbon/human/user as mob)
	playsound(src, 'device_on.ogg', 100)
	if(do_after(user,30))
		if(ismonster(M) || iszombie(M) || M?.isVampire || M?.mind?.changeling || M.stat == 2 || M.death_door)
			to_chat(user, "[icon2html(src, usr)]<span class='passivebold'>NO HEARTBEAT DETECTED.</span>")
		else
			to_chat(user, "[icon2html(src, usr)]<span class='passivebold'>HEARTBEAT DETECTED.</span>")
		playsound(src, 'twobeep.ogg', 100)