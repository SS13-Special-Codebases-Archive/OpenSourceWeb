/obj/machinery/organ_seller
	name = "Organ Seller Machine"
	desc = ""
	icon = 'icons/obj/terminals.dmi'
	icon_state = "cs_db"
	density = 1
	anchored = 1


/obj/machinery/organ_seller/attackby(var/obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/organ))
		var/obj/item/weapon/reagent_containers/food/snacks/organ/P = I
		if(P.organ_data.damage)
			src.visible_message("<span class ='passivebold'>[P]</span> <span class='passive'>is too damaged!</span>", 1)
			return
		//spawn_money(P.item_worth,user.loc)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			var/obj/item/weapon/card/id/idcard = H.wear_id
			if(H.wear_id)
				idcard.receivePayment(P.item_worth)
				treasuryworth.add_money(P.item_worth)
		src.visible_message("<span class ='passivebold'>[user]</span> <span class='passive'>inserts [P] in the [src]!</span>", 1)
		playsound(src.loc, 'sound/lfwbsounds/flesh_drop.ogg', 30, 0)
		qdel(P)
		playsound(src.loc, 'sound/lfwbsounds/console_success.ogg', 30, 0)

/obj/machinery/bountymachine
	name = "Bounty Machine"
	desc = ""
	icon = 'icons/obj/terminals.dmi'
	icon_state = "receiverorgan"
	density = 1
	anchored = 1


/obj/machinery/bountymachine/attackby(var/obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/organ/head))
		var/obj/item/weapon/organ/head/P = I
		src.visible_message("<span class ='passivebold'>[user]</span> <span class='passive'>inserts [P] in the [src]!</span>", 1)
		playsound(src.loc, 'sound/lfwbsounds/flesh_drop.ogg', 30, 0)
		qdel(P)
		playsound(src.loc, 'sound/lfwbsounds/console_success.ogg', 30, 0)
		user.client.ChromieWinorLoose(user.client, 1)