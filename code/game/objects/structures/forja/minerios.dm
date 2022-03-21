/***************************************************
****************************************************
*******************ORES PURO************************
****************************************************
****************************************************/

/obj/item/weapon/ore
	force = 8

/obj/item/weapon/ore/lw/ironlw
	name = "iron ore"
	icon = 'icons/mining.dmi'
	icon_state = "ironore"
	origin_tech = "materials=1"
	points = 1
	refined_type = /obj/item/weapon/ore/refined/lw/ironlw
	item_worth = 15

/obj/item/weapon/ore/lw/copperlw
	name = "copper ore"
	icon = 'icons/mining.dmi'
	icon_state = "copper"
	origin_tech = "materials=1"
	points = 1
	refined_type = /obj/item/weapon/ore/refined/lw/copperlw
	item_worth = 3


/obj/item/weapon/ore/lw/silverlw
	name = "silver ore"
	icon = 'icons/mining.dmi'
	icon_state = "Silver ore"
	origin_tech = "materials=1"
	points = 1
	refined_type = /obj/item/weapon/ore/refined/lw/silverlw
	item_worth = 30
	silver = TRUE


/obj/item/weapon/ore/lw/goldlw
	name = "gold ore"
	icon = 'icons/mining.dmi'
	icon_state = "Gold ore"
	origin_tech = "materials=1"
	points = 1
	refined_type = /obj/item/weapon/ore/refined/lw/goldlw
	item_worth = 50


/obj/item/weapon/ore/lw/adamantinelw
	name = "adamantine ore"
	icon = 'icons/mining.dmi'
	icon_state = "Adamantine ore"
	origin_tech = "materials=1"
	points = 1
	refined_type = /obj/item/weapon/ore/refined/lw/adamantinelw
	item_worth = 100


/obj/item/weapon/ore/lw/coal
	name = "coal"
	icon = 'icons/mining.dmi'
	icon_state = "coal"
	origin_tech = "materials=1"
	points = 1
	item_worth = 8


/***************************************************
****************************************************
*******************ORES REFINADOS*******************
****************************************************
****************************************************/

/obj/item/weapon/ore/refined/lw
	name = "You shouldn't be seeing this."
	var/temperatura = 0 //Temperatura da barra
	var/itemToBecome = null //Qual item foi escolhido pra barra virar
	var/percentageToBecome = 0 // Quanto falta pra barra ficar pronta, máximo é definido como 100

	var/qualidadeBarra = 0 // Qualidade da barra
	var/percentageToUpgrade = 0

	var/amountsDone = 1
	var/damage = 0

	var/list/coisas_possiveis = list(
	list(name = "meh", path = /obj/item/weapon/claymore)
	)
	var/list/medals = list()

/obj/item/weapon/ore/refined/lw/copperlw
	name = "copper ingot"
	icon = 'icons/mining.dmi'
	icon_state = "copper_ingot"
	origin_tech = "materials=1"
	points = 20
	item_worth = 5

	coisas_possiveis = list(
	list(name = "Copper Cross", path = /obj/item/clothing/head/amulet/holy/cross/copper, amount=3),
	list(name = "Bronze Axe", path = /obj/item/weapon/hatchet/bronze, amount=1),
	list(name = "Bronze Throwing Knife", path = /obj/item/weapon/throwingknife, amount=3),
	list(name = "Bronze Buckler Shield", path = /obj/item/weapon/shield/copper, amount=1),
	list(name = "Copper Sword", path = /obj/item/weapon/claymore/copper, amount=1),
	list(name = "Copper Dagger", path = /obj/item/weapon/kitchen/utensil/knife/dagger/copper, amount=3),
	list(name = "Bronze Mace", path = /obj/item/weapon/melee/classic_baton/club/bronze, amount=1),
	list(name = "Bronze Spear", path = /obj/item/weapon/claymore/cspear, amount=1),
	list(name = "Copper Dildo", path = /obj/item/weapon/dildo/copper, amount=3),
	list(name = "Copper Earring", path = /obj/item/clothing/ears/earring/copper, amount=2),
	list(name = "Copper Dildo", path = /obj/item/weapon/dildo/copper, amount=1),
	list(name = "Copper Bracer", path = /obj/item/clothing/wrist/bracer, amount=3)
	)


/obj/item/weapon/ore/refined/lw/silverlw
	name = "silver ingot"
	icon = 'icons/mining.dmi'
	icon_state = "silver_ingot"
	origin_tech = "materials=1"
	points = 20
	item_worth = 37
	silver = TRUE

	coisas_possiveis = list(
	list(name = "Silver Dagger", path = /obj/item/weapon/kitchen/utensil/knife/dagger/silver, amount=3),
	list(name = "Bastard Sword", path = /obj/item/weapon/claymore/bastard/silver, amount=1),
	list(name = "Silver Throwing knife", path = /obj/item/weapon/throwingknife/silver, amount=3),
	list(name = "Silver Sword", path = /obj/item/weapon/claymore/silver, amount=1),
	list(name = "Silver Bastard Sword", path = /obj/item/weapon/claymore/bastard/silver, amount=1),
	list(name = "Silver Goblet", path = /obj/item/weapon/reagent_containers/glass/goblet/silver, amount= 2),
	list(name = "Silver Earrings", path = /obj/item/clothing/ears/earring/silver, amount = 2)
	)


