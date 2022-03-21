#define CONDOM_NONE 0
#define CONDOM_SMALL 1
#define CONDOM_REGULAR 2
#define CONDOM_BIG 3

/obj/item/condom_wrapper
	name = "condom"
	icon = 'icons/obj/personal.dmi'
	var/icon_state_abrido =  "wrapper_s_empty"
	var/icon_state_fechado = "wrapper_s"
	var/opened = FALSE
	var/obj/item/condom/condomtype = /obj/item/condom
	w_class = 1.0

/obj/item/condom_wrapper/New()
	..()
	update_icon()

/obj/item/condom_wrapper/update_icon()
	if(opened)
		icon_state = icon_state_abrido
	else
		icon_state = icon_state_fechado

/obj/item/condom_wrapper/attack_self(mob/user as mob)
	if(!opened)
		if(do_after(user, 5))
			to_chat(user, "<span class='passive'>You open the condom wrapper.</span>")
			opened = TRUE
			playsound(user, "open_candy.ogg", 50, 0)
			update_icon()
			var/turf/T = get_turf(user)
			new condomtype(T)
	else
		to_chat(user, "<span class='combat'>[pick(nao_consigoen)] it is already open!</span>")
	return

/obj/item/condom_wrapper/small
	name = "small condom (1-10cm)"
	icon = 'icons/obj/personal.dmi'
	icon_state_abrido =  "wrapper_s_empty"
	icon_state_fechado = "wrapper_s"
	icon_state = "wrapper_s"
	condomtype = /obj/item/condom/small

/obj/item/condom_wrapper/regular
	name = "regular condom (11-18cm)"
	icon = 'icons/obj/personal.dmi'
	icon_state_abrido =  "wrapper_empty"
	icon_state_fechado = "wrapper"
	icon_state = "wrapper"
	condomtype = /obj/item/condom/regular


/obj/item/condom_wrapper/large
	name = "large condom (19-30cm)"
	icon = 'icons/obj/personal.dmi'
	icon_state_abrido =  "wrapper_l_empty"
	icon_state_fechado = "wrapper_l"
	icon_state = "wrapper_l"
	condomtype = /obj/item/condom/big


/obj/item/condom
	var/minsize = 0
	var/maxsize = 0
	var/alreadyUsed = FALSE
	var/CameInto = FALSE
	var/condomsize = CONDOM_NONE

/obj/item/condom/update_icon()
	if(alreadyUsed)
		var/sizeicon
		switch(condomsize)
			if(CONDOM_SMALL)
				sizeicon = "s"
			if(CONDOM_REGULAR)
				sizeicon = "m"
			if(CONDOM_BIG)
				sizeicon = "xxl"
		var/icon_condom = "condom_[sizeicon]"
		if(CameInto)
			icon_condom = "ucondom_[sizeicon]"
		icon_state = icon_condom
	else
		icon_state = "condom_ready"

/obj/item/condom/small
	name = "condom"
	icon = 'icons/obj/personal.dmi'
	icon_state = "condom_s"
	desc = "1-10 cm"
	minsize = 1
	maxsize = 10
	condomsize = CONDOM_SMALL

/obj/item/condom/New()
	..()
	update_icon()

/obj/item/condom/regular
	name = "condom"
	icon = 'icons/obj/personal.dmi'
	icon_state = "condom_s"
	desc = "11-18 cm"
	minsize = 11
	maxsize = 18
	condomsize = CONDOM_REGULAR

/obj/item/condom/big
	name = "condom"
	icon = 'icons/obj/personal.dmi'
	icon_state = "condom_s"
	desc = "19-30 cm"
	minsize = 19
	maxsize = 30
	condomsize = CONDOM_BIG

/mob/living/carbon/human/attacked_by(var/obj/item/I, var/mob/living/carbon/human/attacker, var/def_zone)
	if(istype(I, /obj/item/condom) && attacker.zone_sel.selecting == "groin" && !src.ConDom)
		var/obj/item/condom/C = I
		if(src.potenzia < C.minsize || src.potenzia > C.maxsize)
			to_chat(src, "<span class='combatbold'>[pick(nao_consigoen)] Won't fit!</span>")
			return
		if(do_after(attacker, 10))
			attacker.drop_from_inventory(I)
			src.ConDom = I
			ConDom.loc = src
			C.alreadyUsed = TRUE
	..()

/**********************************
*******Interactions code by HONKERTRON feat TestUnit with translations and code edits by Matt********
**Contains a lot ammount of ERP and MEHANOYEBLYA**
***********************************/

var/list/cuckoldlist = list()
/mob/living/carbon/human/MouseDrop_T(mob/M as mob, mob/user as mob)
	if(M == src || src == usr && src.ConDom)
		if(do_after(M, 10))
			src.drop_from_inventory(src.ConDom)
			src.put_in_active_hand(src.ConDom)
			src.ConDom = null
	if(M == src || src == usr || M != usr)			return
	if(usr.restrained())		return
	var/mob/living/carbon/human/H = usr
	H.partner = src
	if(H.isChild())		return
	if(src.isChild())	return
	if(master_mode == "miniwar")	return
	if(iszombie(H))		return
	if(istype(H.species, /datum/species/human/alien)) return //stopping a problem before it ever happens
	if(istype(src.species, /datum/species/human/alien)) return
	make_interaction(machine)

/mob/proc/make_interaction()
	return

//Distant interactions
///mob/living/carbon/human/verb/interact(mob/M as mob)
//	set name = "Interact"
//	set category = "IC"
//
//	if (istype(M, /mob/living/carbon/human) && usr != M)
//		partner = M
//		make_interaction(machine)

/datum/species/human
	genitals = 1
	anus = 1

