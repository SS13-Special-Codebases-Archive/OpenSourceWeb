/datum/job/southner
	title = "Southner"
	titlebr = "Southner"
	flag = SIEGER
	department_flag = CIVILIAN
	faction = "Mini War"
	total_positions = -1
	spawn_positions = -1
	supervisors = "The God King"
	selection_color = "#dddddd"
	idtype = null
	thanati_chance = 0
	access = list()
	minimal_access = list()
	minimal_character_age = 30

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.my_skills.CHANGE_SKILL(SKILL_MELEE,rand(10,15))
		H.my_skills.CHANGE_SKILL(SKILL_RANGE,rand(10,15))
		H.my_skills.CHANGE_SKILL(SKILL_UNARM,rand(0,10))
		H.my_skills.CHANGE_SKILL(SKILL_CLIMB,rand(12,12))
		H.my_skills.CHANGE_SKILL(SKILL_SWIM,rand(10,10))
		H.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(8,9))
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security/comrade(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/sechelm(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		/*var/list/class = list("Rifleman", "Machingunner", "Pistolier")
		switch(pick(class))
			if("Rifleman")
				H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/shotgun/princess(H), slot_r_hand)
				H.equip_to_slot_or_del(new /obj/item/stack/bullets/rifle/nine(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/stack/bullets/rifle/nine(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/stack/bullets/rifle/nine(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/stack/bullets/rifle/nine(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/stack/bullets/rifle/nine(H), slot_l_store)
				H.equip_to_slot_or_del(new /obj/item/stack/bullets/rifle/nine(H), slot_r_store)
			if("Machingunner")
				H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/carbine(H), slot_r_hand)
				H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/mag556(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/mag556(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/mag556(H), slot_l_store)
			if("Pistolier")
				H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/pistol/magnum66/screamer23(H), slot_l_hand)
				H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/pistol/magnum66/screamer23(H), slot_r_hand)
				H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/sm45/pusher/full(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/sm45/pusher/full(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/sm45/pusher/full(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/sm45/pusher/full(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/sm45/pusher/full(H), slot_l_store)
				H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/sm45/pusher/full(H), slot_r_store)*/
		H.my_stats.st = rand(10,14)
		H.my_stats.ht = rand(10,14)
		H.my_stats.dx = rand(10,14)
		H.my_stats.it = rand(10,14)
		H.add_perk(/datum/perk/ref/strongback)
		H.add_perk(/datum/perk/morestamina)
		H.add_perk(/datum/perk/heroiceffort)
		H.updatePig()
		H.create_kg()
		H.outsider = TRUE
		if(ticker.mode.config_tag == "miniwar")
			var/datum/game_mode/miniwar/M = ticker.mode
			M.south_team += H
			H.mini_war = title
			H.update_all_miniwar_icons()

/datum/job/northner
	title = "Northner"
	titlebr = "Northner"
	flag = SIEGER
	department_flag = CIVILIAN
	faction = "Mini War"
	total_positions = -1
	spawn_positions = -1
	supervisors = "The God King"
	selection_color = "#dddddd"
	idtype = null
	thanati_chance = 0
	access = list()
	minimal_access = list()
	minimal_character_age = 30

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.my_skills.CHANGE_SKILL(SKILL_MELEE,rand(10,15))
		H.my_skills.CHANGE_SKILL(SKILL_RANGE,rand(10,15))
		H.my_skills.CHANGE_SKILL(SKILL_UNARM,rand(0,10))
		H.my_skills.CHANGE_SKILL(SKILL_CLIMB,rand(12,12))
		H.my_skills.CHANGE_SKILL(SKILL_SWIM,rand(10,10))
		H.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(8,9))
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security/cerberusold(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/sechelm/cerbhelm(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		/*var/list/class = list("Rifleman", "Machingunner", "Pistolier")
		switch(pick(class))
			if("Rifleman")
				H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/shotgun/princess(H), slot_r_hand)
				H.equip_to_slot_or_del(new /obj/item/stack/bullets/rifle/nine(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/stack/bullets/rifle/nine(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/stack/bullets/rifle/nine(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/stack/bullets/rifle/nine(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/stack/bullets/rifle/nine(H), slot_l_store)
				H.equip_to_slot_or_del(new /obj/item/stack/bullets/rifle/nine(H), slot_r_store)
			if("Machingunner")
				H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/carbine(H), slot_r_hand)
				H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/mag556(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/mag556(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/mag556(H), slot_l_store)
			if("Pistolier")
				H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/pistol/magnum66/screamer23(H), slot_l_hand)
				H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/pistol/magnum66/screamer23(H), slot_r_hand)
				H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/sm45/pusher/full(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/sm45/pusher/full(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/sm45/pusher/full(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/sm45/pusher/full(H.back), slot_in_backpack)
				H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/sm45/pusher/full(H), slot_l_store)
				H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/sm45/pusher/full(H), slot_r_store)*/
		H.my_stats.st = rand(10,14)
		H.my_stats.ht = rand(10,14)
		H.my_stats.dx = rand(10,14)
		H.my_stats.it = rand(10,14)
		H.add_perk(/datum/perk/ref/strongback)
		H.add_perk(/datum/perk/morestamina)
		H.add_perk(/datum/perk/heroiceffort)
		H.updatePig()
		H.create_kg()
		H.outsider = TRUE
		if(ticker.mode.config_tag == "miniwar")
			var/datum/game_mode/miniwar/M = ticker.mode
			M.north_team += H
			H.mini_war = title
			H.update_all_miniwar_icons()