/obj/machinery/computer/incarn
	name = "Register Computer"
	icon_state = "migrant"
	density = 1
	anchored = 1


/obj/machinery/computer/incarn/attackby(obj/item/I as obj, mob/living/carbon/human/user as mob)
	if(istype(I,/obj/item/incarn_register))
		var/inputado = input("Write their job down!","[src.name]") as null|text
		if(!inputado)
			return
		var/obj/item/incarn_register/O = I
		var/obj/item/weapon/card/id/migrant/NG = new (src.loc)
		NG.registered_name = O.person_name
		NG.assignment = inputado
		NG.rank = inputado
		NG.money_account = new /datum/ring_account
		NG.money_account.set_account(O.owner, NG.registered_name, NG.assignment, -15) //You need to pay for your clothe, migger...
		rings_account[NG] = NG.money_account
		playsound(src, 'sound/machines/warning-buzzer.ogg', 50, 0, 0)
		for(var/obj/structure/disposaloutlet/OUTLET in range(5, src))
			var/turf/turfloc = get_step(OUTLET,OUTLET.dir)
			var/obj/item/documents/DOC = new (turfloc)
			new /obj/item/clothing/shoes/lw/ravshoes(turfloc)
			new /obj/item/clothing/suit/storage/firethorner(turfloc)
			DOC.name = "[O.person_name]'s Documents"
			DOC.desc = "[O.person_name], [O.person_age] [O.person_gender], assigned as a [inputado], Registered by [user.real_name]"
			DOC.SHOWDESC = "[O.person_name], [O.person_age] [O.person_gender], assigned as a [inputado], Registered by [user.real_name]"
		qdel(O)

/obj/machinery/computer/incarn_button
	name = "button"
	desc = "Use this to register in the fortress."
	density = 0
	anchored = 1
	icon_state = "migreceiver"

/obj/machinery/computer/merchant_button
	name = "button"
	desc = "Use this to ring."
	density = 0
	anchored = 1
	icon_state = "migreceiver"

/obj/machinery/computer/merchant_button/attack_hand(mob/living/carbon/human/H as mob)
	playsound(src, 'sound/webbers/phone_ring.ogg', 76, 0, 0)

/obj/machinery/computer/incarn_button/attack_hand(mob/living/carbon/human/H as mob)
	if(H.incarn_registered)
		return
	H.incarn_registered = TRUE
	for(var/obj/machinery/computer/incarn/INC in range(4, src))
		var/obj/item/incarn_register/NG = new (INC.loc)
		NG.name = "[H.real_name] Documents"
		NG.person_name = H.real_name
		NG.person_age = H.age
		NG.person_gender = H.gender == FEMALE && H.has_penis() ? MALE : H.gender
		NG.desc = "[H.real_name], [H.age] [NG.person_gender]"
		NG.owner = H
		migrantsarrived += 1

/obj/item/incarn_register
	icon = 'icons/obj/personal.dmi'
	icon_state = "file"
	w_class = 1.0
	name = "files"
	desc = "All documents of a person."
	var/person_name
	var/person_age
	var/person_gender
	var/mob/living/carbon/human/owner


/obj/item/documents
	icon = 'icons/obj/personal.dmi'
	icon_state = "documents"
	w_class = 1.0
	name = "document"
	desc = ""
	neck_use = 1
	var/SHOWDESC = null
	attack_self(mob/living/user as mob)
		if(!isliving(user))
			return
		src.visible_message("<span class='examinebold'>[usr]</span><span class='examine'> shows \his documents.</span>")
		src.visible_message("<span class='examine'>[SHOWDESC]</span>")