/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "Standard Security gear. Protects the head from impacts."
	icon_state = "helmet"
	force = 15
	parry_chance = 5
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES
	item_state = "helmet"
	armor = list(melee = 50, bullet = 15, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	var/obj/machinery/camera/camera
	var/network_used = "SS13"
	var/blocks_vision = FALSE
	drop_sound = 'helm_drop.ogg'
	armor_type = ARMOR_METAL
	weight = 3
	blunt = TRUE

/obj/item/clothing/head/helmet/warden
	name = "warden's hat"
	desc = "It's a special helmet issued to the Warden of a securiy force. Protects the head from impacts."
	icon_state = "policehelm"
	flags_inv = 0

/obj/item/clothing/head/helmet/lw/ironopenhelmet
	name = "iron open helmet"
	desc = "Will protect your head, but not your face."
	icon_state = "openiron"
	item_state = "helmet"
	flags = FPRINT|TABLEPASS|BLOCKHAIR
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 0, bomb = 10, bio = 0, rad = 0)
	item_worth = 16
	flags_inv = HIDEEARS
	armor_type = ARMOR_METAL
	body_parts_covered = HEAD
	siemens_coefficient = 0.7
	weight = 12

/obj/item/clothing/head/helmet/lw/elitehelmet2
	name = "elite helmet"
	desc = "It's a full-helmet specifically designed to protect against close range attacks."
	icon_state = "castellan"
	item_state = "helmet"
	flags = FPRINT|TABLEPASS|BLOCKHAIR
	body_parts_covered = HEAD|FACE|MOUTH|THROAT
	armor = list(melee = 40, bullet = 0, laser = 0,energy = 5, bomb = 5, bio = 2, rad = 0)
	item_worth = 20
	flags_inv = HIDEEARS
	armor_type = ARMOR_METAL
	siemens_coefficient = 0.7
	weight = 16
	blocks_vision = TRUE

/obj/item/clothing/head/helmet/lw/elitehelmet
	name = "elite helmet"
	desc = "It's a full-helmet specifically designed to protect against close range attacks."
	icon_state = "hero0"
	item_state = "helmet"
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE|MOUTH|THROAT
	armor = list(melee = 40, bullet = 0, laser = 0,energy = 5, bomb = 5, bio = 2, rad = 0)
	item_worth = 20
	flags_inv = HIDEEARS
	armor_type = ARMOR_METAL
	body_parts_covered = HEAD|FACE|MOUTH
	siemens_coefficient = 0.7
	var/up = 0
	weight = 14
	blocks_vision = TRUE

/obj/item/clothing/head/helmet/lw/elitehelmet/RightClick(mob/user as mob)
	toggle()


/obj/item/clothing/head/helmet/lw/elitehelmet/verb/toggle()
	set category = "Object"
	set name = "Adjust helmet"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.restrained())
		if(src.up)
			src.up = !src.up
			flags_inv |= HIDEEYES
			icon_state = "hero0"
			usr << "You flip the [src] visor down."
			flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
			body_parts_covered = HEAD|FACE
		else
			src.up = !src.up
			flags_inv &= ~HIDEEYES
			icon_state = "hero1"
			usr << "You push the [src] visor up out of your face."
			body_parts_covered = HEAD
			flags_inv = HIDEEARS|HIDEEYES
		playsound(src.loc, 'visor.ogg', 30, 1, -1)
		usr.update_vision_cone()
		usr.update_inv_glasses()
		usr.update_inv_head(0)
		src.update_icon()


/obj/item/clothing/head/helmet/lw/censorhelmet
	name = "marduk helmet"
	desc = "An ornate dragon helmet worn by a captain of the Tiamathi Guard."
	icon_state = "censor"
	item_state = "helmet"
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE|MOUTH
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 10, bomb = 10, bio = 0, rad = 0)
	item_worth = 24
	flags_inv = HIDEEARS|HIDEFACE
	armor_type = ARMOR_METAL
	siemens_coefficient = 0.7

/obj/item/clothing/head/helmet/lw/ahelmet
	name = "adamantium helmet"
	icon_state = "ahelm"
	item_state = "ahelm"
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE|MOUTH
	armor = list(melee = 60, bullet = 80, laser = 20, energy = 0, bomb = 40, bio = 0, rad = 0)
	item_worth = 242
	flags_inv = HIDEEARS|HIDEFACE
	armor_type = ARMOR_METAL
	siemens_coefficient = 0.7
	blocks_vision = TRUE

