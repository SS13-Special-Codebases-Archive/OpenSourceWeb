// Plant analyzer

/obj/item/device/analyzer/plant_analyzer
	name = "plant analyzer"
	icon = 'icons/obj/device.dmi'
	icon_state = "hydro"
	item_state = "analyzer"

	attack_self(mob/user as mob)
		return 0

// ********************************************************
// Here's all the seeds (plants) that can be used in hydro
// ********************************************************

/obj/item/seeds
	name = "pack of seeds"
	icon = 'icons/obj/seeds.dmi'
	icon_state = "seed" // unknown plant seed - these shouldn't exist in-game
	flags = FPRINT | TABLEPASS
	w_class = 1.0 // Makes them pocketable
	var/mypath = "/obj/item/seeds"	
	var/plantname = "Plants"
	var/productname = ""
	var/species = ""
	var/lifespan = 0
	var/endurance = 0
	var/maturation = 0
	var/production = 0
	var/yield = 0 // If is -1, the plant/shroom/weed is never meant to be harvested
	var/oneharvest = 0
	var/potency = -1
	var/growthstages = 0
	var/plant_type = 0 // 0 = 'normal plant'; 1 = weed; 2 = shroom

/obj/item/seeds/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (istype(O, /obj/item/device/analyzer/plant_analyzer))
		user << "*** <B>[plantname]</B> ***"
		user << "-Plant Endurance: \blue [endurance]"
		user << "-Plant Lifespan: \blue [lifespan]"
		if(yield != -1)
			user << "-Plant Yield: \blue [yield]"
		user << "-Plant Production: \blue [production]"
		if(potency != -1)
			user << "-Plant Potency: \blue [potency]"
		return
	..() // Fallthrough to item/attackby() so that bags can pick seeds up

/obj/item/seeds/chiliseed
	name = "pack of chili seeds"
	desc = "These seeds grow into chili plants. HOT! HOT! HOT!"
	icon_state = "seed-chili"
	mypath = "/obj/item/seeds/chiliseed"
	species = "chili"
	plantname = "Chili Plants"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/chili"
	lifespan = 20
	endurance = 15
	maturation = 5
	production = 5
	yield = 4
	potency = 20
	plant_type = 0
	growthstages = 6

/obj/item/seeds/apple
	name = "pack of apple seeds"
	desc = ""
	icon_state = "apple"
	mypath = "/obj/item/seeds/apple"
	species = "apple"
	plantname = "Apple"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/apple"
	lifespan = 20
	endurance = 15
	maturation = 5
	production = 5
	yield = 4
	potency = 20
	plant_type = 0
	growthstages = 6

/obj/item/seeds/tomato
	name = "pack of tomato seeds"
	desc = ""
	icon_state = "tomato"
	mypath = "/obj/items/seeds/tomato"
	species = "tomato"
	plantname = "Tomato"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/tomato"
	lifespan = 20
	endurance = 15
	maturation = 5
	production = 5
	yield = 4
	potency = 20
	plant_type = 0
	growthstages = 6

/obj/item/seeds/carrot
	name = "pack of carrot seeds"
	desc = ""
	icon_state = "carrot"
	mypath = "/obj/items/seeds/carrot"
	species = "carrot"
	plantname = "Carrot"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/carrot"
	lifespan = 20
	endurance = 15
	maturation = 5
	production = 5
	yield = 4
	potency = 20
	plant_type = 0
	growthstages = 6

/obj/item/seeds/corn
	name = "pack of corn seeds"
	desc = ""
	icon_state = "corn"
	mypath = "/obj/items/seeds/corn"
	species = "corn"
	plantname = "Corn"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/corn"
	lifespan = 20
	endurance = 15
	maturation = 5
	production = 5
	yield = 4
	potency = 20
	plant_type = 0
	growthstages = 6

/obj/item/seeds/potato
	name = "pack of potato seeds"
	desc = ""
	icon_state = "potato"
	mypath = "/obj/items/seeds/potato"
	species = "potato"
	plantname = "Potato"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/potato"
	lifespan = 20
	endurance = 15
	maturation = 5
	production = 5
	yield = 4
	potency = 20
	plant_type = 0
	growthstages = 6

