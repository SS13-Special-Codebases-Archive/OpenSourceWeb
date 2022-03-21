//TORCH
/obj/item/weapon/flame/torch
	name = "torch"
	desc = "A hand-made torch."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "torch"
	item_state = "torch0"
	drop_sound = 'wooden_drop.ogg'

	hand_on = "torch1"
	hand_off = "torch0"

	state_on = "torch-on"
	state_off = "torch"

	var/canfade = 1

	force = 11
	force_wielded = 13
	parry_chance = 5
	w_class = 4
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	can_be_smelted_to = null

/obj/item/weapon/flame/torch/New()
	..()
	processing_objects.Add(src)

/obj/item/weapon/flame/torch/Destroy()
	..()
	processing_objects.Remove(src)

/obj/item/weapon/flame/torch/on/New()
	..()
	turn_on()

/obj/item/weapon/flame/torch/lantern
	name = "lantern"
	desc = "May god protect us from darkness."
	icon_state = "lantern"
	item_state = "lamp0"

	hand_on = "lamp1"
	hand_off = "lamp0"

	state_on = "lantern-on"
	state_off = "lantern"

/obj/item/weapon/flame/torch/lantern/on/New()
	..()
	canfade = 0
	turn_on()

/obj/item/weapon/flame/torch/process()

	if(!lit)
		return

	if(istype(src.loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src.loc
		if(H.isVampire)
			H.rotate_plane(1)
			to_chat(H, pick("<span class='combatglow'><b>GET THIS OUT OF HERE!</b></span>", "<span class='combatglow'><b>FIRE FIRE FIRE!</b></span>", "<span class='combatglow'><b>AAAAAAAAAAAAAAAAAAAAAAAAH!</b></span>"))
		if(lit)
			if(prob(1) && prob(50) && prob(50) && canfade)
				turn_off()
				to_chat(H, "A rush of wind puts off my torch. Cursed be!")

	playsound(src, 'sound/effects/torch_small.ogg', 15, channel=26, wait=1, repeat=0)


/obj/item/weapon/flame/torch/turn_off()
	playsound(src.loc, 'torch_snuff.ogg', 50, 0)
	playsound(src, null, 0, channel=26, wait=0, repeat=0)
	..()

/obj/item/weapon/flame/torch/turn_on()
	playsound(src.loc, 'torch_light.ogg', 50, 0)
	..()

/obj/item/weapon/flame/torch/dropped(var/mob/user)
	if(!lit) return
	if(!canfade) return

	if(prob(rand(3, 7)))
		turn_off()

	if(prob(rand(3, 15)))
		for(var/atom/A in loc.contents)
			if(!A.flammable) continue
			new /obj/structure/fire(loc)

/obj/item/weapon/flame/torch/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/flame))
		var/obj/item/weapon/flame/F = W
		if(F.lit && !src.lit)
			src.turn_on()
			user.visible_message("<span class='goodlight'>[user] enlights [src].")
		if(!F.lit && src.lit)
			F.turn_on()
			user.visible_message("<span class='goodlight'>[user] enlights [F].")

//FIREPLACE

/obj/structure/fireplace
	name = "fireplace"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "fireplace0"
	desc = "A luminescent font of light."
	density = 1
	anchored = 1
	breakable = 1

	var/lit = 0
	var/f_force = 3
	var/r_range = 6
	var/c_color = "#ff7a7a"
	var/on_state = "fireplace1"
	var/off_state = "fireplace0"
	var/fire_left = null //tempo até apagar

/obj/structure/fireplace/New()
	..()
	fire_left = rand(20 MINUTES, 48 MINUTES)
	processing_objects.Add(src)
	turn_on()

/obj/structure/fireplace/off/New()
	..()
	turn_off()

/obj/structure/fireplace/Destroy()
	processing_objects.Remove(src)
	..()

/obj/structure/fireplace/process()
	fire_left = max(0, fire_left-2 SECONDS)
	if(fire_left == 0 && lit)
		turn_off()

/obj/structure/fireplace/proc/turn_on()
	playsound(src.loc, 'torch_light.ogg', 50, 1)
	icon_state = on_state
	set_light(r_range, f_force, c_color)
	fire_left = rand(38 MINUTES, 48 MINUTES)
	lit = 1

/obj/structure/fireplace/proc/turn_off()
	playsound(src.loc, 'torch_snuff.ogg', 75, 1)
	icon_state = off_state
	set_light(0)
	lit = 0