/obj/item/clothing/head/helmet/lw/hevhelm
	name = "Heavy helmet"
	icon_state = "hevhelm"
	item_state = "hevhelm"
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE|MOUTH|THROAT
	armor = list(melee = 40, bullet = 0, laser = 0,energy = 5, bomb = 5, bio = 2, rad = 0)
	item_worth = 24
	flags_inv = HIDEEARS|HIDEFACE
	armor_type = ARMOR_METAL
	siemens_coefficient = 0.7

/obj/item/clothing/head/helmet/lw/chainhelm
	name = "chainmail hood"
	icon_state = "hauberkhood"
	item_state = "helmet"
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|BLOCKHAIR
	body_parts_covered = HEAD
	armor = list(melee = 30, bullet = 0, laser = 0, energy = 10, bomb = 5, bio = 0, rad = 0)
	item_worth = 20
	flags_inv = HIDEEARS
	armor_type = ARMOR_CHAINMAIL
	siemens_coefficient = 0.7

/obj/item/clothing/head/helmet/lw/leatherhelm
	name = "leather helmet"
	icon_state = "lhelmet"
	item_state = "helmet"
	flags = FPRINT|TABLEPASS|BLOCKHAIR
	body_parts_covered = HEAD
	armor = list(melee = 20, bullet = 0, laser = 0, energy = 10, bomb = 0, bio = 0, rad = 0)
	item_worth = 15
	flags_inv = HIDEEARS|HIDEFACE
	siemens_coefficient = 0.7
	armor_type = ARMOR_LEATHER


/obj/item/clothing/head/helmet/lw/openskulliron
	name = "skull open iron helmet"
	icon_state = "openskulliron"
	item_state = "helmet"
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|BLOCKHAIR
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 0, bomb = 10, bio = 0, rad = 0)
	item_worth = 16
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7
	armor_type = ARMOR_METAL
	body_parts_covered = HEAD|FACE
	blocks_vision = TRUE

/obj/item/clothing/head/helmet/lw/siegehelmet
	name = "siege helmet"
	desc = "A helmet commonly used by troops during sieges"
	icon_state = "siegehelmet"
	item_state = "helmet"
	body_parts_covered = HEAD
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|BLOCKHAIR
	armor = list(melee = 45, bullet = 0, laser = 0, energy = 0, bomb = 10, bio = 0, rad = 0)
	item_worth = 20
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7
	armor_type = ARMOR_METAL
	body_parts_covered = HEAD|FACE|THROAT

/obj/item/clothing/head/helmet/lw/crusader
	name = "crusader helmet"
	desc = "A crusader's helmet. Blessed by the priesthood"
	icon_state = "knight"
	item_state = "knight"
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|BLOCKHAIR|HEADCOVERSMOUTH
	armor = list(melee = 50, bullet = 0, laser = 0, energy = 0, bomb = 20, bio = 0, rad = 0)
	item_worth = 60
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	body_parts_covered = HEAD|FACE|MOUTH|THROAT
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	armor_type = ARMOR_METAL
	var/up = 0
	weight = 10

/obj/item/clothing/head/helmet/lw/vandenberg
	name = "chevalier helmet"
	desc = "It's a helmet specifically designed to protect against close range attacks."
	icon_state = "zealot"
	item_state = "zealot"
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|BLOCKHAIR|HEADCOVERSMOUTH
	armor = list(melee = 50, bullet = 0, laser = 0, energy = 0, bomb = 20, bio = 0, rad = 0)
	item_worth = 24
	flags_inv = HIDEEARS|HIDEEYES
	body_parts_covered = HEAD|FACE|MOUTH|THROAT
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	armor_type = ARMOR_METAL
	weight = 10

/obj/item/clothing/head/helmet/lw/crusader/RightClick(mob/user as mob)
	toggle()


/obj/item/clothing/head/helmet/lw/crusader/verb/toggle()
	set category = "Object"
	set name = "Adjust helmet"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.restrained())
		if(src.up)
			src.up = !src.up
			flags_inv |= HIDEEYES
			icon_state = initial(icon_state)
			usr << "You flip the [src] visor down."
			flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
			body_parts_covered = HEAD|FACE|MOUTH
			flags |= HEADCOVERSMOUTH
		else
			src.up = !src.up
			flags_inv &= ~HIDEEYES
			icon_state = "[initial(icon_state)]up"
			usr << "You push the [src] visor up out of your face."
			body_parts_covered = HEAD
			flags_inv = HIDEEARS|HIDEEYES
			flags &=  ~HEADCOVERSMOUTH
		playsound(src.loc, 'visor.ogg', 30, 1, -1)
		usr.update_vision_cone()
		usr.update_inv_glasses()
		usr.update_inv_head(0)
		src.update_icon()

