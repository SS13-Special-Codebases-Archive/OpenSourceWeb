/obj/item/weapon/storage/delivery_box
	name = "boxed delivery"
	gender = PLURAL
	desc = "Lost package"
	icon_state ="redbox"
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	flags = FPRINT | TABLEPASS
	var/mob/living/carbon/human/owner = null
	var/delivered = FALSE
	var/locked = TRUE
	var/sender_name
	var/list/delivery_list = list("Money", "Gun", "Food", "Explosive", "Ignots", "Sword", "Shield", "Camo", "Accessory")

/obj/item/weapon/storage/delivery_box/New()
	..()
	var/list/mob/living/carbon/human/players = living_mob_list & player_list
	if(length(players))
		owner = pick(players)
	else
		owner = pick(living_mob_list)
	pick_delivery()
	var/list/last_name = splittext(owner.real_name, " ")
	var/random_name = random_name(pick(FEMALE, MALE))
	var/list/first_name = splittext(random_name, " ")
	if(last_name[2])
		sender_name = first_name[1] + " " + last_name[2]
	else
		sender_name = first_name[1]
	desc = "TO: [owner.real_name].<br>FROM: [sender_name]."

/obj/item/weapon/storage/delivery_box/attack_hand(mob/user as mob)
	if(istype(loc, /mob/living/carbon/human) && locked && user == loc)
		var/mob/living/carbon/human/H = user
		var/obj/item/I = H.get_inactive_hand()
		if(I == src)
			switch(alert(H, "Are you sure you want to open [name]?", name,"Yes","No"))
				if("Yes")
					if(owner && (H != owner))
						H.electrocute_act(30, src, 1, 0, 1)
						H.emote("agonyscream",1, null, 0)
					else
						locked = FALSE
						update_icon()
						..()
				if("No")
					return
		return
	else
		..()

/obj/item/weapon/storage/delivery_box/show_to(mob/user as mob)
	if(locked)
		to_chat(user,"<span class ='combat'> It's locked!</span>")
	else
		..()
	return

/obj/item/weapon/storage/delivery_box/update_icon()
	if(locked)
		icon_state = "redbox"
	else
		icon_state = "redbox_open"

/obj/item/weapon/storage/delivery_box/proc/pick_delivery()
	var/type = pick(delivery_list)
	switch(type)
		if("Money")
			var/obols_type = pick("Copper", "Silver", "Gold")
			switch(obols_type)
				if("Copper")
					spawn_money(pick(1,20), src)
				if("Silver")
					spawn_money_silver(pick(1,20), src)
				if("Gold")
					spawn_money_gold(pick(1,20), src)
		if("Gun")
			var/gun_type = pick("Revolver", "Duelist", "MERCY", "TALON", "ML-23", "Screamer", "UZI")
			switch(gun_type)
				if("Revolver")
					new /obj/item/weapon/gun/projectile/newRevolver/duelista/neoclassic(src)
				if("Duelist")
					new /obj/item/weapon/gun/projectile/newRevolver/duelista(src)
				if("MERCY")
					new /obj/item/weapon/gun/energy/taser/MERCY(src)
				if("TALON")
					new /obj/item/weapon/gun/projectile/automatic/carbine(src)
				if("UZI")
					new /obj/item/weapon/gun/projectile/automatic/mini_uzi(src)
				if("ML-23")
					if(prob(25))
						new /obj/item/weapon/gun/projectile/automatic/pistol/ml23/gold(src)
					else
						new /obj/item/weapon/gun/projectile/automatic/pistol/ml23(src)
				if("Screamer")
					new /obj/item/weapon/gun/projectile/automatic/pistol/magnum66/screamer23(src)
		if("Food")
			var/food_type = pick("LW", "Chocolate", "Cheese")
			switch(food_type)
				if("LW")
					var/LW = pick(typesof(/obj/item/weapon/reagent_containers/food/snacks/lw) - /obj/item/weapon/reagent_containers/food/snacks/lw)
					new LW(src)
				if("Chocolate")
					if(prob(10))
						new /obj/item/weapon/reagent_containers/food/snacks/poo(src)
					else
						new /obj/item/weapon/reagent_containers/food/snacks/candy(src)
				if("Cheese")
					new /obj/item/weapon/reagent_containers/food/snacks/cheesewedge(src)

		if("Explosive")
			if(prob(20))
				new /obj/item/weapon/grenade/smokebomb(src)
			else
				new /obj/item/weapon/grenade/syndieminibomb/frag(src)

		if("Ignots")
			var/ignot = pick(typesof(/obj/item/weapon/ore/refined/lw) - /obj/item/weapon/ore/refined/lw)
			new ignot(src)
		if("Sword")
			var/sword = pick(typesof(/obj/item/sheath) - /obj/item/sheath)
			new sword(src)
		if("Shield")
			if(prob(20))
				new /obj/item/weapon/shield/generator/wrist(src)
			else
				new /obj/item/weapon/shield/generator(src)
		if("Camo")
			new /obj/item/weapon/cloaking_device(src)
		if("Accessory")
			var/type_ac = pick("Copper", "Gold", "Iron")
			switch(type_ac)
				if("Copper")
					if(prob(50))
						new /obj/item/clothing/head/amulet/holy/cross/copper(src)
					else if(prob(50))
						new /obj/item/clothing/ears/earring/copper(src)
					else
						new /obj/item/weapon/dildo/copper(src)
				if("Gold")
					if(prob(50))
						new /obj/item/clothing/head/amulet/goldeneck(src)
					else if(prob(50))
						new /obj/item/weapon/censer(src)
					else
						new /obj/item/weapon/dildo/goldeb(src)
				if("Iron")
					if(prob(50))
						new /obj/item/clothing/head/amulet/holy/cross(src)
					else if(prob(50))
						new /obj/item/clothing/head/amulet/gorget/iron(src)
					else
						new /obj/item/weapon/dildo(src)

	return

/obj/item/weapon/storage/delivery_box/examine()
	..()
	to_chat(usr, desc) //I dunno why the fuck description doesn't work.