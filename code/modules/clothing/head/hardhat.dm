/obj/item/clothing/head/hardhat
	name = "hard hat"
	desc = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight."
	icon_state = "hardhat0_yellow"
	flags = FPRINT | TABLEPASS
	item_state = "hardhat0_yellow"
	var/brightness_on = 2 //luminosity when on
	var/on = 0
	item_color = "yellow" //Determines used sprites: hardhat[on]_[color] and hardhat[on]_[color]2 (lying down sprite)
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 10, bomb = 20, bio = 10, rad = 20)
	flags_inv = 0
	siemens_coefficient = 0.9

	RightClick(mob/user)
		if(!isturf(user.loc))
			user << "You cannot turn the light on while in this [user.loc]" //To prevent some lighting anomalities.
			return
		on = !on
		icon_state = "hardhat[on]_[item_color]"
		item_state = "hardhat[on]_[item_color]"
		playsound(src.loc, 'lightswitch.ogg', 30, 1, -1)
		user.update_inv_head(0)

		if(on)
			set_light(2, 2,"#f4fad4")
		else
			set_light(0)

	pickup(mob/user)
		if(on)
			set_light(2, 2,"#f4fad4")

	dropped(mob/user)
		if(on)
			set_light(2, 2,"#f4fad4")

	on_enter_storage()
		if(on)
			set_light(0)
			on = 0
			icon_state = "hardhat[on]_[item_color]"
			item_state = "hardhat[on]_[item_color]"
		..()
		return


/obj/item/clothing/head/hardhat/orange
	icon_state = "hardhat0_orange"
	item_state = "hardhat0_orange"
	item_color = "orange"

/obj/item/clothing/head/hardhat/red
	icon_state = "hardhat0_red"
	item_state = "hardhat0_red"
	item_color = "red"
	name = "firefighter helmet"
	flags = FPRINT | TABLEPASS | STOPSPRESSUREDMAGE
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/head/hardhat/white
	icon_state = "hardhat0_white"
	item_state = "hardhat0_white"
	item_color = "white"
	flags = FPRINT | TABLEPASS | STOPSPRESSUREDMAGE
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/head/hardhat/dblue
	icon_state = "hardhat0_dblue"
	item_state = "hardhat0_dblue"
	item_color = "dblue"

