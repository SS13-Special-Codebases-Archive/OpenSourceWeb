/datum/job/weaponsmith
	title = "Weaponsmith"
	titlebr = "Ferreiro de Armas"
	flag = WEAPONSMITH
	department_head = null
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "The merchant and yourself."
	selection_color = "#ae00ff"
	idtype = /obj/item/weapon/card/id/ltgrey
	access = list(smith)
	minimal_access = list(smith)
	jobdesc = "A specialized forger of weapons, knowledgeable in the replication of armaments of the earlier periods. The Baron often buys directly from you and your colleagues, as importation levies are more costly. Your weapons are the sharpest, and your steel the purest - you say so yourself!"
	jobdescbr = "Ferreiro especializado em tudo o que a forja pode fazer."
	thanati_chance = 75
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.voicetype = "sketchy"
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/common/smith(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/apron(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/weapon/alicate(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/weapon/carverhammer(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel/smith(H), slot_back)
		H.create_kg()
		return 1

/datum/job/armorsmith
	title = "Armorsmith"
	titlebr = "Ferreiro de Armaduras"
	flag = ARMORSMITH
	department_head = null
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "The merchant and yourself."
	selection_color = "#ae00ff"
	idtype = /obj/item/weapon/card/id/ltgrey
	access = list(smith)
	minimal_access = list(smith)
	jobdesc = "A blacksmith specializing in the smithing of armor. Your attention to detail is unprecedented - everyone tells you so, especially the garrison. Your importance to them as the Baron&#8217;s main local supplier of fitting protection means that they hold your trade in high esteem, and rightly so."
	jobdescbr = "Ferreiro especializado em tudo o que a forja pode fazer."
	thanati_chance = 75
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.voicetype = "sketchy"
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/common/smith(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/apron(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/weapon/alicate(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/weapon/carverhammer(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel/smith(H), slot_back)
		H.create_kg()
		return 1


/datum/job/metalsmith
	title = "Metalsmith"
	titlebr = "Ferreiro de Utensilios"
	flag = METALSMITH
	department_head = null
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "The merchant and yourself."
	selection_color = "#ae00ff"
	idtype = /obj/item/weapon/card/id/ltgrey
	access = list(smith)
	minimal_access = list(smith)
	jobdesc = "The metalsmith crafts ornaments of fine design. You consider it true craftsmanship. Turning iron into a hunk of metal you can wear on your body or carry in your hand is one thing, but crafting true works of art - beating heated metal down for utilitarian or artistic purposes to sell to the residents of the fortress and having them appreciate your fine designs is another."
	jobdescbr = "Ferreiro especializado em tudo o que a forja pode fazer."
	thanati_chance = 75
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.voicetype = "sketchy"
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/common/smith(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/apron(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/weapon/alicate(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/weapon/carverhammer(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel/smith(H), slot_back)
		H.create_kg()
		return 1


/datum/job/apprentice
	title = "Apprentice"
	titlebr = "Aprendiz"
	flag = APPRENTICE
	department_head = list("Captain")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Blacksmith."
	selection_color = "#ddddff"
	minimal_player_age = 10
	jobdesc = "A young learner in a contract of apprenticeship with the local smith. Usually, they are children of parents who give them up to work under an artisan. Their many years of servitude to their master allow them to learn hands on, and potentially succeed them."
	idtype = /obj/item/weapon/card/id/ltgrey
	access = list(smith)
	minimal_access = list(smith)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.set_species("Child")
		H.equip_to_slot_or_del(new /obj/item/clothing/under/child_jumpsuit(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/child/shoes(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/yapron(H), slot_wear_suit)
		H.vice = null
		H.religion = "Gray Church"
		H.height = rand(130,150)
		H.create_kg()
		return 1