/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	desc = "It's a helmet specifically designed to protect against close range attacks."
	icon_state = "riot"
	item_state = "helmet"
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES
	armor = list(melee = 82, bullet = 15, laser = 5,energy = 5, bomb = 5, bio = 2, rad = 0)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7
	armor_type = ARMOR_METAL

/obj/item/clothing/head/helmet/var/shockable = 0

/obj/item/clothing/head/helmet/sechelm
	name = "tiamat helmet"
	desc = "The iconic dragon helmet worn by members of the Tiamathi Guard."
	icon_state = "sechelmrookie"
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	item_state = "thelmet"
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|HEADCOVERSMOUTH|BLOCKHAIR
	body_parts_covered = HEAD|FACE|MOUTH
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 10, bomb = 10, bio = 0, rad = 0)
	item_worth = 24
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	armor_type = ARMOR_METAL
	var/inputtedText = null
	shockable = TRUE

/obj/item/clothing/head/helmet/sechelm/trusted
	icon_state = "sechelmtrusted"

/obj/item/clothing/head/helmet/sechelm/veteran
	name = "\improper Marduk's helmet"
	shockable = FALSE
	icon_state = "sechelmvet"


/obj/item/clothing/head/helmet/sechelm/examine()
	..()
	if(camera)
		to_chat(usr, "<span class='combat'><small>\The [src]'s camera is on!</small></span>")

/obj/item/clothing/head/helmet/sechelm/emp_act(severity)
	if(network_used)
		if(1.0)
			if(src.camera)
				src.camera.network = list()
				cameranet.removeCamera(src.camera)
				usr << "<span class='warning'>[src.name] bzzz.</span>"
	else ..()



/obj/item/clothing/head/helmet/sechelm/attack_self(mob/user)
	if(network_used)
		if(camera)
			..(user)
		else
			camera = new /obj/machinery/camera(src)
			camera.network = list(network_used)
			cameranet.removeCamera(camera)
			camera.c_tag = user.name
			to_chat(user, "<span class='combat'> User scanned as [camera.c_tag]. Camera activated.</span>")
			playsound(src, 'sound/lfwbcombatuse/energy_reload.ogg', 50, 0, -3)
			spawn(2)
				playsound(src, 'sound/effects/nvg_on.ogg', 50, 0, -3)
	else ..()

/obj/item/clothing/head/helmet/sechelm/MiddleClick(mob/living/carbon/human/user as mob)
	if(user.get_active_hand() == null || istype(user.get_active_hand(), /obj/item/clothing/head/helmet/sechelm))

		if(usr.next_move >= world.time)
			return

		if(usr.stat == 1)
			return

		if(usr.restrained())
			return

		var/frase
		user.next_move = world.time + 4
		frase = sanitize(input("What phrase do you wish to speak through your helmet?","") as text|null)

		if(frase)
			inputtedText = frase

/obj/item/clothing/head/helmet/sechelm/RightClick(mob/living/carbon/human/user as mob)
	if(user.get_active_hand() == null || istype(user.get_active_hand(), /obj/item/clothing/head/helmet/sechelm))

		if(istype(src, /obj/item/clothing/head/helmet/sechelm))

			if(usr.next_move >= world.time)
				return

			if(usr.stat == 1)
				return

			if(usr.restrained())
				return

			user.next_move = world.time + 4

			if(inputtedText && istype(user.head, /obj/item/clothing/head/helmet/sechelm))
				var/ending = copytext_char(inputtedText, length(inputtedText))
				if(ending == "!")
					user.say("[inputtedText]", "<i>barks</i>", 0, 0, 0, 0, 0, 1)
					playsound(src.loc, 'sound/lfwbsounds/bark.ogg', 100, 1)
				else
					user.say("[inputtedText]!", "<i>barks</i>", 0, 0, 0, 0, 0, 1)
					playsound(src.loc, 'sound/lfwbsounds/bark.ogg', 100, 1)

/obj/item/clothing/head/helmet/sechelm/fake
	armor = list(melee = 5, bullet = 5, laser = 5,energy = 5, bomb = 5, bio = 2, rad = 0)
	item_state = "tdred"

/obj/item/clothing/head/helmet/sechelm/incarn
	name = "incarn hood"
	icon_state = "incarn"
	item_state = "tdred"
	shockable = FALSE
	armor_type = ARMOR_LEATHER

/obj/item/clothing/head/helmet/sechelm/chariot
	name = "minotaur helm"
	icon_state = "chariot"
	item_state = "tdred"
	shockable = FALSE
	armor_type = ARMOR_METAL
