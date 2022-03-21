/mob/living/carbon/proc/give()
	set category = "IC"
	set name = "Give"
	set src in view(1)
	if(src.stat == 2 || usr.stat == 2 )
		return
	if(src == usr)
		usr << "\red I feel stupider, suddenly."
		return
	var/obj/item/I
	if(!usr.hand && usr.r_hand == null)
		usr << "\red You don't have anything in your right hand to give to [src.name]"
		return
	if(usr.hand && usr.l_hand == null)
		usr << "\red You don't have anything in your left hand to give to [src.name]"
		return
	if(usr.hand)
		I = usr.l_hand
	else if(!usr.hand)
		I = usr.r_hand
	if(!I)
		return
	if(src.r_hand == null || src.l_hand == null)
		if(!src.combat_mode)
			if(!I)
				return
			if(!Adjacent(usr))
				to_chat(usr, "\red You need to stay in reaching distance while giving an object.")
				to_chat(src, "\red [usr.name] moved too far away.")
				return
			if((usr.hand && usr.l_hand != I) || (!usr.hand && usr.r_hand != I))
				to_chat(usr, "\red You need to keep the item in your active hand.")
				to_chat(src, "\red [usr.name] seem to have given up on giving \the [I.name] to you.")
				return
			if(src.r_hand != null && src.l_hand != null)
				to_chat(src, "\red Your hands are full.")
				to_chat(usr, "\red Their hands are full.")
				return
			else
				usr.drop_item()
				if(src.r_hand == null)
					src.r_hand = I
				else
					src.l_hand = I
			I.dropped(usr)
			I.pickup(src)
			I.loc = src
			I.layer = 20
			I.plane = 30
			I.appearance_flags |= NO_CLIENT_COLOR
			I.add_fingerprint(src)
			src.update_inv_l_hand()
			src.update_inv_r_hand()
			usr.update_inv_l_hand()
			usr.update_inv_r_hand()
			if(istype(I, /obj/item/weapon/storage/delivery_box) && ishuman(usr))
				var/obj/item/weapon/storage/delivery_box/DB = I
				if(!DB.delivered && DB.owner == src)
					DB.delivered = TRUE
					var/mob/living/carbon/human/H = usr
					if(H.job == "Courier")
						var/client/C = H.client
						C.ChromieWinorLoose(H, 1)
			var/mob/living/carbon/human/H = src
			var/obj/item/S = I
			var/vamp_hand = H.l_hand ? "l_hand" : "r_hand"
			if(H.isVampire && S.silver)
				if(!H.gloves)
					to_chat(H, pick("<span class='combatglow'><b>GET THIS OUT OF HERE!</b></span>", "<span class='combatglow'><b>ACCURSED SILVER!</b></span>", "<span class='combatglow'><b>IT BURNS! IT BURNS!</b></span>"))
					H.drop_from_inventory(S)
					H.apply_damage(rand(5, 10), BRUTE, vamp_hand)
					H.flash_pain()
					H.rotate_plane(1)
			src.visible_message("\blue [usr.name] handed \the [I.name] to [src.name].")
		else
			src.visible_message("\red [usr.name] tried to hand [I.name] to [src.name] but [src.name] didn't want it.")
	else
		to_chat(usr, "\red [src.name]'s hands are full.")
