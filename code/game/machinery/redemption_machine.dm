/obj/machinery/redemption_machine
	name = "General Redemption Machine"
	desc = "Used to sell... Things"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "heretic"

/obj/machinery/redemption_machine/attackby(var/obj/item/O as obj, var/mob/living/carbon/human/H as mob)
	if(O.item_worth)
		var/obj/item/weapon/card/id/idcard = H.wear_id
		if(H.wear_id)
			idcard.receivePayment(O.item_worth/rand(2,3))
			treasuryworth.add_money(O.item_worth)
			src.visible_message("<span class ='passivebold'>[H]</span> <span class='passive'>inserts [O] in the [src]!</span>", 1)
			qdel(O)
			playsound(src.loc, 'sound/lfwbsounds/console_success.ogg', 30, 0)
		else
			to_chat(H, "I need a ring.")
	else
		to_chat(H, "This item is not valuable anything")

/obj/machinery/redemption_machine/ore
	desc = "Used to sell ores."

/obj/machinery/redemption_machine/ore/attackby(var/obj/item/O as obj, var/mob/living/carbon/human/H as mob)
	if(O.item_worth)
		var/obj/item/weapon/card/id/idcard = H.wear_id
		if(H.wear_id)
			istype(O, /obj/item/weapon/ore) ? idcard.receivePayment(O.item_worth/rand(1,2)) : idcard.receivePayment(O.item_worth/rand(2,3))
			treasuryworth.add_money(O.item_worth)
			src.visible_message("<span class ='passivebold'>[H]</span> <span class='passive'>inserts [O] in the [src]!</span>", 1)
			qdel(O)
			playsound(src.loc, 'sound/lfwbsounds/console_success.ogg', 30, 0)
		else
			to_chat(H, "I need a ring.")
	else
		to_chat(H, "This item is not valuable anything")