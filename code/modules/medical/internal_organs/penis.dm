//cara eu sem querer castrei o code
/datum/organ/internal/penis
	name = "penis"
	parent_organ = "groin"
	removed_type = /obj/item/weapon/reagent_containers/food/snacks/organ/internal/penis

/obj/item/weapon/reagent_containers/food/snacks/organ/internal/penis
    name = "penis"
    icon_state = "penis"
    gender = PLURAL
    var/potenzia = 10

/obj/item/weapon/reagent_containers/food/snacks/organ/internal/penis/New()
	desc = "It's [potenzia] cm long."
	..()

/obj/item/weapon/reagent_containers/food/snacks/organ/internal/penis/proc/set_potenzia(var/P_size)
	potenzia = P_size
	desc = "It's [potenzia] cm long."
