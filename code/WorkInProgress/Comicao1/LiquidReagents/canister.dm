/obj/reagent/CANISTER
	depth = 30
	temperature = 20

/obj/reagent/WELL
	depth = 165
	temperature = 20

/obj/canister
	icon = 'canister.dmi'
	icon_state = "air_canister"

/obj/canister/New()
	while(1)
		sleep(5)
		if(src:loc:liquid)
			src:loc:liquid:depth += 15
		if(!src:loc:liquid)
			new/obj/reagent/CANISTER(src.loc)