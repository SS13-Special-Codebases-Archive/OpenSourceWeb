/obj/item/weapon/flame/candle
	name = "candle"
	desc = "a candle"
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	item_state = "candle1"
	w_class = 1

	r_range = 2
	f_force = 1
	c_color = "#E38F46"

	hand_on = "candle1"
	hand_off = "candle0"

	state_on = "candle1_lit"
	state_off = "candle1"

	var/wax = 1000

/obj/item/weapon/flame/candle/Lighted/New()
	turn_on()
	update_icon()

/obj/item/weapon/flame/candle/update_icon()
	var/i
	if(wax>150)
		i = 1
	else if(wax>80)
		i = 2
	else i = 3

	state_on = "candle[i]_lit"
	state_off= "candle[i]"
	icon_state = "candle[i][lit ? "_lit" : ""]"
	item_state = "candle[lit ? "1" : "0"]"


/obj/item/weapon/flame/candle/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/flame))
		var/obj/item/weapon/flame/F = W
		if(F.lit && !src.lit)
			src.turn_on()
			user.visible_message("<span class='goodlight'>[user] enlights the [src].")
		if(src.lit && !F.lit)
			F.turn_on()
			user.visible_message("<span class='goodlight'>[user] enlights the [F].")

/obj/item/weapon/flame/candle/tnt
	name = "TNT Dummy"
	wax = 10000
	w_class = 3

/obj/item/weapon/flame/candle/tnt/process()
	playsound(src, 'sound/effects/tnt_fuse_loop.ogg', 50, 1)

/obj/item/weapon/flame/candle/tnt/stick/update_icon()
	icon_state = "tnt_stick[lit ? "1" : "0"]"
	item_state = "tnt_stick[lit ? "1" : "0"]"
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		H.update_inv_l_hand()
		H.update_inv_r_hand()

/obj/item/weapon/flame/candle/tnt/stick
	name = "TNT Stick"
	icon_state = "tnt_stick0"
	item_state = "tnt_stick0"

/obj/item/weapon/flame/candle/tnt/stick/turn_on()
	..()
	playsound(src, 'sound/effects/tnt_fuse_light.ogg', 50, 1)
	update_icon()
	spawn(50)
		if(lit)
			var/turf/epicenter = src.loc
			explosion(epicenter, 1, 2, 2, 2)

/obj/item/weapon/flame/candle/tnt/bundle/update_icon()
	icon_state = "tnt_bundle[lit ? "1" : "0"]"
	item_state = "tnt_bundle[lit ? "1" : "0"]"
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		H.update_inv_l_hand()
		H.update_inv_r_hand()

/obj/item/weapon/flame/candle/tnt/bundle
	name = "TNT Bundle"
	icon_state = "tnt_bundle0"
	item_state = "tnt_bundle0"

/obj/item/weapon/flame/candle/tnt/bundle/turn_on()
	..()
	var/turf/bombturf = get_turf(src)
	var/area/A = get_area(bombturf)
	if(istype(A, /area/dunwell/trainpath))
		return
	playsound(src, 'sound/effects/tnt_fuse_light.ogg', 50, 1)
	update_icon()
	spawn(100)
		if(lit)
			var/turf/epicenter = src.loc
			explosion(epicenter, 2, 4, 6, 4)

/obj/item/weapon/flame/candle/turn_on()
	processing_objects.Add(src)
	..()

/obj/item/weapon/flame/candle/process()
	if(!lit)
		return
	wax--
	if(!wax)
		new/obj/item/trash/candle(src.loc)
		if(istype(src.loc, /mob))
			src.dropped()
		qdel(src)
	update_icon()
	if(istype(loc, /turf)) //start a fire if possible
		var/turf/T = loc
		T.hotspot_expose(700, 5)