/*HELMETS ESPECIAIS*/

/obj/item/clothing/head/helmet/sechelm/cerbhelm
	name = "cerberus helmet"
	icon_state = "cerbhelm"
	shockable = FALSE
	item_state = "cerbh"
	armor_type = ARMOR_METAL

/obj/item/clothing/head/helmet/sechelm/cathelm
	name = "cat helmet"
	icon_state = "cathelm"
	item_state = "helmet"
	shockable = FALSE
	armor_type = ARMOR_METAL
/*FIM*/

/obj/item/clothing/head/helmet/lw/ordinator
	name = "tribunal ordinator helmet"
	desc = "Standard issue helmet worn by Tribunal Ordinators. Theft of Tribunal equipment is punishable by death."
	icon_state = "ordinator"
	item_state = "helmet"
	armor_type = ARMOR_METAL
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|BLOCKHAIR|HEADCOVERSMOUTH
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	body_parts_covered = HEAD|FACE|MOUTH
	shockable = FALSE
	armor = list(melee = 50, bullet = 50, laser = 0, energy = 10, bomb = 35, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/lw/ordinator/old
	name = "old tribunal ordinator helmet"
	icon_state = "oldordinator"
	armor = list(melee = 35, bullet = 0, laser = 0, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/lw/ordinator/old/vietnam
	icon_state = "vietnamordinator"

/obj/item/clothing/head/helmet/swat
	name = "\improper SWAT helmet"
	desc = "They're often used by highly trained Swat Members."
	icon_state = "swat"
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES
	item_state = "swat"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	armor_type = ARMOR_METAL
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5
	network_used = "swat"

/obj/item/clothing/head/helmet/soulbreaker
	name = "Soulbreaker helmet"
	icon_state = "soulbreaker0"
	item_state = "soulbreaker0"
	armor_type = ARMOR_METAL
	desc = "Helmet worn by the followers of Allah."
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|HEADCOVERSMOUTH|BLOCKHAIR
	body_parts_covered = HEAD|FACE|MOUTH|THROAT
	cold_protection = HEAD|FACE|MOUTH|THROAT
	min_cold_protection_temperature = 1500
	armor = list(melee = 60, bullet = 80, laser = 20, energy = 10, bomb = 50, bio = 0, rad = 0)
	item_worth = 100
	siemens_coefficient = 0
	var/brightness_on = 4
	icon_action_button = "action_hardhat"
	var/on = 0

	attack_self(mob/user)
		if(!isturf(user.loc))
			user << "You cannot turn the light on while in this [user.loc]" //To prevent some lighting anomalities.
			return
		on = !on
		user.update_inv_head()
		user.update_icons()
		icon_state = "soulbreaker[on]"
		item_state = "soulbreaker[on]"
		user.update_inv_head(0)
		if(on)
			set_light(2, 2,"#f4fad4")
			user.update_inv_head(1)
			user.update_icons(1)
			user.update_inv_head(0)
		else
			set_light(0)

	pickup(mob/user)
		if(on)
			set_light(2, 2,"#f4fad4")
			user.update_inv_head(1)
			user.update_icons(1)

	dropped(mob/user)
		if(on)
			set_light(2, 2,"#f4fad4")

	on_enter_storage(mob/user)
		if(on)
			set_light(0)
			on = 0
			icon_state = "soulbreaker[on]"
			item_state = "soulbreaker[on]"
			user.update_inv_head(1)
			user.update_icons(1)
		..()
		return

/obj/item/clothing/head/helmet/thunderdome
	name = "\improper Thunderdome helmet"
	desc = "<i>'Let the battle commence!'</i>"
	icon_state = "thunderdome"
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES
	item_state = "thunderdome"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 10, bomb = 25, bio = 10, rad = 0)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 1
	network_used = "thunder"

/obj/item/clothing/head/helmet/gladiator
	name = "gladiator helmet"
	desc = "Ave, Imperator, morituri te salutant."
	icon_state = "gladiator"
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|HEADCOVERSMOUTH|BLOCKHAIR
	item_state = "gladiator"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES
	siemens_coefficient = 1
	network_used = "thunder"

/obj/item/clothing/head/helmet/tactical
	name = "tactical helmet"
	desc = "An armored helmet capable of being fitted with a multitude of attachments."
	icon_state = "swathelm"
	item_state = "helmet"
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES
	armor = list(melee = 62, bullet = 50, laser = 50,energy = 35, bomb = 10, bio = 2, rad = 0)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7
	network_used = "swat"