/obj/item/seeds/pumpkin
	name = "pack of pumpkin seeds"
	desc = ""
	icon_state = "pumpkin"
	mypath = "/obj/items/seeds/pumpkin"
	species = "pumpkin"
	plantname = "Pumpkin"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/pumpkin"
	lifespan = 20
	endurance = 15
	maturation = 5
	production = 5
	yield = 4
	potency = 20
	plant_type = 0
	growthstages = 6

/obj/item/seeds/wheat
	name = "pack of wheat seeds"
	desc = ""
	icon_state = "wheat"
	mypath = "/obj/items/seeds/wheat"
	species = "wheat"
	plantname = "Wheat"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/wheat"
	lifespan = 20
	endurance = 15
	maturation = 5
	production = 5
	yield = 4
	potency = 20
	plant_type = 0
	growthstages = 6

/obj/item/seeds/eggplant
	name = "pack of eggplant seeds"
	desc = ""
	icon_state = "eggplant"
	mypath = "/obj/items/seeds/eggplant"
	species = "eggplant"
	plantname = "eggplant"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/eggplant"
	lifespan = 20
	endurance = 15
	maturation = 5
	production = 5
	yield = 4
	potency = 20
	plant_type = 0
	growthstages = 6

/obj/item/seeds/sweetpod
	name = "pack of sweet pod seeds"
	desc = ""
	icon_state = "sweetpod"
	mypath = "/obj/items/seeds/sweetpod"
	species = "sweet pod"
	plantname = "Sweet Pod"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/sweetpod"
	lifespan = 20
	endurance = 15
	maturation = 5
	production = 5
	yield = 4
	potency = 20
	plant_type = 0
	growthstages = 6

/obj/item/seeds/pigtail
	name = "pack of pigtail seeds"
	desc = ""
	icon_state = "pigtail"
	mypath = "/obj/items/seeds/pigtail"
	species = "pigtail"
	plantname = "Pigtail"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/pigtail"
	lifespan = 20
	endurance = 15
	maturation = 5
	production = 5
	yield = 4
	potency = 20
	plant_type = 0
	growthstages = 6

/obj/item/seeds/beet
	name = "pack of beet seeds"
	desc = ""
	icon_state = "beet"
	mypath = "/obj/items/seeds/beet"
	species = "beet"
	plantname = "Beet"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/beet"
	lifespan = 20
	endurance = 15
	maturation = 5
	production = 5
	yield = 4
	potency = 20
	plant_type = 0
	growthstages = 6

/obj/item/seeds/turnip
	name = "pack of turnip seeds"
	desc = ""
	icon_state = "turnip"
	mypath = "/obj/items/seeds/turnip"
	species = "turnip"
	plantname = "Turnip"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/turnip"
	lifespan = 20
	endurance = 15
	maturation = 5
	production = 5
	yield = 4
	potency = 20
	plant_type = 0
	growthstages = 6

/obj/item/seeds/onion
	name = "pack of onion seeds"
	desc = ""
	icon_state = "onion"
	mypath = "/obj/items/seeds/onion"
	species = "onion"
	plantname = "Onion"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/onion"
	lifespan = 20
	endurance = 15
	maturation = 5
	production = 5
	yield = 4
	potency = 20
	plant_type = 0
	growthstages = 6

/obj/item/seeds/garlic
	name = "pack of garlic seeds"
	desc = ""
	icon_state = "garlic"
	mypath = "/obj/items/seeds/garlic"
	species = "garlic"
	plantname = "Garlic"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/garlic"
	lifespan = 20
	endurance = 15
	maturation = 5
	production = 5
	yield = 4
	potency = 20
	plant_type = 0
	growthstages = 6


// *************************************
// Pestkiller defines for hydroponics
// *************************************

/obj/item/pestkiller
	name = "bottle of pestkiller"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	flags = FPRINT |  TABLEPASS
	var/toxicity = 0
	var/PestKillStr = 0
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)