/mob/living/carbon/human/proc/get_pleasure_amt(hole)
	switch (hole)
		if ("anal")
			switch (potenzia)
				if (-INFINITY to 9)
					return potenzia * 0.15
				if (10 to 20)
					return potenzia * 0.30
				if (21 to INFINITY)
					return potenzia * 0.45
		if ("anal-2")
			return get_pleasure_amt("anal") * 1
		if ("vaginal")
			switch (potenzia)
				if (-INFINITY to 9)
					return potenzia * 0.33
				if (10 to 20)
					return potenzia * 0.66
				if (21 to INFINITY)
					return potenzia * 1.00
		if ("vaginal-2")
			return get_pleasure_amt("vaginal") * 2

/mob/living/carbon/human/proc/is_nude()
	return (!w_uniform) ? 1 : 0

/mob/living/carbon/human/make_interaction()
	set_machine(src)

	var/mob/living/carbon/human/H = usr
	var/mob/living/carbon/human/P = H.partner
	var/datum/organ/external/temp = H.organs_by_name["r_hand"]
	var/hashands = (temp && temp.is_usable())
	if (!hashands)
		temp = H.organs_by_name[BP_L_HAND]
		hashands = (temp && temp.is_usable())
	temp = P.organs_by_name[BP_R_HAND]
	var/hashands_p = (temp && temp.is_usable())
	if (!hashands_p)
		temp = P.organs_by_name[BP_L_HAND]
		hashands = (temp && temp.is_usable())
	temp = H.organs_by_name["head"]
	var/mouthfree = !(H.wear_mask && temp)
	temp = P.organs_by_name["head"]
	var/mouthfree_p = !(P.wear_mask && temp)
	var/haspenis = H.has_penis()
	var/haspenis_p = P.has_penis()
	var/hasvagina = (H.gender == FEMALE && H.species.genitals && !haspenis)
	var/hasvagina_p = (P.gender == FEMALE && P.species.genitals && !haspenis_p)
	var/hasanus_p = P.species.anus
	var/isnude = H.is_nude()
	var/isnude_p = P.is_nude()

	H.lastfucked = null
	H.lfhole = ""
	var/dat = "<META http-equiv='X-UA-Compatible' content='IE=edge' charset='UTF-8'><style type='text/css'> body {font-family: Times; cursor: url('http://lfwb.ru/Icons/pointer.cur'), auto;} a {text-decoration:none;outline: none;border: none;margin:-1px;} a:focus{outline:none;} a:hover {color:#0d0d0d;background:#505055;outline: none;border: none;} a.active { text-decoration:none; color:#533333;} a.inactive:hover {color:#0d0d0d;background:#bb0000} a.active:hover {color:#bb0000;background:#0f0f0f} a.inactive:hover { text-decoration:none; color:#0d0d0d; background:#bb0000}</style>"
	dat += "<body background bgColor=#0d0d0d text=#862525 alink=#777777 vlink=#777777 link=#777777>"
	dat += "<title>Interactions</title><B><HR><FONT size=3>INTERACTIONS - [H.partner]</FONT></B><BR><HR>"
	//var/ya = "&#1103;"

	//dat +=  {"• <A href='?src=\ref[usr];interaction=bow'>Bow.</A><BR>"}
	//if (Adjacent(P))
	//	dat +=  {"• <A href='?src=\ref[src];interaction=handshake'>Ïîïðèâåòñòâîâàòü.</A><BR>"}
	//else
	//	dat +=  {"• <A href='?src=\ref[src];interaction=wave'>Ïîïðèâåòñòâîâàòü.</A><BR>"}
	if (hashands)
		dat +=  {"<font size=3><B>Hands:</B></font><BR>"}
		//if (Adjacent(P))
		if(get_dist(H,P) <= 1)
			//dat +=  {"• <A href='?src=\ref[usr];interaction=handshake'>Give handshake.</A><BR>"}
			//dat +=  {"<A href='?src=\ref[usr];interaction=hug'>Hug!</A><BR>"}
			//dat +=  {"• <A href='?src=\ref[usr];interaction=cheer'>Cheer!</A><BR>"}
			//dat +=  {"• <A href='?src=\ref[usr];interaction=five'>Highfive.</A><BR>"}
			//if (hashands_p)
			//	dat +=  {"• <A href='?src=\ref[src];interaction=give'>Give.</A><BR>"}
			dat +=  {"<A href='?src=\ref[usr];interaction=slap'>Slap face!</A><BR>"}
			if (hasanus_p)
				dat += {"<A href='?src=\ref[usr];interaction=assslap'>Slap ass!</A><BR>"}
			if (isnude_p)
				if (hasvagina_p && (!P.mutilated_genitals))
					dat += {"<A href='?src=\ref[usr];interaction=fingering'>Put fingers in places.</A><BR>"}
				if(P.gender == FEMALE || P.isFemboy())
					dat += {"<A href='?src=\ref[usr];interaction=squeezebreast'>Squeeze breasts!</A><BR>"}
			//if (P.species.name == "Tajaran")
			//	dat +=  {"• <A href='?src=\ref[usr];interaction=pull'><font color=red>Pull big fluffy tail!</font></A><BR>"}
			//	if(P.can_inject(H, 1))
			//		dat +=  {"• <A href='?src=\ref[usr];interaction=pet'>Pet.</A><BR>"}
			//dat +=  {"• <A href='?src=\ref[usr];interaction=knock'><font color=red>Knock upside the head.</font></A><BR>"}
		//dat +=  {"• <A href='?src=\ref[usr];interaction=fuckyou'><font color=red>Insult.</font></A><BR>"}
		//dat +=  {"• <A href='?src=\ref[usr];interaction=threaten'><font color=red>Threaten.</font></A><BR>"}

	if (mouthfree && (lying == P.lying || !lying))
		dat += {"<font size=3><B>Mouth:</B></font><BR>"}
		dat += {"<A href='?src=\ref[usr];interaction=kiss'>Kiss.</A><BR>"}
		//if (Adjacent(P))
		if(get_dist(H,P) <= 1)
			//if (mouthfree_p)
			//	if (H.species.name == "Tajaran")
			//		dat += {"• <A href='?src=\ref[usr];interaction=lick'>Ëèçíóòü â ùåêó.</A><BR>"}
			if (isnude_p && (!P.mutilated_genitals))
				if (haspenis_p)
					dat += {"<A href='?src=\ref[usr];interaction=blowjob'>Suck cock.</A><BR>"}
					dat += {"<A href='?src=\ref[usr];interaction=handjob'>Masturbate.</A><BR>"}
					dat += {"<A href='?src=\ref[usr];interaction=ballsuck'>Suck balls.</A><BR>"}
				if (hasvagina_p)
					dat += {"<A href='?src=\ref[usr];interaction=vaglick'>Lick vagina.</A><BR>"}
			dat +=  {"<A href='?src=\ref[usr];interaction=spit'>Spit.</A><BR>"}
		//dat +=  {"• <A href='?src=\ref[usr];interaction=tongue'><font color=red>Stick out tongue.</font></A><BR>"}

	//if (isnude && usr.loc == H.partner.loc)
	if(isnude && get_dist(usr,H.partner) <= 1)
		if (haspenis && hashands)
			dat += {"<font size=3><B>Forbidden Fruits:</B></font><BR>"}
			if (isnude_p)
				if (hasvagina_p && (!P.mutilated_genitals))
					dat += {"<A href='?src=\ref[usr];interaction=vaginal'>Vaginal.</A><BR>"}
				if (hasanus_p)
					dat += {"<A href='?src=\ref[usr];interaction=anal'>Anal.</A><BR>"}
				if (mouthfree_p)
					dat += {"<A href='?src=\ref[usr];interaction=oral'>Oral.</A><BR>"}
	//if (isnude && usr.loc == H.partner.loc && hashands)
	if (isnude && get_dist(usr,H.partner) <= 1)
		if (hasvagina && haspenis_p && (!H.mutilated_genitals))
			dat += {"<font size=3><B>Vagina:</B></font><BR>"}
			dat += {"<A href='?src=\ref[usr];interaction=mount'>Mount</A><BR><HR>"}

	//var/datum/browser/popup = new(usr, "interactions", "Interactions", 340, 480)
	usr << browse(dat, "window=interactions;size=350x300;can_resize=0")
	//popup.set_content(dat)
	//popup.open()

