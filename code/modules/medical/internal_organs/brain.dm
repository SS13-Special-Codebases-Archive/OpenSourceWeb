//cerebro (orgao do thuxtk)
/datum/organ/internal/brain
	name = "brain"
	parent_organ = "head"
	removed_type = /obj/item/weapon/reagent_containers/food/snacks/organ/brain
	min_bruised_damage = 15
	min_broken_damage = 40			//30 was too little
	vital = 1

/datum/organ/internal/brain/mechanize()
	new /datum/organ/internal/brain/robotic(owner)
	return

/datum/organ/internal/brain/take_damage(amount, var/silent=0)
	..()
	if(damage > 50)
		owner.death()
/*	if (!silent)
		owner.custom_pain("<span class='hugepain'>WHAT A PAIN!</span> <span class='combat'>My [name] hurts!</span>", 1)*/
