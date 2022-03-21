/datum/job/cmo
	title = "Esculap"
	titlebr = "Esculápio"
	flag = CMO
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	department_flag = MEDSCI
	supervisors = "the captain"
	jobdesc = "Being fortunate enough to wear the title of Esculap is no small feat. Having gone through many years of rigorous formal and academic medical training, these medical professionals are some of the best and brightest Evergreen has to offer. They are usually the second sons of wealthy merchants, but some deceitful charlatans use coin to buy their way into this estimable title."
	jobdescbr = "Serpentes sussurram que você não é um curandeiro gênio, mas um charlatão que conseguiu essa tarefa por meio das conexões de seus pais. Você deve fingir que não é verdade."
	selection_color = "#ffddf0"
	idtype = /obj/item/weapon/card/id/cmo
	access = list(sanctuary,keep,esculap)
	minimal_access = list(sanctuary,keep,esculap)
	minimal_player_age = 10
	thanati_chance = 50
	money = 25
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/esculap(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/common/smith(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/boots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/esculap(H), slot_wear_suit)
		H.add_event("nobleblood", /datum/happiness_event/noble_blood)
		H.add_perk(/datum/perk/chemical)
		H.terriblethings = TRUE
		H.create_kg()
		return 1


/datum/job/doctor
	title = "Serpent"
	titlebr = "Serpente"
	flag = DOCTOR
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Esculap"
	selection_color = "#ffeef0"
	jobdesc = "The serpent is a skilled practitioner serving an apprenticeship under their mentor, the Esculap. Unlike your mentor, you were never fortunate enough to afford more formal medical training. Luckily for you, your generous teacher offered to train you themselves and rendered you a place in the serpentine order in return for your extended servitude. Hail Hippocrates!"
	idtype = /obj/item/weapon/card/id/med
	access = list(sanctuary)
	minimal_access = list(sanctuary)
	sex_lock = MALE
	money = 9
	thanati_chance = 50
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/common(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/serpent(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.h_style = "Shaved"
		H.add_perk(/datum/perk/chemical)
		H.terriblethings = TRUE
		H.create_kg()
		return 1


/datum/job/chemsister
	title = "Chemsister"
	titlebr = "Chemsister"
	flag = CHEMSIS
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Esculap"
	selection_color = "#ffeef0"
	idtype = /obj/item/weapon/card/id/med
	access = list(sanctuary)
	minimal_access = list(sanctuary)
	sex_lock = FEMALE
	no_trapoc = TRUE
	jobdesc = "Although the serpentine order is a close brotherhood of medical workers, chemsisters are anything but. These women are tasked with preparing the necessary anesthetics for the routine operations of the serpents. Ensuring that the patient recieves adequate care, your affinity for chemicals and sensible prescriptions of various regents has made you respected enough to be tolerated among sanctuary staff."
	thanati_chance = 30
	money = 7
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/common(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/chemsis(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.add_perk(/datum/perk/chemical)
		H.terriblethings = TRUE
		H.create_kg()
		return 1



//Chemist is a medical job damnit	//YEAH FUCK YOU SCIENCE	-Pete	//Guys, behave -Erro
/*
/datum/job/geneticist
	title = "Counselor"
	flag = GENETICIST
	department_head = list("Chief Medical Officer", "Research Director")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Esculap"
	selection_color = "#ffeef0"
	idtype = /obj/item/weapon/card/id/gene
	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_research)
	minimal_access = list(access_medical, access_morgue, access_genetics, access_research)


	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_medsci(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/geneticist(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/geneticist(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/genetics(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), slot_s_store)
		return 1
*/