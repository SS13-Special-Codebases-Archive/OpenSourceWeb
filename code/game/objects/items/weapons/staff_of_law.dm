/obj/item/weapon/staffoflaw
	name = "scepter of law"
	desc = "It feels good to rule."
	icon_state = "law"
	item_state = "lever"
	blooded_icon = TRUE
	blood_suffix = "b"
	silver = TRUE
	blunt = TRUE
	force = 22
	hitsound= 'sound/weapons/club.ogg'
	w_class = 2.0
	weapon_speed_delay = 12

/obj/item/weapon/staffoflaw/afterattack(atom/A as mob|obj|turf|area, mob/living/user as mob|obj, flag)
	if(istype(user.get_active_hand(), /obj/item/weapon/staffoflaw))
		if(istype(A, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = A
			if(istype(H.head, /obj/item/clothing/head/helmet/sechelm))
				var/obj/item/clothing/head/helmet/HH = H.head
				if(HH.shockable)
					H.electrocute_act(20, src, 1, 0, 1)
					H.emote("agonyscream",1, null, 0)
					H.Stun(3)
					H.Weaken(3)
					user.next_move = world.time + 15

/obj/item/weapon/staffoflaw/zeus

/obj/item/weapon/staffoflaw/zeus/afterattack(atom/A as mob|obj|turf|area, mob/living/user as mob|obj, flag)
	if(istype(user.get_active_hand(), /obj/item/weapon/staffoflaw/zeus))
		if(istype(A, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = A
			if(H.wear_id)
				H.electrocute_act(20, src, 1, 0, 1)
				H.emote("agonyscream",1, null, 0)
				H.Stun(3)
				H.Weaken(3)
				user.next_move = world.time + 15