//INTERACTIONS
/mob/living/carbon/human
	var/mob/living/carbon/human/partner
	var/mob/living/carbon/human/lastfucked
	var/lfhole
	var/potenzia = 10
	var/resistenza = 200
	var/lust = 0
	var/erpcooldown = 0
	var/multiorgasms = 0
	var/lastmoan
	var/mutilated_genitals = 0 //Whether or not they can do the fug.
	var/virgin = FALSE //:mistake:

/mob/living/carbon/human/proc/cum(mob/living/carbon/human/H as mob, mob/living/carbon/human/P as mob, var/hole = "floor")
	var/sound
	var/sound_path
	var/message = ""
	var/turf/T
	if(!H.HadSex.Find(P))
		H.HadSex.Add(P)
	if(!P.HadSex.Find(H))
		P.HadSex.Add(H)

	if(H.ConDom)
		H.ConDom.CameInto = TRUE
		H.ConDom.update_icon()

	if(P.ConDom)
		P.ConDom.CameInto = TRUE
		P.ConDom.update_icon()

	switch(H.gender)
		if(MALE)
			playsound(loc, "honk/sound/interactions/final_m[rand(1, 5)].ogg", 90, 0, -5)
		if(FEMALE)
			playsound(loc, "honk/sound/interactions/final_f[rand(1, 3)].ogg", 90, 0, -5)
	H.druggy = 30
	to_chat(H, "<span class='malfunction'>[pick("OH FUCK", "HOLY SHIT")]!</span>") //creativity
	P.druggy = 30
	if (has_penis())
		var/datum/reagent/blood/source = H.get_blood(H.vessel)
		if (P)
			T = get_turf(P)
		else
			T = get_turf(H)
		if (H.multiorgasms < H.potenzia)
			var/obj/effect/decal/cleanable/cum/C = new(T)
			C.add_fingerprint(H)
			// Update cum information.
			C.blood_DNA = list()
			if(source.data["blood_type"])
				C.blood_DNA[source.data["blood_DNA"]] = source.data["blood_type"]
			else
				C.blood_DNA[source.data["blood_DNA"]] = "O+"

		if (H.species.genitals)
			var/amt = rand(20,30)
			if(P.job)
				if(P.job == "Amuser" && !H.client.chromiesex && P.stat != DEAD)
					H.client.chromiesex = TRUE
					H.client.ChromieWinorLoose(H.client, 1)
					if(H.check_perk(/datum/perk/sexaddict))
						H.gainWP(1, 4)
					else
						H.gainWP(1, 2)
					if(P.check_perk(/datum/perk/sexaddict))
						H.gainWP(1, 2)
					else
						H.gainWP(1, 1)
			if (hole == "mouth" || H?.zone_sel?.selecting == "mouth")
				message = pick("cums right in [P]'s mouth.")
				P.reagents.add_reagent("semen", amt)
				sound_path = "honk/sound/new/ACTIONS/MOUTH/SWALLOW/"
				sound = pick(flist("[sound_path]"))
			else if (hole == "vagina")
				message = pick("cums in [P]'s pussy")
				if(!H.ConDom && !P.ConDom)
					if(P.gender == FEMALE && P.pregnant == FALSE && P.stat != DEAD && !P?.mind.succubus)
						if(prob(rand(35, 55)))
							P.pregnant = TRUE
							var/is_husband = FALSE
							if(P.mind && H.mind)
								for(var/datum/relation/family/R in P.mind.relations)
									if(R.relation_holder == H.mind && R.name == "Husband")
										P.client.ChromieWinorLoose(P.client, 1)
										P.add_event("pregnant", /datum/happiness_event/misc/pregnantgood)
										is_husband = TRUE
							if(!is_husband)
								P.add_event("pregnant", /datum/happiness_event/misc/pregnantbad)
								P.client.ChromieWinorLoose(P.client, -1)

			else if (hole == "anus")
				message = pick("cums in [P]'s asshole.")
			else if (hole == "floor")
				message = "cums on the floor!"

			sound_path = "honk/sound/new/ACTIONS/PENIS/CUM/"
			sound = pick(flist("[sound_path]"))
		else
			message = pick("cums!", "orgasms!")

		if(P.job == "Successor" && ticker.eof.id == "blessedflesh")
			H.client.ChromieWinorLoose(H.client, 1)
			H.my_stats.wp += pick(2,4)
			P.my_stats.wp += pick(1,2)
			H.my_stats.st += pick(9,10)
			H.my_stats.ht += pick(9,10)
			H.my_stats.dx += pick(9,10)
			H.my_stats.im += pick(10,12)

		if(H?.mind?.succubus)
			H.succubus_enslave(P)
			if(P.check_event(H.real_name))
				if(H.stat != DEAD)
					P.my_stats.st += 3
					P.my_stats.dx += 3
				P.clear_event("[H.real_name]")
		if(P?.mind?.succubus)
			P.succubus_enslave(H)
			if(H.check_event(P.real_name))
				if(P.stat != DEAD)
					H.my_stats.st += 3
					H.my_stats.dx += 3
				H.clear_event("[P.real_name]")
		H.visible_message("<span class='erpbold'>[H]</span> <span class='cumzone'>[message]</span>")
		if (istype(P.loc, /obj/structure/closet))
			P.visible_message("<span class='erpbold'>[H]</span> <span class='cumzone'>[message]</span>")
		H.lust = 5
		H.resistenza += 50
		orgasms += 1
		if(H.mind && P.mind)
			if((H.mind.husband || H.mind.wife) || (P.mind.wife || P.mind.husband))
				if(H.mind.husband != P.real_name || H.mind.wife != P.real_name || P.mind.wife != H.real_name || P.mind.husband != H.real_name)
					var/cucktest
					if(H.gender == MALE || H.isFemboy())
						cucktest = "<b>[H.real_name] </b> cucked <b>[H.mind.wife] </b> with <b>[P.real_name]</b>"
					else
						cucktest = "<b>[H.real_name] </b> cucked <b>[H.mind.husband] </b> with <b>[P.real_name]</b>"
					cuckoldlist.Add(cucktest)
		/*
		if(H.client.married != P.ckey || P.client.married != H.ckey)
			var/cucktest
			for(var/mob/living/carbon/human/HH in player_list)
				if(HH.ckey == H.client.married || HH.ckey == P.client.married)
					cucktest = "<b>[H.real_name] <i>(H.ckey)</i></b> cucked <b>[HH.real_name] <i>[HH.ckey]</i></b> with <b>[P.real_name] <i>([P.ckey])</i></b>"
					cuckoldlist.Add(cucktest)
		*/
	else
		message = pick("cums!")
		H.visible_message("<span class='erpbold'>[H]</span> <span class='cumzone'>[message].</span>")
		if (istype(P.loc, /obj/structure/closet))
			P.visible_message("<span class='erpbold'>[H]</span> <span class='cumzone'>[message].</span>")
		var/delta = pick(20, 30, 40, 50)
		switch(lust)
			if(0 to 150)
				sound_path = "honk/sound/new/ACTIONS/VAGINA/SQUIRT/SHORT/"
			if(150 to INFINITY)
				sound_path = "honk/sound/new/ACTIONS/VAGINA/SQUIRT/LONG/"
		sound = pick(flist("[sound_path]"))
		src.lust -= delta
		orgasms += 1

	H.multiorgasms += 1
	if (H.multiorgasms > H.potenzia / 3)
		if (H.stamina_loss < P.potenzia * 4)
			H.stamina_loss += H.potenzia * 0.5

	if(!(H.reagents.has_reagent("hero_drops")))
		if (H.stamina_loss > 100)
			H.erpcooldown = 600
		else
			H.erpcooldown = rand(200, 450)

	if(H.reagents.has_reagent("hero_drops"))
		lust = 0

	if(H.special == "dst")
		H.dst_completed += 1

	if(H.vice == "Necrophile")
		if(P.stat == DEAD)
			H.add_event("came", /datum/happiness_event/goodsex)
			H.viceneed = 0
		else
			H.add_event("came", /datum/happiness_event/badsex)
	else
		H.add_event("came", /datum/happiness_event/goodsex)
		if(H.vice == "Sexoholic")
			viceneed = 0
	H.clear_event("lustpadla")

	if(sound && sound_path)
		playsound(loc, "[sound_path][sound]", 90, 1, -5)

	for(var/mob/living/carbon/human/V in view(7))
		if(V != H || V != P)
			if(V.vice == "Voyeur")
				viceneed = 0

	times_came++