/obj/item/weapon/ore/refined/lw/goldlw
	name = "gold ingot"
	icon = 'icons/mining.dmi'
	icon_state = "gold_ingot"
	origin_tech = "materials=1"
	points = 20
	item_worth = 50

	coisas_possiveis = list(
	list(name = "Golden Sword", path = /obj/item/weapon/claymore/golden, amount=1),
	list(name = "Colar de Ouro", path = /obj/item/clothing/head/amulet/goldeneck, amount=2),
	list(name = "Golden Breastplate", path = /obj/item/clothing/suit/armor/vest/gold_breastplate, amount=1),
	list(name = "Golden Shield", path = /obj/item/weapon/shield/golden, amount=1),
	list(name = "Golden Dildo", path = /obj/item/weapon/dildo/goldeb, amount=3),
	list(name = "Golden Censer", path = /obj/item/weapon/censer, amount=3),
	list(name = "Golden Teeth", path = /obj/item/stack/teeth/human/golden, amount= 7),
	list(name = "Golden Bracer", path = /obj/item/clothing/wrist/bracer/gold, amount= 2),
	list(name = "Golden Goblet", path = /obj/item/weapon/reagent_containers/glass/goblet/gold, amount= 2),
	list(name = "Golden Earrings", path = /obj/item/clothing/ears/earring/gold, amount = 2)
	)

	medals = list(list(name = "Golden Medal", path = /obj/item/medal, amount= 1))

/obj/item/weapon/ore/refined/lw/goldlw/firethorn
	name = "carved gold ingot"
	desc = "From Firethorn's treasury."
	icon_state = "gold_ingot_ravenheart"

/obj/item/weapon/censer
	name = "gold censer"
	desc = "A gold censer used by religious folks."
	icon = 'icons/life/golden_weapons.dmi'
	icon_state = "gcenser"
	item_state = "censer"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 6.0
	w_class = 4
	slot_flags = SLOT_BELT
	throwforce = 4.0
	throw_speed = 4
	throw_range = 4
	m_amt = 15000
	origin_tech = "materials=2;combat=1"
	attack_verb = list("bashed")

/obj/item/weapon/ore/refined/lw/adamantinelw
	name = "adamantine ingot"
	icon = 'icons/mining.dmi'
	icon_state = "adamantine_ingot"
	origin_tech = "materials=1"
	points = 20
	item_worth = 100

	coisas_possiveis = list(
	list(name = "Adamantium Plate Armor", path = /obj/item/clothing/suit/armor/vest/aplate, amount=1),
	list(name = "Adamantium Dagger", path = /obj/item/weapon/kitchen/utensil/knife/dagger/adamantium, amount=3),
	list(name = "Adamantium Throwing", path = /obj/item/weapon/kitchen/utensil/knife/dagger/adamantium/throwing, amount=3),
	list(name = "Adamantium Sword", path = /obj/item/weapon/claymore/adamantium, amount=1),
	list(name = "Adamantium Helmet", path = /obj/item/clothing/head/helmet/lw/ahelmet, amount=2)
	)

/obj/item/weapon/ore/refined/lw/steellw
	name = "steel ingot"
	icon = 'icons/mining.dmi'
	icon_state = "steel_ingot"
	origin_tech = "materials=1"
	points = 20
	item_worth = 25

	coisas_possiveis = list(
	list(name = "Steel Gauntlets", path = /obj/item/clothing/gloves/combat/gauntlet/steel, amount=3),
	list(name = "Hauberk", path = /obj/item/clothing/suit/armor/vest/security/hauberk, amount=1),
	list(name = "Hauberk Hood", path = /obj/item/clothing/head/helmet/lw/chainhelm, amount=1),
	list(name = "Steel Rapier", path = /obj/item/weapon/claymore/rapier, amount = 1)
	)

