/obj/item/weapon/reagent_containers/pill/lifeweb/inaprovaline
	name = "Inaprovaline pill"
	icon_state = "pill19"
	list_reagents = list("inaprovaline" = 50)

/obj/item/weapon/reagent_containers/pill/lifeweb/dentrine
	name = "Dentrine pill"
	icon_state = "pill18"
	list_reagents = list("dentrine" = 50)

/obj/item/weapon/reagent_containers/pill/lifeweb/dentrine_fake
	name = "Dentrine pill"
	icon_state = "pill18"
	list_reagents = list("dob" = 50)

/obj/item/weapon/reagent_containers/pill/lifeweb/oxycodone
	name = "Oxycodone pill"
	icon_state = "pill18"
	list_reagents = list("oxycodone" = 50)

/obj/item/weapon/reagent_containers/pill/lifeweb/buffout
	name = "Buffout pill"
	icon_state = "bpill"
	list_reagents = list("buffout" = 50)

/obj/item/weapon/reagent_containers/pill/lifeweb/changa
	name = "Changa pill"
	desc = "Not safe for human consumption."
	icon_state = "bpill"
	list_reagents = list("changa" = 10)

/obj/item/weapon/reagent_containers/pill/lifeweb/mdma
	name = "MDMA pill"
	icon_state = "mpill"
	list_reagents = list("mdma" = 25)

/obj/item/weapon/reagent_containers/pill/lifeweb/mice69
	name = "MICE69 pill"
	icon_state = "pill13"
	list_reagents = list("mice" = 25)

/obj/item/weapon/reagent_containers/pill/lifeweb/vinici_us
	name = "Vinici-Us pill"
	icon_state = "r55"
	list_reagents = list("vinici-us" = 25)

/obj/item/weapon/reagent_containers/pill/lifeweb/mentats
	name = "Mentats pill"
	icon_state = "mpill"
	list_reagents = list("mentats" = 50)

/obj/item/weapon/reagent_containers/pill/lifeweb/blotter
	name = "blotter"
	icon_state = "blotter2"

/obj/item/weapon/reagent_containers/pill/lifeweb/blotter/New()
	..()
	icon_state = pick("blotter1","blotter2","blotter3","blotter4","blotter5","blotter6")
/obj/item/weapon/reagent_containers/pill/lifeweb/blotter/DOB
	list_reagents = list("dob" = 50)

/obj/item/weapon/reagent_containers/pill/lifeweb/blotter/ETHLOD
	list_reagents = list("ethlod" = 50)

/obj/item/weapon/reagent_containers/pill/lifeweb/blotter/vinici_us
	list_reagents = list("vinici-us" = 25)

/obj/item/weapon/storage/pill_bottle/mentats
	name = "Mentats pills"
	icon = 'chemical.dmi'
	icon_state = "mentats_can"

/obj/item/weapon/storage/pill_bottle/mentats/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/lifeweb/mentats( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/mentats( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/mentats( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/mentats( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/mentats( src )

/obj/item/weapon/storage/pill_bottle/buffout
	name = "Buffout pills"
	icon = 'chemical.dmi'
	icon_state = "buff_canister"

/obj/item/weapon/storage/pill_bottle/buffout/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/lifeweb/buffout( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/buffout( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/buffout( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/buffout( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/buffout( src )

/obj/item/weapon/storage/pill_bottle/changa
	name = "Changa pills"
	desc = "A label reads: <b>BANNED in <i>29<i> FORTRESSES in EVERGREEN.</b> CAUSES EXTREME RAGE AND HYPERVENTILATION. DO NOT GIVE TO KIDS UNDER 6 YEARS OLD."
	icon = 'chemical.dmi'
	icon_state = "buff_canister"

/obj/item/weapon/storage/pill_bottle/changa/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/lifeweb/changa( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/changa( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/changa( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/changa( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/changa( src )

/obj/item/weapon/storage/pill_bottle/mdma
	name = "mdma pills"
	icon = 'chemical.dmi'
	icon_state = "buff_canister"

/obj/item/weapon/storage/pill_bottle/mdma/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/lifeweb/mdma( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/mdma( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/mdma( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/mdma( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/mdma( src )


/obj/item/weapon/storage/pill_bottle/mice69
	name = "mice69 pills"
	icon = 'chemical.dmi'
	icon_state = "buff_canister"

/obj/item/weapon/storage/pill_bottle/mice69/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/lifeweb/mice69( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/mice69( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/mice69( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/mice69( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/mice69( src )
	new /obj/item/weapon/reagent_containers/pill/lifeweb/mice69( src )
