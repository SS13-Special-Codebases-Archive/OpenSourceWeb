/obj/item/weapon/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of meat"
	icon_state = "meat"
	health = 180
	filling_color = "#FF1C1C"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/rawcutlet
	slices_num = 3
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		src.bitesize = 3


/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh
	name = "synthetic meat"
	desc = "A synthetic slab of flesh."

/obj/item/weapon/reagent_containers/food/snacks/meat/human
	name = "meat"
	var/subjectname = ""
	var/subjectjob = null


/obj/item/weapon/reagent_containers/food/snacks/meat/human/On_Consume()
	..()
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		H.add_event("cannibal", /datum/happiness_event/nutrition/humanflesh)
/obj/item/weapon/reagent_containers/food/snacks/meat/monkey
	//same as plain meat

/obj/item/weapon/reagent_containers/food/snacks/meat/corgi
	name = "Corgi meat"
	desc = "Tastes like... well you know..."