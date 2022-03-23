/datum/job/engineer
	title = "Hump"
	titlebr = "Minerador"
	flag = ENGINEER
	department_head = list("Baron")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Baron"
	selection_color = "#fff5cc"
	jobdesc = "An all around skilled engineer and mason paid to construct works of stone, make repairs to the fortress or even mine. An all around handyman, he is the only person in the fortress with these capabilities ensuring his niche trade skills always land him a job. Don&#8217;t pay him and he&#8217;ll be sure to measure the thickness of your skull."
	jobdescbr = "An all around skilled engineer and mason paid to construct works of stone, make repairs to the fortress or even mine. An all around handyman, he is the only person in the fortress with these capabilities ensuring his niche trade skills always land him a job. Don&#8217;t pay him and he&#8217;ll be sure to measure the thickness of your skull."
	idtype = /obj/item/weapon/card/id/engie
	access = list(keep,hump)
	minimal_access = list(keep,hump)
	thanati_chance = 75
	money = 9
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/industrial(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/hydroponics(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), slot_wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/minerapron(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/weapon/pickaxe(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/weapon/shovel(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/botanic_leather(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/weapon/chisel(H), slot_r_store)
		H.equip_to_slot_or_del(new /obj/item/weapon/key/residencesHUMP(H), slot_l_store)
		H.add_perk(/datum/perk/ref/strongback)
		H.add_perk(/datum/perk/illiterate)
		H.add_perk(/datum/perk/ancitech)
		H.create_kg()
		return 1


/datum/job/mortus
	title = "Mortus"
	titlebr = "Mortus"
	flag = MORTUS
	department_head = list("Baron")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Baron"
	jobdesc = "The obscure residents of the fortress, often hiding their faces from others to not be identified. With an immunity from the lifeweb radiation, they can sometimes be heard referring to it as the &#8217;Mistress&#8217; amongst themselves. Kidnappings happen often in Firethorn, and its usually the mortii blamed first. The garrison turn a blind eye to the necessities of your job as long as you&#8217;re keeping the power on, or else you&#8217;ll be the mistress&#8217;s next sacrifice."
	jobdescbr = "The obscure residents of the fortress, often hiding their faces from others to not be identified. With an immunity from the lifeweb radiation, they can sometimes be heard referring to it as the &#8217;Mistress&#8217; amongst themselves. Kidnappings happen often in Firethorn, and its usually the mortii blamed first. The garrison turn a blind eye to the necessities of your job as long as you&#8217;re keeping the power on, or else you&#8217;ll be the mistress&#8217;s next sacrifice."
	selection_color = "#fff5cc"
	idtype = /obj/item/weapon/card/id/mortician
	access = list(lifeweb)
	minimal_access = list(lifeweb)
	thanati_chance = 25
	money = 6
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/daggerssheath(H), slot_wrist_l)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/janitor(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/boots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/daggerssheath(H), slot_wrist_l)
		H.equip_to_slot_or_del(new /obj/item/weapon/chisel(H), slot_r_store)
		H.equip_to_slot_or_del(new /obj/item/weapon/spacecash/c10(H), slot_l_store)
		H.add_perk(/datum/perk/ref/strongback)
		H.add_perk(/datum/perk/ancitech)
		H.terriblethings = TRUE
		H.create_kg()
		return 1