/obj/item/weapon/ore/refined/lw/ironlw
	name = "iron ingot"
	icon = 'icons/mining.dmi'
	icon_state = "iron_ingot"
	origin_tech = "materials=1"
	points = 20
	item_worth = 20

	coisas_possiveis = list(
	list(name = "Iron Boots", path =/obj/item/clothing/shoes/lw/iron, amount=3),
	list(name = "Long Sword", path = /obj/item/weapon/claymore, amount=1),
	list(name = "Bastard Sword", path = /obj/item/weapon/claymore/bastard, amount=1),
	list(name = "Sabre", path = /obj/item/weapon/claymore/sabre, amount=1),
	list(name = "Bardiche", path = /obj/item/weapon/claymore/bardiche, amount=1),
	list(name = "Spear", path = /obj/item/weapon/claymore/spear, amount=1),
	list(name = "Falchion", path = /obj/item/weapon/claymore/falchion, amount=1),
	list(name = "Axe", path = /obj/item/weapon/hatchet, amount=1),
	list(name = "Pitchfork", path = /obj/item/weapon/minihoe, amount=3),
	list(name = "Iron Plate Armor", path = /obj/item/clothing/suit/armor/vest/iron_plate, amount=1),
	list(name = "Iron Mask", path = /obj/item/clothing/mask/ironmask, amount=3),
	list(name = "Iron Cuirass", path = /obj/item/clothing/suit/armor/vest/iron_cuirass, amount=1),
	list(name = "Iron Breastplate", path = /obj/item/clothing/suit/armor/vest/iron_breastplate, amount=1),
	list(name = "Dildo", path = /obj/item/weapon/dildo, amount=3),
	list(name = "Elite Helmet", path = /obj/item/clothing/head/helmet/lw/elitehelmet, amount=2),
	list(name = "Elite Helmet II", path = /obj/item/clothing/head/helmet/lw/elitehelmet2, amount=2),
	list(name = "Skull Open Iron Helmet", path = /obj/item/clothing/head/helmet/lw/openskulliron, amount=2),
	list(name = "Squire Armor", path = /obj/item/clothing/suit/armor/vest/squire, amount=1),
	list(name = "Sledgehammer", path = /obj/item/weapon/sledgehammer, amount=1),
	list(name = "Carver Hamer", path = /obj/item/weapon/carverhammer, amount=1),
	list(name = "Tongs", path = /obj/item/weapon/alicate, amount=1),
	list(name = "Shovel", path = /obj/item/weapon/shovel, amount=1),
	list(name = "Pickaxe", path = /obj/item/weapon/pickaxe, amount=1),
	list(name = "Club", path = /obj/item/weapon/melee/classic_baton/club, amount=1),
	list(name = "Light Club", path = /obj/item/weapon/melee/classic_baton/smallclub, amount=1),
	list(name = "Dagger", path = /obj/item/weapon/kitchen/utensil/knife/dagger, amount=2),
	list(name = "Combat Knife", path = /obj/item/weapon/kitchen/utensil/knife/combat, amount=2),
	list(name = "Knife", path = /obj/item/weapon/kitchenknife, amount=4),
	list(name = "Fork", path = /obj/item/weapon/kitchen/utensil/fork, amount = 4),
	list(name = "Spoon", path = /obj/item/weapon/kitchen/utensil/spoon, amount = 4),
	list(name = "Handcuffs", path = /obj/item/weapon/handcuffs, amount=3),
	list(name = "Chain", path = /obj/item/weapon/melee/chainofcommand, amount=2),
	list(name = "Klevetz", path = /obj/item/weapon/melee/classic_baton/klevetz, amount=1),
	list(name = "Crossbow", path = /obj/item/weapon/crossbow, amount=1),
	list(name = "Bolt", path = /obj/item/weapon/arrow, amount=4),
	list(name = "Shield", path = /obj/item/weapon/shield/wood, amount=1),
	list(name = "Cross", path = /obj/item/clothing/head/amulet/holy/cross, amount=3),
	list(name = "Iron Gorget", path = /obj/item/clothing/head/amulet/gorget/iron, amount=3),
	list(name = "Sewer Hatch", path =/obj/item/weapon/melee/classic_baton/sewer_hatch, amount=1),
	list(name = "Iron Mace", path = /obj/item/weapon/melee/classic_baton/mace, amount = 1),
	list(name = "Chisel", path = /obj/item/weapon/chisel, amount = 3),
	list(name = "Bracer", path = /obj/item/clothing/wrist/bracer/iron, amount = 3)
	)


/obj/item/weapon/ore/refined/lw/New()
	..()
	processing_objects.Add(src)

/obj/item/weapon/ore/refined/lw/Destroy()
	..()
	processing_objects.Remove(src)

/obj/item/weapon/ore/refined/lw/process()
	if(temperatura >= 1)
		temperatura--
		temperatura--
		temperatura--

/obj/item/weapon/ore/refined/lw/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/alicate) && isturf(src.loc))
		var/obj/item/weapon/alicate/A = W
		var/obj/item/weapon/ore/refined/lw/I = src
		if(islist(A.contents) && !isemptylist(A.contents))	return
		if(user.get_inactive_hand() == I)	user.drop_item_vv(sound = 0)
		A.contents += I
		A.update_icon()


/obj/item/weapon/alicate/attack_self(mob/living/user)
	if(contents.len && subtypesof(/obj/item/weapon/ore/refined/lw))
		var/obj/item/weapon/ore/refined/lw/lw = safepick(contents)
		lw.loc = user.loc
		lw.temperatura = 0
		contents.Cut()
		update_icon()