/obj/item/weapon/reagent_containers/food/snacks/organ/verb/attach_me()
	set name = "Attachself"
	set category = "Object"

	var/mob/living/carbon/human/user = usr

	var/datum/organ/external/affected =  user.get_organ(organ_data.parent_organ)

	user.drop_item(src)

	var/datum/reagent/blood/transplant_blood = locate(/datum/reagent/blood) in src.reagents.reagent_list
	if(!transplant_blood)
		src.organ_data.transplant_data = list()
		src.organ_data.transplant_data["species"] =    user.species.name
		src.organ_data.transplant_data["blood_type"] = user.dna.b_type
		src.organ_data.transplant_data["blood_DNA"] =  user.dna.unique_enzymes
	else
		src.organ_data.transplant_data = list()
		src.organ_data.transplant_data["species"] =    transplant_blood.data["species"]
		src.organ_data.transplant_data["blood_type"] = transplant_blood.data["blood_type"]
		src.organ_data.transplant_data["blood_DNA"] =  transplant_blood.data["blood_DNA"]

	src.organ_data.organ_holder = null
	src.organ_data.owner = user
	user.internal_organs |= src.organ_data
	affected.internal_organs |= src.organ_data
	user.internal_organs_by_name[src.organ_tag] = src.organ_data
	src.replaced(user)