/mob/living/carbon/human/proc/fakecum() // for masturbate because 2 lazy to rewrite
	var/sound
	var/sound_path
	var/turf/T


	var/obj/item/weapon/reagent_containers/glass/G = locate() in src.loc

	if(G && !G.reagents.total_volume != G.reagents.maximum_volume)
		G.reagents.add_reagent("semen", 10)
		G.update_icon()
		src.visible_message("<span class='erpbold'>[src]</span> <span class='cumzone'>cums on the [G]!</span>")

	if(src.ConDom)
		src.ConDom.CameInto = TRUE
		src.ConDom.update_icon()
		src.visible_message("<span class='erpbold'>[src]</span> <span class='cumzone'>cums on the condom!</span>")

	else
		src.visible_message("<span class='erpbold'>[src]</span> <span class='cumzone'>cums on the floor!</span>")


	switch(src.gender)
		if(MALE)
			playsound(loc, "honk/sound/interactions/final_m[rand(1, 5)].ogg", 90, 0, -5)
		if(FEMALE)
			playsound(loc, "honk/sound/interactions/final_f[rand(1, 3)].ogg", 90, 0, -5)
	if (has_penis())
		var/datum/reagent/blood/source = src.get_blood(src.vessel)
		T = get_turf(src)
		if (src.multiorgasms < src.potenzia)
			var/obj/effect/decal/cleanable/cum/C = new(T)
			C.add_fingerprint(src)
			// Update cum information.
			C.blood_DNA = list()
			if(source.data["blood_type"])
				C.blood_DNA[source.data["blood_DNA"]] = source.data["blood_type"]
			else
				C.blood_DNA[source.data["blood_DNA"]] = "O+"

	if(istype(src.get_active_hand(), /obj/item/adultmag) || istype(src.get_other_hand(), /obj/item/adultmag))
		src.add_event("adultmag", /datum/happiness_event/magazinepleasure)
		if(src.vice == "Voyeur")
			viceneed = 0
	if(!(src.reagents.has_reagent("hero_drops")))
		if (src.stamina_loss > 100)
			src.erpcooldown = 600
		else
			src.erpcooldown = rand(200, 450)

	if(src.reagents.has_reagent("hero_drops"))
		lust = 0

	if(sound && sound_path)
		playsound(loc, "[sound_path][sound]", 90, 1, -5)

	times_came++