/obj/item/pestkiller/carbaryl
	name = "bottle of carbaryl"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	flags = FPRINT |  TABLEPASS
	toxicity = 4
	PestKillStr = 2
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)

/obj/item/pestkiller/lindane
	name = "bottle of lindane"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle18"
	flags = FPRINT |  TABLEPASS
	toxicity = 6
	PestKillStr = 4
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)

/obj/item/pestkiller/phosmet
	name = "bottle of phosmet"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle15"
	flags = FPRINT |  TABLEPASS
	toxicity = 8
	PestKillStr = 7
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)

// *************************************
// Hydroponics Tools
// *************************************

/obj/item/weapon/weedspray // -- Skie
	desc = "It's a toxic mixture, in spray form, to kill small weeds."
	icon = 'icons/obj/hydroponics.dmi'
	name = "weed-spray"
	icon_state = "weedspray"
	item_state = "spray"
	flags = TABLEPASS | OPENCONTAINER | FPRINT | NOBLUDGEON
	slot_flags = SLOT_BELT
	throwforce = 4
	w_class = 2.0
	throw_speed = 2
	throw_range = 10
	var/toxicity = 4
	var/WeedKillStr = 2

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is huffing the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return (TOXLOSS)

/obj/item/weapon/pestspray // -- Skie
	desc = "It's some pest eliminator spray! <I>Do not inhale!</I>"
	icon = 'icons/obj/hydroponics.dmi'
	name = "pest-spray"
	icon_state = "pestspray"
	item_state = "spray"
	flags = TABLEPASS | OPENCONTAINER | FPRINT | NOBLUDGEON
	slot_flags = SLOT_BELT
	throwforce = 4
	w_class = 2.0
	throw_speed = 2
	throw_range = 10
	var/toxicity = 4
	var/PestKillStr = 2

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is huffing the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return (TOXLOSS)

/obj/item/weapon/minihoe // -- Numbers
	name = "mini hoe"
	desc = "It's used for removing weeds or scratching your back."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hoe"
	item_state = "hoe"
	flags = FPRINT | TABLEPASS | CONDUCT | NOBLUDGEON
	force = 5.0
	throwforce = 7.0
	w_class = 2.0
	m_amt = 50
	attack_verb = list("slashed", "sliced", "cut", "clawed")

// *************************************
// Weedkiller defines for hydroponics
// *************************************

/obj/item/weedkiller
	name = "bottle of weedkiller"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	flags = FPRINT |  TABLEPASS
	var/toxicity = 0
	var/WeedKillStr = 0

/obj/item/weedkiller/triclopyr
	name = "bottle of glyphosate"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	flags = FPRINT |  TABLEPASS
	toxicity = 4
	WeedKillStr = 2

/obj/item/weedkiller/lindane
	name = "bottle of triclopyr"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle18"
	flags = FPRINT |  TABLEPASS
	toxicity = 6
	WeedKillStr = 4

/obj/item/weedkiller/D24
	name = "bottle of 2,4-D"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle15"
	flags = FPRINT |  TABLEPASS
	toxicity = 8
	WeedKillStr = 7

// *************************************
// Nutrient defines for hydroponics
// *************************************

/obj/item/nutrient
	name = "bottle of nutrient"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	flags = FPRINT |  TABLEPASS
	w_class = 1.0
	var/mutmod = 0
	var/yieldmod = 0
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)

/obj/item/nutrient/ez
	name = "bottle of E-Z-Nutrient"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	flags = FPRINT |  TABLEPASS
	mutmod = 1
	yieldmod = 1
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)

/obj/item/nutrient/l4z
	name = "bottle of Left 4 Zed"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle18"
	flags = FPRINT |  TABLEPASS
	mutmod = 2
	yieldmod = 0
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)

/obj/item/nutrient/rh
	name = "bottle of Robust Harvest"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle15"
	flags = FPRINT |  TABLEPASS
	mutmod = 0
	yieldmod = 2
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)


