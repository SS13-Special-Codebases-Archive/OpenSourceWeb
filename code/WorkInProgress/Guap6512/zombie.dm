mob/var/zombieleader = 0
mob/var/zombieimmune = 0
var/list/zombies = list()

/datum/species/human/zombie
	name = "Zombie"
	name_plural = "Zombies"
	language = "Horde"
	default_language = "Horde"
	primitive = /mob/living/carbon/monkey
	unarmed_type = /datum/unarmed_attack/claws/zombie
	secondary_unarmed_type = /datum/unarmed_attack/claws/zombie

	flags = HAS_SKIN_TONE | HAS_LIPS | NO_BREATHE | NO_POISON | NO_PAIN

/datum/species/human/zombie/children
	name = "Zombie Child"
	name_plural = "Zombie Children"
	total_health = 80 //Kids are weaker than adults.
	min_age = 10
	max_age = 14
	icobase = 'icons/mob/human_races/child/r_child.dmi'
	deform = 'icons/mob/human_races/child/r_def_child.dmi'

/datum/unarmed_attack/claws/zombie
	damage = 2
	sharp = 1
	shredding = 0
	attack_sound = 'sound/weapons/zombiehit.ogg'

	special_act(var/mob/living/carbon/human/target)
		if(prob(10))
			target.zombie_infect()

/mob/living/carbon/human/proc/zombify()
	if(isVampire) return
	if(src?.mind?.changeling) return
	stat &= 1
	oxyloss = 0
	becoming_zombie = 0
	bodytemperature = 310.055
	see_in_dark = 4
	zombie = 1
	sight |= SEE_MOBS
	update_icons()
	update_body()
	src.verbs += /mob/living/carbon/human/proc/supersuicide
	to_chat(src, "<span class='dreamershitfuckcomicao1'>You have become a screamer!</span>")
	src.consyte = FALSE
	src.nutrition = 700
	src.hidratacao = 700
	src.death_door = 0
	var/datum/organ/internal/heart/HE = locate() in internal_organs
	if(HE)
		if(HE.stopped_working)
			HE.stopped_working = 0
	src.sleeping = 0
	update_body()
	src.updatePig()
	if(!isChild(src))
		set_species("Zombie")
	else
		set_species("Zombie Child")
	update_all_zombie_icons()


/mob/living/carbon/human/proc/handle_zombify()
	if(!becoming_zombie)
		return
	for(var/organ_name in list("head"))
		var/datum/organ/external/E = get_organ(organ_name)
		if(!E || (E.status & ORGAN_DESTROYED))
			becoming_zombie = 0
			zombify = 0
			death(1)
			ghostize(1)
			return
		else if(src?.species?.name == "Skeleton")
			becoming_zombie = 0
			zombify = 0
			return
		else
			if(zombify < 500)
				spawn(12)
					zombify += rand(5,10)
					if(prob(2))
						to_chat(src, "<I><B>...I FeEl HUnGeR...</I></B>")

	if(zombify >= 500)
		zombify = 500
		src.zombify()
		src.client.color = null

/mob/living/carbon/human/proc/update_all_zombie_icons()
	var/ZMB
	var/is_zombie = TRUE
	if(iszombie(src))
		ZMB = image('icons/mob/mob.dmi', loc = src, icon_state = "zombie")
	else
		ZMB = image('icons/mob/mob.dmi', loc = src, icon_state = "zombie2")
		is_zombie = FALSE
	for(var/mob/living/carbon/human/HH in zombies)
		if(iszombie(HH))
			var/I = image('icons/mob/mob.dmi', loc = HH, icon_state = "zombie")
			if(src.client && is_zombie)
				src.client.images += I
			if(HH.client)
				HH.client.images += ZMB
		else if(HH.becoming_zombie && is_zombie)
			var/I = image('icons/mob/mob.dmi', loc = HH, icon_state = "zombie2")
			if(src.client)
				src.client.images += I

/mob/living/carbon/human/proc/unzombify()
	set_species("Human")
	see_in_dark = 2
	sight &= ~SEE_MOBS
	src.verbs -= /mob/living/carbon/human/proc/supersuicide
	zombies.Remove(src)
	update_all_zombie_icons()
	update_icons()
	src << "\red<font size=3>You have been cured from being a screamer!"
/*
/mob/living/carbon/human/proc/zombie_bit(var/mob/living/carbon/human/biter)
	var/mob/living/carbon/human/biten = src

	visible_message("\red <b>[biter.name] bites [name]!</b>")

	if(biten.species && biten.species.flags & IS_SYNTHETIC)
		return

	if(!biter.species.name == "Zombie")
		return

	if(stat > 1)//dead: it takes time to reverse death, but there is no chance of failure
		sleep(50)
		zombify()
		return

	if((istype(biten.wear_suit, /obj/item/clothing/suit/bio_suit) || istype(biten.wear_suit, /obj/item/clothing/suit/space)) || (istype(biten.head, /obj/item/clothing/head/bio_hood) || istype(biten.head, /obj/item/clothing/head/space)))
		if((istype(biten.head, /obj/item/clothing/head/bio_hood) || istype(biten.head, /obj/item/clothing/head/space)) && (istype(biten.wear_suit, /obj/item/clothing/suit/bio_suit) || istype(biten.wear_suit, /obj/item/clothing/suit/space)))
			if(prob(70))
				visible_message("\red [biter.name]'s suit protects [biter.name] from the bite!")
				return
		else if(prob(50))
			visible_message("\red [biter.name]'s suit protects [biter.name] from the bite!")
			return
	if(zombieimmune)
		return
	zombie_infect()
*/

/mob/living/carbon/human/proc/zombie_infect()
	if(master_mode == "holywar" || check_perk(/datum/perk/screamerimmunity))
		return
	else
		if(!isVampire && !src?.mind?.changeling)
			var/datum/disease2/disease/D = new /datum/disease2/disease
			D.makezombie()
			D.infectionchance = 1
			virus2["[D.uniqueID]"] = D
			becoming_zombie = 1
			zombies.Add(src)
			update_all_zombie_icons()

/client/proc/admin_infect_zombie(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Infect Mob Zombie"

	if(!src.holder)
		src << "Only administrators may use this command."
		return

	log_admin("[key_name(usr)] infected [key_name(M)] with a zombie disease.")
	message_admins("[key_name_admin(usr)] infected [key_name_admin(M)] 	with a zombie disease.", 1)
	if(ishuman(M))
		var/mob/living/carbon/human/Z = M
		Z.zombie_infect()
	else
		usr << "\blue This mob is not a human!"


/mob/living/carbon/human/proc/traitor_infect()
	becoming_zombie = 1
	zombieleader = 1
	src.verbs += /mob/living/carbon/human/proc/zombierelease
	src << "You have been implanted with a chemical canister you can either release it yourself or wait until it activates."
	sleep(3000)
	if(becoming_zombie)
		zombify()

/mob/living/carbon/human/proc/supersuicide()
	set name = "Zombie suicide"
	set hidden = 0
	if(zombie == 1)
		switch(alert(usr,"Are you sure you wanna die?",,"Yes","No"))
			if("Yes")
				fireloss = 999
				src << "\red You died suprised?"
				return
			else
				src << "\red You live to see another day."
				return
	else
		src << "\red Only for zombies."

/mob/living/carbon/human/proc/zombierelease()
	set name = "Zombify"
	set desc = "Turns you into a zombie"
	if(zombieleader)
		zombify()