/mob/living/carbon/human/proc/fuck(mob/living/carbon/human/H as mob, mob/living/carbon/human/P as mob, var/hole)
	var/sound
	var/sound_path // hack for blowjob. Can be used elsewhere to have dynamic sound depending on message
	var/message = ""
	/*var/stun = round(potenzia / 3)*/
	if(!H.HadSex.Find(P))
		H.HadSex.Add(P)
	if(!P.HadSex.Find(H))
		P.HadSex.Add(H)
	H.adjustStaminaLoss(2)
	if(!H.ConDom && !P.ConDom)
		for(var/datum/disease/A in H.viruses)
			if(istype(A,/datum/disease/aids))
				P.contract_disease(new /datum/disease/aids,1,0)
		for(var/datum/disease/A in P.viruses)
			if(istype(A,/datum/disease/aids))
				H.contract_disease(new /datum/disease/aids,1,0)
	if(P.job == "Nun")
		H.custom_pain("[pick("<span class='hugepain'>OH [uppertext(god_text())] MY DICK!</span>", "<span class='hugepain'>OH [uppertext(god_text())] WHY!</span>", "<span class='hugepain'>OH [uppertext(god_text())] IT HURTS!</span>")]", 100)
		H.apply_damage(rand(50,70), BRUTE, BP_GROIN)
		playsound(H, 'sound/effects/gore/severed.ogg', 50, 1, -1)
		H.mutilate_genitals()
		H.client.ChromieWinorLoose(H.client, -1)

	switch(hole)

		if("vaglick")

			message = pick("licks [P].", "sucks [P]'s pussy.")

			if (H.lastfucked != P || H.lfhole != hole)
				H.lastfucked = P
				H.lfhole = hole

			if (prob(5) && P.stat != DEAD)
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
				P.lust += 10
			else
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				P.lust += 10
				if (P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan()
			if(prob(75))
				sound = pick(flist("honk/sound/new/ACTIONS/VAGINA/TOUCH/"))
				playsound(loc, ("honk/sound/new/ACTIONS/VAGINA/TOUCH/[sound]"), 90, 1, -5)
			else
				sound = pick(flist("honk/sound/new/ACTIONS/MOUTH/SALIVA/"))
				playsound(loc, ("honk/sound/new/ACTIONS/MOUTH/SALIVA/[sound]"), 90, 1, -5)

			H.do_fucking_animation(P)

		if("fingering")

			message = pick("fingers [P].", "fingers [P]'s pussy.")
			if (prob(35))
				message = pick("fingers [P] hard.")
			if (H.lastfucked != P || H.lfhole != hole)
				message = (" shoves their fingers into [P]'s pussy.")
				sound = ("honk/sound/new/ACTIONS/VAGINA/INSERTION/")
				playsound(loc, "honk/sound/new/ACTIONS/VAGINA/INSERTION/[sound]", 90, 1, -5)
				H.lastfucked = P
				H.lfhole = hole

			if (prob(5) && P.stat != DEAD)
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
				P.lust += 8
			else
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				P.lust += 8
				if (P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan()

			sound = pick(flist("honk/sound/new/ACTIONS/VAGINA/TOUCH/"))
			playsound(loc, ("honk/sound/new/ACTIONS/VAGINA/TOUCH/[sound]"), 90, 1, -5)
			H.do_fucking_animation(P)

		if("ballsuck")
			message = pick("sucks [P]'s balls.", "licks [P]'s nuts.")
			sound_path = ("honk/sound/new/ACTIONS/BLOWJOB/")
			if (prob(25))
				message = pick("twirls their tongue around [P]'s sack.")
				sound_path = "honk/sound/new/ACTIONS/MOUTH/SUCK/"
			sound = pick(flist("[sound_path]"))

			if (H.lust < 6)
				H.lust += 6

			if(prob(5))
				if(P.stat != DEAD)
					H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
					P.lust += 10
				else
					H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
			else
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")

			if(P.stat != DEAD)
				P.lust += 10
				if (P.lust >= P.resistenza)
					P.cum(P, H, "floor")
				else
					P.moan()

			H.do_fucking_animation(P)
			playsound(loc, ("[sound_path][sound]"), 90, 1, -5)
			if(prob(35))
				sound = pick(flist("honk/sound/new/ACTIONS/MOUTH/SALIVA/"))
				playsound(loc, ("honk/sound/new/ACTIONS/MOUTH/SALIVA/[sound]"), 90, 1, -5)

		if("blowjob")
			message = pick("sucks [P]'s dick.", "gives [P] head.")
			sound_path = ("honk/sound/new/ACTIONS/BLOWJOB/")
			if (prob(35))
				message = pick("sucks [P] off.")
				sound_path = "honk/sound/new/ACTIONS/MOUTH/SUCK/"
			sound = pick(flist("[sound_path]"))

			if (H.lust < 6)
				H.lust += 6

			if(prob(5))
				if(P.stat != DEAD)
					H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
					P.lust += 10
				else
					H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
			else
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")

			if(P.stat != DEAD)
				P.lust += 10
				if (P.lust >= P.resistenza)
					P.cum(P, H, "mouth")
				else
					P.moan()

			H.do_fucking_animation(P)
			playsound(loc, ("[sound_path][sound]"), 90, 1, -5)
			if(prob(35))
				sound = pick(flist("honk/sound/new/ACTIONS/MOUTH/SALIVA/"))
				playsound(loc, ("honk/sound/new/ACTIONS/MOUTH/SALIVA/[sound]"), 90, 1, -5)
			if (prob(P.potenzia))
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>goes in deep on</span> <span class='erpbold'>[P]</span><span class='erp'>.</span>")

		if("handjob")
			message = pick("strokes [P]'s dick.", "masturbate [P]'s penis.")
			if (H.lust < 6)
				H.lust += 6

			if(prob(5))
				if(P.stat != DEAD)
					H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
					P.lust += 10
				else
					H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
			else
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")

			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				P.lust += 8
				if (P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan()
			if(prob(50))
				sound = pick(flist("honk/sound/new/ACTIONS/PENIS/HANDJOB/"))
				playsound(loc, "honk/sound/new/ACTIONS/PENIS/HANDJOB/[sound]", 90, 1, -5)
			H.do_fucking_animation(P)
			if (prob(P.potenzia))
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>strokes</span> <B>[P]'s </span><span class='erp'> [pick("cock","dick","penis")] faster.</span>")

		if("vaginal")
			message = pick("fucks [P].", "pounds [P]'s pussy.")

			if (H.lastfucked != P || H.lfhole != hole)
				message = pick(" shoves their dick into [P]'s pussy.")
				sound = pick(flist("honk/sound/new/ACTIONS/VAGINA/INSERTION/"))
				playsound(loc, "honk/sound/new/ACTIONS/VAGINA/INSERTION/[sound]", 90, 1, -5)
				H.lastfucked = P
				H.lfhole = hole

			if(P.virgin)
				P.virgin = FALSE
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>pop's</span> <span class='erpbold'>[P]'s</span> <span class='erp'>cherry.</span>")
				H.gainWP(1, 1)
			if (prob(5) && P.stat != DEAD)
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
				P.lust += H.get_pleasure_amt("vaginal-2")
			else
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
				playsound(P.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
			H.lust += 10
			if (H.lust >= H.resistenza)
				H.cum(H, P, "vagina")

			if (P.stat != DEAD)
				P.lust += H.get_pleasure_amt("vaginal")
				/*if (H.potenzia > 20)
					P.stamina_loss += H.potenzia * 0.10*/
				if (P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan(H.potenzia)
			H.do_fucking_animation(P)
			if(prob(75))
				sound = pick(flist("honk/sound/new/ACTIONS/PENETRATION/"))
				playsound(loc, "honk/sound/new/ACTIONS/PENETRATION/[sound]", 90, 1, -5)
			else
				sound = pick(flist("honk/sound/new/ACTIONS/BODY/COLLIDE/NAKED/"))
				playsound(loc, "honk/sound/new/ACTIONS/BODY/COLLIDE/NAKED/[sound]", 90, 1, -5)

/*		if("mount")
			message = pick("fucks [P]'s dick", "rides [P]'s dick", "rides [P]")

			if (H.lastfucked != P || H.lfhole != hole)
				message = pick("begins to hop on [P]'s dick")
				H.lastfucked = P
				H.lfhole = hole

			if(H.virgin)
				H.virgin = FALSE
				H.visible_message("<span class='erpbold'>[P]</span> <span class='erp'>pop's</span> <span class='erpbold'>[H]'s</span> <span class='erp'>cherry.</span>")

			if (prob(5))
				if(P.stat != DEAD)
					H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
					P.lust += H.potenzia * 2
			else
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
			H.lust += P.potenzia
			if (P.potenzia > 20)
				H.stamina_loss += P.potenzia * 0.25
			if (H.lust >= H.resistenza)
				H.cum(H, P)
			else
				H.moan()
/*
			if (P.stat != DEAD)
				P.lust += H.get_pleasure_amt("vaginal")
				if (H.potenzia > 20)
					P.stamina_loss += H.potenzia * 0.25
				if (P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan()*/
			H.do_fucking_animation(P)
			playsound(loc, "honk/sound/interactions/bang[rand(1, 3)].ogg", 70, 1, -1)
*/

		if("mount")
			message = pick("fucks [P]'s dick", "rides [P]'s dick", "rides [P]")

			/*if(potenzia >= 30)
				P.Weaken(stun * 1.5)*/
			if (H.lastfucked != P || H.lfhole != hole)
				message = pick("begins to hop on [P]'s dick")//"îñòîðîæíî íàñàæèâàåòñ[ya] íà ïîëîâîé îðãàí [P]")
				H.lastfucked = P
				H.lfhole = hole
				//add_logs(P, H, "fucked")

			if(H.virgin)
				H.virgin = FALSE
				H.visible_message("<span class='erpbold'>[P]</span> <span class='erp'>pop's</span> <span class='erpbold'>[H]'s</span> <span class='erp'>cherry.</span>")

			if (prob(5))
				if(P.stat != DEAD)
					H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message].</span>")
					P.lust += H.potenzia * 2
			else
				H.visible_message("<span class='erpbold'>[H] [message].</span>")

			H.lust += P.potenzia
			/*if (P.potenzia > 20)
				H.stamina_loss += P.potenzia * 0.10*/
			if (H.lust >= H.resistenza)
				H.cum(H, P, "vagina")
			else
				H.moan(P.potenzia)
			if (P.stat != DEAD)
				P.lust += H.get_pleasure_amt("vaginal")
				if (P.lust >= P.resistenza)
					P.cum(P, H, "vagina")
				else
					P.moan(P.potenzia)
			H.do_fucking_animation(P)
			if(prob(75))
				sound = pick(flist("honk/sound/new/ACTIONS/PENETRATION/"))
				playsound(loc, "honk/sound/new/ACTIONS/PENETRATION/[sound]", 90, 1, -5)
			else
				sound = pick(flist("honk/sound/new/ACTIONS/BODY/COLLIDE/NAKED/"))
				playsound(loc, "honk/sound/new/ACTIONS/BODY/COLLIDE/NAKED/[sound]", 90, 1, -5)
		if("anal")

			message = pick("fucks [P]'s ass.")

			if (H.lastfucked != P || H.lfhole != hole)
				message = pick(" shoves their dick into [P]'s asshole.")
				H.lastfucked = P
				H.lfhole = hole

			/*if(potenzia >= 30)
				P.Weaken(stun * 1.5)*/
			if (prob(5) && P.stat != DEAD)
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
				P.lust += H.get_pleasure_amt("anal-2")
			else
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message]</span>")
				playsound(P.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
			H.lust += 12
			if (H.lust >= H.resistenza)
				H.cum(H, P, "anus")
			else
				P.moan(H.potenzia)

			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				/*if (H.potenzia > 20)
					P.stamina_loss += H.potenzia * 0.10*/
				P.lust += H.get_pleasure_amt("anal")
				if (P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan(H.potenzia)
			H.do_fucking_animation(P)
			sound = pick(flist("honk/sound/new/ACTIONS/BODY/COLLIDE/NAKED/"))
			playsound(loc, "honk/sound/new/ACTIONS/BODY/COLLIDE/NAKED/[sound]", 90, 1, -5)

		if("oral")
			message = pick(" fucks [P]'s mouth.")
			if (prob(35))
				message = pick(" sucks [P]'s [P.has_penis() ? "dick" : "vag"]..", " licks [P]'s [P.has_penis() ? "dick" : "vag"]..")
			if (H.lastfucked != P || H.lfhole != hole)
				message = pick(" shoves their dick down [P]'s throat.")
				H.lastfucked = P
				H.lfhole = hole

			if (prob(5) && H.stat != DEAD)
				H.visible_message("<span class='erpbold'>[H]</span><span class='erp'>[message]</span>")
				H.lust += 15
			else
				H.visible_message("<span class='erpbold'>[H]</span><span class='erp'>[message]</span>")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<span class='erpbold'>[H]</span><span class='erp'>[message]</span>")
				playsound(P.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
			H.lust += 15
			if (H.lust >= H.resistenza)
				H.cum(H, P, "mouth")

			if (prob(H.potenzia))
				P.stamina_loss += 3
				sound_path = "honk/sound/new/ACTIONS/MOUTH/SWALLOW/"
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>fucks</span> <span class='erpbold'>[P]'s</span> <span class='erp'>throat.</span>")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>fucks</span> <span class='erpbold'>[P]'s</span> <span class='erp'>throat.</span>")
			else
				sound_path = "honk/sound/new/ACTIONS/BLOWJOB/"
			sound = pick(flist("[sound_path]"))
			playsound(loc, "[sound_path][sound]", 90, 1, -5)
			H.do_fucking_animation(P)


/mob/living/carbon/human/proc/moan(var/size = 0)

	var/mob/living/carbon/human/H = src
	if (species.name == "Human" || H.isFemboy())
		if (prob(H.lust / H.resistenza * 65))
			var/message = pick("moans", "moans in pleasure",)
			H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[message].</span:")
			var/g = H.gender == FEMALE ? "f" : "m"
			var/moan = rand(1, 7)
			if (moan == lastmoan)
				moan--
			if(g == "m")
				playsound(loc, "honk/sound/interactions/moan_[g][moan].ogg", 90, 0, -5)
			else if (g == "f")
				var/sound_path
				var/sound
				if(H.job == "Amuser")
					sound_path = "honk/sound/amuser"
					sound = pick(flist("[sound_path]"))
					playsound(loc, "[sound_path][sound]", 90, 0, -5)
				else
					switch(size)
						if(-INFINITY to 11)
							sound_path = "honk/sound/new/Moans/mild/"
						if(12 to 20)
							sound_path = "honk/sound/new/Moans/medium/"
						if(21 to INFINITY)
							sound_path = "honk/sound/new/Moans/hot/"
					sound = pick(flist("[sound_path]"))
					playsound(loc, "[sound_path][sound]", 90, 0, -5)

			lastmoan = moan


/mob/living/carbon/human/proc/handle_lust()
	lust -= 4
	if (lust <= 0)
		lust = 0
		lastfucked = null
		lfhole = ""
		multiorgasms = 0
	if (lust == 0)
		erpcooldown -= 1
	if (erpcooldown < 0)
		erpcooldown = 0

/mob/living/carbon/human/proc/do_fucking_animation(mob/living/carbon/human/P)
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/final_pixel_y = initial(pixel_y)

	var/direction = get_dir(src, P)
	if(direction & NORTH)
		pixel_y_diff = 8
	else if(direction & SOUTH)
		pixel_y_diff = -8

	if(direction & EAST)
		pixel_x_diff = 8
	else if(direction & WEST)
		pixel_x_diff = -8

	if(pixel_x_diff == 0 && pixel_y_diff == 0)
		pixel_x_diff = rand(-3,3)
		pixel_y_diff = rand(-3,3)
		animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
		animate(pixel_x = initial(pixel_x), pixel_y = initial(pixel_y), time = 2)
		return

	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
	animate(pixel_x = initial(pixel_x), pixel_y = final_pixel_y, time = 2)

/obj/item/weapon/dildo
	name = "dildo"
	desc = "Hmmm, deal throw"
	icon = 'honk/icons/obj/items/dildo.dmi'
	icon_state = "dildo"
	item_state = "c_tube"
	throwforce = 0
	force = 10
	force_wielded = 12
	force_unwielded = 10
	w_class = 1
	throw_speed = 3
	throw_range = 15
	attack_verb = list("slammed", "bashed", "whipped")
	var/hole = "vagina"
	var/pleasure = 10

/obj/item/weapon/dildo/copper
	name = "copper dildo"
	desc = "Hmmm, deal throw"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "dildo_copper0"
	item_state = "c_tube"
	throwforce = 0
	force = 10
	w_class = 1
	throw_speed = 3
	throw_range = 15
	attack_verb = list("slammed", "bashed", "whipped")
	hole = "vagina"
	pleasure = 7
	can_be_smelted_to = /obj/item/weapon/ore/refined/lw/copperlw

/obj/item/weapon/dildo/goldeb
	name = "golden dildo"
	desc = "Hmmm, deal throw"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "dildo_gold"
	item_state = "c_tube"
	throwforce = 0
	force = 10
	w_class = 1
	throw_speed = 3
	throw_range = 15
	attack_verb = list("slammed", "bashed", "whipped")
	hole = "vagina"
	pleasure = 15

/obj/item/weapon/dildo/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	var/hasvagina = (M.gender == FEMALE && M.species.genitals && M.species.name != "Unathi" && M.species.name != "Stok" && !M.has_penis())
	var/hasanus = M.species.anus
	var/message = ""
	if(M.isChild() || user.isChild())
		return
	if(istype(M, /mob/living/carbon/human) && user.zone_sel.selecting == "groin" && M.is_nude())
		if (hole == "vagina" && hasvagina)
			if (user == M)
				message = pick("fucks their own pussy")//, "çàòàëêèâàåò â ñåá[ya] [rus_name]", "ïîãðóæàåò [rus_name] â ñâîå ëîíî")
			else
				message = pick("fucks [M] right in the pussy with the dildo", "jams it right into [M]")//, "çàòàëêèâàåò â [M] [rus_name]", "ïîãðóæàåò [rus_name] â ëîíî [M]")

			if (prob(5) && M.stat != DEAD && M.stat != UNCONSCIOUS)
				user.visible_message("<span class='erpbold'>[user]</span> <span class='erp'>[message].</span>")
				M.lust += pleasure * 2

			else if (M.stat != DEAD && M.stat != UNCONSCIOUS)
				user.visible_message("<span class='erpbold'>[user]</span> <span class='erp'>[message].</span>")
				M.lust += pleasure

			if (M.lust >= M.resistenza)
				M.cum(M, user, "floor")
			else
				M.moan()

			user.do_fucking_animation(M)
			playsound(loc, "honk/sound/interactions/bang[rand(4, 6)].ogg", 90, 0, -5)

		else if (hole == "anus" && hasanus)
			if (user == M)
				message = pick("fucks their ass")
			else
				message = pick("fucks [M]'s asshole")

			if (prob(5) && M.stat != DEAD && M.stat != UNCONSCIOUS)
				user.visible_message("<span class='erpbold'>[user]</span> <span class='erp'>[message].</span>")
				M.lust += pleasure * 2

			else if (M.stat != DEAD && M.stat != UNCONSCIOUS)
				user.visible_message("<span class='erpbold'>[user]</span> <span class='erp'>[message].</span>")
				M.lust += pleasure

			if (M.lust >= M.resistenza)
				M.cum(M, user, "floor")
			else
				M.moan()

			user.do_fucking_animation(M)

			var/sound = pick(flist("honk/sound/new/ACTIONS/PENETRATION/"))
			playsound(loc, "honk/sound/new/ACTIONS/PENETRATION/[sound]", 90, 1, -5)

		else
			..()
	else
		..()

/obj/item/weapon/dildo/attack_self(mob/user as mob)
	if(hole == "vagina")
		hole = "anus"
	else
		hole = "vagina"
	to_chat(usr, "<span class='erp'>Hmmm. Maybe we should put it in [hole]?!</span>")

/obj/item/adultmag
	name = "adult magazine"
	desc = "Not safe for work."
	icon = 'icons/life/LFWB_USEFUL.dmi'
	icon_state = "mag1"
	w_class = 2
	var/list/thoughts = list("Oh.","Oh?","Like that?","How...?","Interesting...","Wow.","Huh.","Nice...","Nice.")
	var/list/childthoughts = list("WHAT?!","WOAH!","UHH...","WH-...","I SHOULDN'T LOOK AT THIS!","EW!","GROSS!","NOPE!","WHAT IS THIS?!")

/obj/item/adultmag/one
	name = "SCREW & CHIC"
	desc = "An adult tabloid for the working man."
	icon_state = "mag1"

/obj/item/adultmag/two
	name = "Mazokhist"
	desc = "A mature magazine written by a support group for masochists."
	icon_state = "mag2"

/obj/item/adultmag/three
	name = "Exposed Skin"
	desc = "Not safe for work."
	icon_state = "mag3"

/obj/item/adultmag/attack_self(mob/living/carbon/human/user)
	playsound(src.loc, pick('sound/webbers/paper_up1.ogg', 'sound/webbers/paper_up2.ogg', 'sound/webbers/paper_up3.ogg'), 100, 0)
	if(user.isChild())
		to_chat(user, "<span class='combatbold'>[pick(src.childthoughts)]</span>")
		user.rotate_plane()
	else
		to_chat(user, "<span class='passivebold'>[pick(src.thoughts)]</span>")
		user.resistenza += 5


#undef CONDOM_NONE
#undef CONDOM_SMALL
#undef CONDOM_REGULAR
#undef CONDOM_BIG
