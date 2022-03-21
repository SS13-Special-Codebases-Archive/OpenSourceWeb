/datum/organ/internal/eyes/robotic
	damagelevel = 0.8
	emplevel = list(40,15,10)
	desc = "Mechanical"
	removed_type = /obj/item/weapon/reagent_containers/food/snacks/organ/eyes/prosthetic

/datum/organ/internal/eyes/robotic/process()
	germ_level = 0
	if(is_bruised())
		owner.eye_blurry = 20
	if(is_broken())
		owner.eye_blind = 20
