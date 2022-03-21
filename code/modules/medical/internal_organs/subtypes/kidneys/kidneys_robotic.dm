//criancaney robotica
/datum/organ/internal/kidney/robotic
	robotic = 2
	damagelevel = 0.8
	emplevel = list(40,15,10)
	desc = "Mechanical"
	removed_type = /obj/item/weapon/reagent_containers/food/snacks/organ/kidneys/prosthetic

/datum/organ/internal/kidney/robotic/process()
	germ_level = 0
	return