/obj/structure/fireplace/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/flame))
		var/obj/item/weapon/flame/F = I
		if(src.lit && !F.lit)
			F.turn_on()
			user.visible_message("<span class='goodlight'>[user] enlights [F].")
		if(!src.lit && F.lit)
			src.turn_on()
			user.visible_message("<span class='goodlight'>[user] enlights [src].")
	if(istype(I, /obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/cigarette/C = I
		C.light("<b>[user]</b> manages to light their [C] with [src].</span>")



/obj/structure/fireplace/attack_hand(var/mob/user)
	if(lit)
		turn_off()

/obj/structure/fireplace/alt
	icon_state = "fireplace20"
	on_state =  "fireplace21"
	off_state = "fireplace20"

/obj/structure/fireplace/alt2
	icon = 'icons/obj/weapons.dmi'
	icon_state = "pyreplace0"
	on_state =  "pyreplace1"
	off_state = "pyreplace0"
	c_color = "#ff7a7a"
	f_force = 2
	r_range = 4

/obj/structure/fireplace/wallplace
	on_state = "wfireplace1"
	off_state = "wfireplace0"
	icon_state = "wfireplace0"
	density = 0
	plane = 21

/obj/structure/fireplace/wallplace/north
	pixel_y = 22

/obj/structure/fireplace/wallplace/south
	pixel_y = -26

/obj/structure/fireplace/wallplace/west
	pixel_x = -26

/obj/structure/fireplace/wallplace/east
	pixel_x = 26


/obj/structure/fireplace/alt/Old
	c_color = "#ff4f4f"
	f_force = 3
	r_range = 6

/obj/structure/torchwall
	name = "torch fixture"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "torchwall0"
	desc = "A torch fixture."
	anchored = 1
	density = 0
	var/on_state = "torchwall1"
	var/off_state = "torchwall0"
	var/empty_state = "torchwall"
	var/isempty = FALSE
	var/on = TRUE
	hits = 10

	layer = 4.01
	plane = 22

/obj/structure/torchwall/empty
	isempty = TRUE
	on = FALSE

/*
/mob/living/carbon/human/verb/MudarLuz()
	var/A = input(usr, "NEW COLOR", "Change color", "#f40d30", text)
	for(var/obj/structure/fireplace/alt/Old/O in range(40))
		O.lightcolor = A
		O.checkfire()
*/

/obj/structure/torchwall/proc/checkfire()
	if(src.on)
		icon_state = on_state
		set_light(7, 1,"#ff7a7a")
		//playsound(src.loc, 'newfireloop.ogg', 50, 0)
	else if(!isempty)
		icon_state = off_state
		set_light(0)
	else
		icon_state = empty_state
		set_light(0)

/obj/structure/torchwall/New()
	checkfire()
	..()

/obj/structure/torchwall/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(src.on)
		if(istype(W, /obj/item/weapon/flame/torch))
			var/obj/item/weapon/flame/torch/T = W
			if(!isempty)
				if(T.lit)
					user.visible_message("<span class='notice'>[user] tries to light [T]</span>", \
					"<span class='notice'>You try to light [src]</span>")
				else
					T.turn_on()
			else
				src.on = T.lit
				src.isempty = FALSE
				src.checkfire()
				T.lit = FALSE

				qdel(T)
				user.update_inv_r_hand()
				user.update_inv_l_hand()
				playsound(src, 'sound/items/torch_fixture1.ogg', 50, 0, -1)
	else
		if(istype(W, /obj/item/weapon/flame/torch))
			var/obj/item/weapon/flame/torch/T = W
			if(!isempty)
				if(T.lit)
					user.visible_message("<span class='notice'>[user] lights [src]</span>", \
					"<span class='notice'>You light [src]</span>")
					playsound(src.loc, 'torch_light.ogg', 50, 0)
					src.on = TRUE
					src.checkfire()
					user.update_inv_r_hand()
					user.update_inv_l_hand()
				else
					user.visible_message("<span class='notice'>[user] tries to light [src]</span>", \
					"<span class='notice'>You try to light [src]</span>")

			else
				src.on = T.lit
				src.isempty = FALSE
				src.checkfire()
				T.lit = FALSE

				qdel(T)
				user.update_inv_r_hand()
				user.update_inv_l_hand()
				playsound(src, 'sound/items/torch_fixture1.ogg', 50, 0, -1)
	..()

/obj/structure/torchwall/attack_hand(mob/M as mob)
	if(!isempty)
		var/obj/item/weapon/flame/torch/T = new (M.loc)
		M.put_in_active_hand(T)
		T.turn_on()

		src.on = FALSE
		src.isempty = TRUE
		src.checkfire()
		M.update_inv_r_hand()
		M.update_inv_l_hand()
		playsound(src, 'sound/items/torch_fixture0.ogg', 50, 0, -1)
	else
		M << "It has no torch."

/obj/structure/campfire
	name = "campfire"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "campfire0"
	desc = ""
	var/fire_left = 600 //essa merda apaga de 3 em 3 segundos, não dá
	var/on_state = "campfire1"
	var/old_state = "campfire2"
	var/off_state = "campfire0"
	var/on = TRUE
	density = 0
	anchored = 1
	var/spent = 0


/obj/structure/campfire/process()
	if(!on) return
	fire_left--
	if(!fire_left)
		on = FALSE
		spent = TRUE
		checkfire()
		playsound(src.loc, 'torch_snuff.ogg', 75, 0)

/obj/structure/campfire/proc/checkfire(var/come_off=0)//COME_OFF PRA TALVEZ JA VIR DESLIGADA
	if(spent) return

	if(come_off)
		if(prob(10))
			icon_state = off_state
			on = 0
			set_light(0)
			return

	if(src.on)
		icon_state = on_state
		set_light(5, 1,"#f4fad4")
		//playsound(src.loc, 'newfireloop.ogg', 50, 0)
	else
		icon_state = old_state
		set_light(0)

/obj/structure/campfire/New()
	fire_left = rand(300, 650)
	checkfire(come_off=1)
	processing_objects.Add(src)
	..()

/obj/structure/campfire/firepool
	name = "firepool"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "gluepool0"
	desc = ""
	fire_left = 50 //essa merda apaga de 3 em 3 segundos, não dá
	on_state = "gluepool1"
	old_state = ""
	off_state = "gluepool0"
	on = FALSE
	density = 0
	anchored = 1


/obj/structure/campfire/firepool/process()
	if(!on) return
	fire_left--
	if(!fire_left)
		on = FALSE
		checkfire()
		playsound(src.loc, 'torch_snuff.ogg', 75, 0)

/obj/structure/campfire/firepool/New()
	fire_left = rand(50, 80)
	checkfire(come_off=1)
	processing_objects.Add(src)
	..()

/obj/structure/campfire/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(src.on)
		if(istype(W, /obj/item/weapon/flame/torch))
			var/obj/item/weapon/flame/torch/T = W
			if(T.lit)
				user.visible_message("<span class='notice'>[user] tries to light [T]</span>", \
				"<span class='notice'>You try to light [src]</span>")
			else
				T.lit = TRUE
				user.visible_message("<span class='notice'>[user] lights [T]</span>", \
				"<span class='notice'>You light [T]</span>")
				playsound(src.loc, 'torch_light.ogg', 50, 0)

				user.update_inv_r_hand()
				user.update_inv_l_hand()

		else if(istype(W, /obj/item/weapon/flame/candle))
			var/obj/item/weapon/flame/candle/C = W
			if(C.lit)
				user.visible_message("<span class='notice'>[user] tries to light [C]</span>", \
				"<span class='notice'>You try to light [src]</span>")
			else

				user.visible_message("<span class='notice'>[user] lights [C]</span>", \
				"<span class='notice'>You light [C]</span>")
				playsound(src.loc, 'torch_light.ogg', 50, 0)
				user.update_inv_r_hand()
				user.update_inv_l_hand()

		else if(istype(W, /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom))
			var/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/F = W
			if(!F.cooked)
				user.visible_message("<span class='notice'>[user] cooks the [F]</span>", \
				"<span class='notice'>You cook the [F]</span>")
				if(prob(75))
					F.name = "cooked [F.real_name]"
					F.potency += rand(5,8)
					F.cooked = TRUE
				else
					F.name = "poorly cooked [F.real_name]"
					F.potency -= rand(1,3)
					F.cooked = TRUE
		else if(istype(W, /obj/item/clothing/mask/cigarette))
			var/obj/item/clothing/mask/cigarette/C = W
			C.light("<span class='notice'>[user] manages to light their [name] with [W].</span>")
	else
		if(istype(W, /obj/item/weapon/flame/torch))
			var/obj/item/weapon/flame/torch/T = W
			if(T.lit)
				user.visible_message("<span class='notice'>[user] lights [src]</span>", \
				"<span class='notice'>You light [src]</span>")
				playsound(src.loc, 'torch_light.ogg', 50, 0)
				src.on = TRUE
				src.checkfire()
				user.update_inv_r_hand()
				user.update_inv_l_hand()
			else
				user.visible_message("<span class='notice'>[user] tries to light [src]</span>", \
				"<span class='notice'>You try to light [src]</span>")

		else if(istype(W, /obj/item/weapon/flame/candle))
			var/obj/item/weapon/flame/candle/C = W
			if(C.lit)
				user.visible_message("<span class='notice'>[user] lights [src]</span>", \
				"<span class='notice'>You light [src]</span>")
				playsound(src.loc, 'torch_light.ogg', 50, 0)
				src.on = TRUE
				src.checkfire()
				user.update_inv_r_hand()
				user.update_inv_l_hand()
			else
				user.visible_message("<span class='notice'>[user] tries to light [src]</span>", \
				"<span class='notice'>You try to light [src]</span>")

/obj/structure/campfire/attack_hand(mob/M as mob)
	if(src.on)
		src.on = FALSE
		src.checkfire()
		playsound(src.loc, 'torch_snuff.ogg', 75, 0)