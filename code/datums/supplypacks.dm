//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//NOTE: hidden packs only show up when the computer has been hacked.
//ANOTER NOTE: Contraband is obtainable through modified supplycomp circuitboards.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//NEW NOTE: Do NOT set the price of any crates below 7 points. Doing so allows infinite points.

var/list/all_supply_groups = list("Weapons", "Clothing", "Ammo","Hospitality","Engineering","Medical / Science","Hydroponics")

/datum/supply_packs
	var/name = null
	var/list/contains = list()
	var/manifest = ""
	var/amount = null
	var/cost = null
	var/containertype = null
	var/containername = null
	var/access = null
	var/hidden = 0
	var/contraband = 0
	var/is_weapon = FALSE
	var/group = "Operations"

/datum/supply_packs/New()
	manifest += "<ul>"
	if(!access)
		access = "[merchant]"
	for(var/path in contains)
		if(!path)	continue
		var/atom/movable/AM = new path()
		manifest += "<li>[AM.name]</li>"
		AM.loc = null	//just to make sure they're deleted by the garbage collector
	manifest += "</ul>"

/datum/supply_packs/food
	name = "Food crate"
	contains = list(/obj/item/weapon/reagent_containers/food/drinks/flour,
					/obj/item/weapon/reagent_containers/food/drinks/milk,
					/obj/item/weapon/reagent_containers/food/drinks/milk,
					/obj/item/weapon/storage/fancy/egg_box,
					/obj/item/weapon/reagent_containers/food/condiment/enzyme)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Food crate"
	group = "Hospitality"

/datum/supply_packs/food
	name = "Meat crate"
	contains = list(/obj/item/weapon/reagent_containers/food/snacks/meat,
	/obj/item/weapon/reagent_containers/food/snacks/meat,
	/obj/item/weapon/reagent_containers/food/snacks/meat,
	/obj/item/weapon/reagent_containers/food/snacks/meat,
	/obj/item/weapon/reagent_containers/food/snacks/meat)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Meat crate"
	group = "Hospitality"

/datum/supply_packs/satchels
	name = "Satchels crate (3)"
	contains = list(/obj/item/weapon/storage/backpack/satchel,/obj/item/weapon/storage/backpack/satchel,/obj/item/weapon/storage/backpack/satchel)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "Satchels crate"
	group = "Hospitality"

/datum/supply_packs/fancyhats
	name = "Fancy Hats"
	contains = list(/obj/item/clothing/head/chaperon, /obj/item/clothing/head/cargohat, /obj/item/clothing/head/pillbox, /obj/item/clothing/head/fedora, /obj/item/clothing/head/flatcap, /obj/item/clothing/head/ushanka, /obj/item/clothing/head/that)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "Fancy Hats crate"
	group = "Hospitality"

/datum/supply_packs/fancyhats
	name = "Noble Hats"
	contains = list(/obj/item/clothing/head/tarphat, /obj/item/clothing/head/noblehat, /obj/item/clothing/head/greentricorn, /obj/item/clothing/head/leathertricorn, /obj/item/clothing/head/escoffion1, /obj/item/clothing/head/escoffion2)
	cost = 80
	containertype = /obj/structure/closet/crate/secure
	containername = "Noble Hats crate"
	group = "Hospitality"


/datum/supply_packs/coldpack
	name = "Cold Pack"
	contains = list(/obj/item/weapon/storage/backpack/coldpack)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "Cold Pack crate"
	group = "Hospitality"

/datum/supply_packs/beltsatchel
	name = "Belt Satchels crate (4)"
	contains = list(/obj/item/weapon/storage/backpack/beltsatchel,/obj/item/weapon/storage/backpack/beltsatchel,/obj/item/weapon/storage/backpack/beltsatchel,/obj/item/weapon/storage/backpack/beltsatchel)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "Belt Satchels crate"
	group = "Hospitality"

/datum/supply_packs/cigar
	name = "Cigarretes crate (3)"
	contains = list(/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/storage/fancy/cigarettes)
	cost = 28
	containertype = /obj/structure/closet/crate/secure
	containername = "Cigarretes crate"
	group = "Hospitality"

/datum/supply_packs/beer
	name = "Beer crate (3)"
	contains = list(/obj/item/weapon/reagent_containers/glass/bottle/beer,/obj/item/weapon/reagent_containers/glass/bottle/beer,/obj/item/weapon/reagent_containers/glass/bottle/beer)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "Beer crate"
	group = "Hospitality"

/datum/supply_packs/boombosta
	name = "Boombox (1)"
	contains = list(/obj/item/weapon/ghettobox)
	cost = 120
	containertype = /obj/structure/closet/crate/secure
	containername = "Ghettobox crate"
	group = "Hospitality"

/datum/supply_packs/clothing
	name = "Clothing (4 pieces)"
	contains = list(/obj/item/clothing/under/rank/security, /obj/item/clothing/under/common/smith,/obj/item/clothing/under/common,/obj/item/clothing/under/rank/hydroponics,/obj/item/clothing/under/rank/hydroponics)
	cost = 80
	containertype = /obj/structure/closet/crate/secure
	containername = "Clothing Crate"
	group = "Clothing"

/datum/supply_packs/armor
	name = "Armor Kit (1)"
	contains = list(/obj/item/clothing/suit/storage/vest/flakjacket, /obj/item/clothing/suit/armor/vest/iron_cuirass, /obj/item/clothing/shoes/lw/iron, /obj/item/clothing/gloves/combat/gauntlet/steel)
	cost = 240
	containertype = /obj/structure/closet/crate/secure
	containername = "Armor Crate"
	group = "Clothing"

/datum/supply_packs/lighter
	name = "Lighter crate (6)"
	contains = list(/obj/item/weapon/flame/lighter,/obj/item/weapon/flame/lighter,/obj/item/weapon/flame/lighter,/obj/item/weapon/flame/lighter,/obj/item/weapon/flame/lighter,/obj/item/weapon/flame/lighter)
	cost = 12
	containertype = /obj/structure/closet/crate/secure
	containername = "Lighter crate"
	group = "Hospitality"

/datum/supply_packs/flashlight
	name = "flashlight crate (6)"
	contains = list(/obj/item/device/flashlight, /obj/item/device/flashlight, /obj/item/device/flashlight, /obj/item/device/flashlight, /obj/item/device/flashlight, /obj/item/device/flashlight)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "flashlight crate"
	group = "Hospitality"

/datum/supply_packs/wood
	name = "wood crate (6)"
	contains = list(/obj/item/stack/sheet/wood, /obj/item/stack/sheet/wood, /obj/item/stack/sheet/wood, /obj/item/stack/sheet/wood, /obj/item/stack/sheet/wood, /obj/item/stack/sheet/wood)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "wood crate"
	group = "Hospitality"

/datum/supply_packs/iron_crate
	name = "iron ore crate (6)"
	contains = list(/obj/item/weapon/ore/lw/ironlw, /obj/item/weapon/ore/lw/ironlw, /obj/item/weapon/ore/lw/ironlw, /obj/item/weapon/ore/lw/ironlw, /obj/item/weapon/ore/lw/ironlw, /obj/item/weapon/ore/lw/ironlw, /obj/item/weapon/ore/lw/ironlw)
	cost = 120
	containertype = /obj/structure/closet/crate/secure
	containername = "iron ore crate"
	group = "Hospitality"

/datum/supply_packs/coal_crate
	name = "coal crate (6)"
	contains = list(/obj/item/weapon/ore/lw/coal, /obj/item/weapon/ore/lw/coal, /obj/item/weapon/ore/lw/coal, /obj/item/weapon/ore/lw/coal, /obj/item/weapon/ore/lw/coal, /obj/item/weapon/ore/lw/coal, /obj/item/weapon/ore/lw/coal)
	cost = 90
	containertype = /obj/structure/closet/crate/secure
	containername = "coal crate"
	group = "Hospitality"

/datum/supply_packs/silver_crate
	name = "silver ore crate (6)"
	contains = list(/obj/item/weapon/ore/lw/silverlw, /obj/item/weapon/ore/lw/silverlw, /obj/item/weapon/ore/lw/silverlw, /obj/item/weapon/ore/lw/silverlw, /obj/item/weapon/ore/lw/silverlw, /obj/item/weapon/ore/lw/silverlw, /obj/item/weapon/ore/lw/silverlw)
	cost = 250
	containertype = /obj/structure/closet/crate/secure
	containername = "silver ore crate"
	group = "Hospitality"

/datum/supply_packs/coin_bags
	name = "Coin Bags"
	contains = list(/obj/item/weapon/storage/backpack/coinbag, /obj/item/weapon/storage/backpack/coinbag, /obj/item/weapon/storage/backpack/coinbag)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "coin bags crate"
	group = "Hospitality"

/datum/supply_packs/sheath
	name = "sheath crate"
	contains = list(/obj/item/sheath, /obj/item/sheath, /obj/item/sheath, /obj/item/sheath)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "sheath crate"
	group = "Hospitality"

/datum/supply_packs/paper
	name = "paper crate"
	contains = list(/obj/item/weapon/paper,/obj/item/weapon/paper,/obj/item/weapon/paper,/obj/item/weapon/paper,/obj/item/weapon/paper,/obj/item/weapon/paper,/obj/item/weapon/paper)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "paper crate"
	group = "Hospitality"

/datum/supply_packs/pig
	name = "Living Pig"
	contains = list()
	cost = 50
	containertype = /obj/structure/closet/crate/pig
	containername = "pig crate"
	group = "Hospitality"


/datum/supply_packs/cannabis
	name = "cannabis seeds"
	contains = list(/obj/item/seedsn/weed, /obj/item/seedsn/weed, /obj/item/seedsn/weed, /obj/item/seedsn/weed, /obj/item/seedsn/weed, /obj/item/clothing/mask/cigarette/weed, /obj/item/clothing/mask/cigarette/weed, /obj/item/clothing/mask/cigarette/weed)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "cannabis crate"
	group = "Hospitality"

/datum/supply_packs/sleepingbag
	name = "Sleeping Bags (x2)"
	contains = list(/obj/item/sleepingbag,/obj/item/sleepingbag)
	cost = 35
	containertype = /obj/structure/closet/crate/secure
	containername = "Sleeping Bags"
	group = "Hospitality"

/datum/supply_packs/adultmagazines
	name = "Adult Magazines (x3)"
	contains = list(/obj/item/adultmag/one,/obj/item/adultmag/two,/obj/item/adultmag/three)
	cost = 33
	containertype = /obj/structure/closet/crate/secure
	containername = "Adult Magazines"
	group = "Hospitality"

/datum/supply_packs/batterycell
	name = "Battery Cells (x3)"
	contains = list(/obj/item/weapon/cell/crap,/obj/item/weapon/cell/crap,/obj/item/weapon/cell/crap)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Battery Cells"
	group = "Hospitality"

/datum/supply_packs/bracelets
	name = "Bracelets (x3)"
	contains = list(/obj/item/device/radio/headset/bracelet,/obj/item/device/radio/headset/bracelet,/obj/item/device/radio/headset/bracelet)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "Bracelets (x3)"
	group = "Hospitality"

/datum/supply_packs/buckshotammo
	name = "Buckshot shells (8)"
	contains = list(/obj/item/stack/bullets/buckshot,/obj/item/stack/bullets/buckshot,/obj/item/stack/bullets/buckshot,
	/obj/item/stack/bullets/buckshot,/obj/item/stack/bullets/buckshot,/obj/item/stack/bullets/buckshot,/obj/item/stack/bullets/buckshot
	,/obj/item/stack/bullets/buckshot)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Buckshot shells"
	group = "Ammo"

/datum/supply_packs/princessammo
	name = "7.62mm (8)"
	contains = list(/obj/item/stack/bullets/rifle,/obj/item/stack/bullets/rifle,/obj/item/stack/bullets/rifle,
	/obj/item/stack/bullets/rifle,/obj/item/stack/bullets/rifle,/obj/item/stack/bullets/rifle,/obj/item/stack/bullets/rifle
	,/obj/item/stack/bullets/rifle)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "7.62 rounds"
	group = "Ammo"

/datum/supply_packs/duelistafive
	name = ".357 (5)"
	contains = list(/obj/item/stack/bullets/Newduelista/five)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "357 rounds"
	group = "Ammo"

/datum/supply_packs/haratseven
	name = ".380 (7)"
	contains = list(/obj/item/stack/bullets/Harat/seven)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "380 rounds"
	group = "Ammo"

/datum/supply_packs/speedloaderneoclassic
	name = ".38 Rounds"
	contains = list(/obj/item/ammo_magazine/box/c38)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = ".38 Rounds"
	group = "Ammo"

/datum/supply_packs/speedloaderneoclassicx3
	name = ".38 Rounds (x3)"
	contains = list(/obj/item/ammo_magazine/box/c38,/obj/item/ammo_magazine/box/c38,/obj/item/ammo_magazine/box/c38)
	cost = 70
	containertype = /obj/structure/closet/crate/secure
	containername = ".38 Rounds (x3)"
	group = "Ammo"

/datum/supply_packs/plastique
	name = "C-4 Explosives (x2)"
	contains = list(/obj/item/weapon/plastique,/obj/item/weapon/plastique)
	cost = 180
	containertype = /obj/structure/closet/crate/secure
	containername = "C-4 Explosive"
	is_weapon = TRUE
	group = "Weapons"

/datum/supply_packs/internals
	name = "Internals crate"
	contains = list(/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/weapon/tank/air,
					/obj/item/weapon/tank/air,
					/obj/item/weapon/tank/air)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Internals crate"
	group = "Engineering"

/datum/supply_packs/batteries
	name = "(3x) Empty Batteries"
	contains = list(/obj/item/weapon/cell/web/empty,/obj/item/weapon/cell/web/empty,/obj/item/weapon/cell/web/empty)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Batteries crate"
	group = "Engineering"


/datum/supply_packs/medical
	name = "Medical crate"
	contains = list(/obj/item/weapon/storage/firstaid/regular,
					/obj/item/weapon/storage/firstaid/fire,
					/obj/item/weapon/storage/firstaid/toxin,
					/obj/item/weapon/storage/firstaid/o2,
					/obj/item/weapon/storage/firstaid/adv,
					/obj/item/weapon/storage/pill_bottle/charcoal,
					/obj/item/weapon/reagent_containers/glass/bottle/epinephrine,
					/obj/item/weapon/reagent_containers/glass/bottle/stoxin,
					/obj/item/weapon/storage/box/syringes)
	cost = 100
	containertype = /obj/structure/closet/crate/secure
	containername = "Medical crate"
	group = "Medical / Science"

/datum/supply_packs/medicalchems
	name = "Chemistry crate"
	contains = list(/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/gallium,/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/gallium,
	/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/cesium,/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/cesium,
	/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/thorium,/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/thorium,
	/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/californium,/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/californium,
	/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/rellurium,/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/rellurium,
	/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/tantalum,/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/tantalum,
	/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/lithium,/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/lithium,
	/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/morphite,/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/morphite,
	/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/iridium,/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/iridium,
	/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/thaesium,/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/thaesium,
	/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/selenium,/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/selenium,
	/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/europium,/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/europium,
	/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/hassium,/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/hassium,
	/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/lutetium,/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/lutetium,
	/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/barium,/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/barium,
	/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/technetium,/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/technetium,
	/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/molybdenum,/obj/item/weapon/reagent_containers/glass/bottle/lifeweb/molybdenum)
	cost = 80
	containertype = /obj/structure/closet/crate/secure
	containername = "Chemistry crate"
	group = "Medical / Science"

/datum/supply_packs/camogen
	name = "Camouflage Generator (x3)"
	contains = list(/obj/item/weapon/cloaking_device,/obj/item/weapon/cloaking_device,/obj/item/weapon/cloaking_device)
	cost = 80
	containertype = /obj/structure/closet/crate/secure
	containername = "Camouflage Generator (x3)"
	group = "Medical / Science"


/datum/supply_packs/stunner
	name = "Stunner Pistol"
	contains = list(/obj/item/weapon/gun/energy/taser/MERCY/pistol)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "Stunner crate"
	group = "Weapons"

/datum/supply_packs/shotgun
	name = "Shotgun (x1)"
	contains = list(/obj/item/weapon/gun/projectile/shotgun)
	cost = 220
	containertype = /obj/structure/closet/crate/secure
	containername = "Shotgun crate"
	is_weapon = TRUE
	group = "Weapons"

/datum/supply_packs/shotguns
	name = "Shotgun (x3)"
	contains = list(/obj/item/weapon/gun/projectile/shotgun, /obj/item/weapon/gun/projectile/shotgun, /obj/item/weapon/gun/projectile/shotgun)
	cost = 585
	containertype = /obj/structure/closet/crate/secure
	containername = "Shotgun crate"
	is_weapon = TRUE
	group = "Weapons"

/datum/supply_packs/legax
	name = "Legax Gravpulser"
	contains = list(/obj/item/weapon/gun/energy/taser/leet/legax)
	cost = 250
	containertype = /obj/structure/closet/crate/secure
	containername = "Legax Gravpulser crate"
	is_weapon = TRUE
	group = "Weapons"

/datum/supply_packs/princess
	name = "Princess Mk1 (1)"
	contains = list(/obj/item/weapon/gun/projectile/shotgun/princess)
	cost = 195
	containertype = /obj/structure/closet/crate/secure
	containername = "Princess MK1 crate"
	is_weapon = TRUE
	group = "Weapons"

/datum/supply_packs/maulet
	name = "Maulet P2R"
	contains = list(/obj/item/weapon/gun/energy/taser/leet/maulet)
	cost = 45
	containertype = /obj/structure/closet/crate/secure
	containername = "Maulet P2R crate"
	is_weapon = TRUE
	group = "Weapons"

/datum/supply_packs/talon
	name = "Talon M12A4"
	contains = list(/obj/item/weapon/gun/projectile/automatic/carbine, /obj/item/ammo_magazine/external/mag556)
	cost = 500
	containertype = /obj/structure/closet/crate/secure
	containername = "Talon SMG crate"
	is_weapon = TRUE
	group = "Weapons"

/datum/supply_packs/mag556
	name = "magazine 5.56 (x3)"
	contains = list(/obj/item/ammo_magazine/external/mag556, /obj/item/ammo_magazine/external/mag556, /obj/item/ammo_magazine/external/mag556)
	cost = 150
	containertype = /obj/structure/closet/crate/secure
	containername = "magazine 5.56 (x3) crate"
	group = "Ammo"

/datum/supply_packs/cheapweapon
	name = "Cheap Weapon Pack"
	contains = list(/obj/item/weapon/melee/classic_baton/club/knuckleduster,/obj/item/weapon/melee/classic_baton/club/knuckleduster,
	/obj/item/weapon/gun/projectile/newRevolver/duelista,/obj/item/weapon/gun/projectile/newRevolver/duelista,
	/obj/item/weapon/kitchen/utensil/knife,/obj/item/weapon/kitchen/utensil/knife)
	cost = 80
	containertype = /obj/structure/closet/crate/secure
	containername = "Cheap Weapon Pack"
	is_weapon = TRUE
	group = "Weapons"

/datum/supply_packs/princess
	name = "Princess Mk1 (x3)"
	contains = list(/obj/item/weapon/gun/projectile/shotgun/princess,/obj/item/weapon/gun/projectile/shotgun/princess,/obj/item/weapon/gun/projectile/shotgun/princess)
	cost = 585
	containertype = /obj/structure/closet/crate/secure
	containername = "Princess MK1 crate (x3)"
	is_weapon = TRUE
	group = "Weapons"

/datum/supply_packs/ml23
	name = "Ml-23 (x3)"
	contains = list(/obj/item/weapon/gun/projectile/automatic/pistol/ml23,/obj/item/weapon/gun/projectile/automatic/pistol/ml23,/obj/item/weapon/gun/projectile/automatic/pistol/ml23)
	cost = 240
	containertype = /obj/structure/closet/crate/secure
	containername = "Ml-23 (x3)"
	is_weapon = TRUE
	group = "Weapons"

/datum/supply_packs/sparqbeams
	name = "Sparq Beams crate (x3)"
	contains = list(/obj/item/weapon/gun/energy/taser/leet/sparq,/obj/item/weapon/gun/energy/taser/leet/sparq,/obj/item/weapon/gun/energy/taser/leet/sparq)
	cost = 120
	containertype = /obj/structure/closet/crate/secure
	containername = "Sparq Beams crate (x3)"
	group = "Weapons"

/datum/supply_packs/neoclassicrevolver
	name = "Neoclassic R&W10 (x1)"
	contains = list(/obj/item/weapon/gun/projectile/newRevolver/duelista/neoclassic, /obj/item/ammo_magazine/box/c38/e)
	cost = 300
	containertype = /obj/structure/closet/crate/secure
	containername = "Neoclassic RW crate (x1)"
	is_weapon = TRUE
	group = "Weapons"


/datum/supply_packs/shotgunammo
	name = "Buckshot shells"
	contains = list(/obj/item/stack/bullets/buckshot/eight,
	/obj/item/stack/bullets/buckshot/eight)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Buckshot shells"
	group = "Ammo"

/datum/supply_packs/surgery
	name = "Surgical Tools"
	contains = list(/obj/item/weapon/surgery_tool/cautery,
					/obj/item/weapon/surgery_tool/surgicaldrill,
					/obj/item/clothing/mask/breath/medical,
					/obj/item/weapon/tank/anesthetic,
					/obj/item/weapon/surgery_tool/FixOVein,
					/obj/item/weapon/surgery_tool/hemostat,
					/obj/item/weapon/surgery_tool/scalpel,
					/obj/item/weapon/surgery_tool/bonegel,
					/obj/item/weapon/surgery_tool/retractor,
					/obj/item/weapon/surgery_tool/bonesetter,
					/obj/item/weapon/surgery_tool/circular_saw)
	cost = 130
	containertype = /obj/structure/closet/crate/secure
	containername = "Surgical Tools"
	group = "Medical / Science"

/datum/supply_packs/alchemy
	name = "Alchemy Kit"
	contains = list(/obj/item/weapon/retort,
					/obj/item/weapon/mortar,
					/obj/item/weapon/pestle,
					/obj/item/weapon/flame/lighter,
					/obj/item/weapon/reagent_containers/glass/beaker/vial,
					/obj/item/weapon/reagent_containers/glass/beaker/vial,
					/obj/item/weapon/reagent_containers/glass/beaker/vial
					)
	cost = 130
	containertype = /obj/structure/closet/crate/secure
	containername = "Alchemy Kit"
	group = "Medical / Science"

/datum/supply_packs/ticket
	name = "Ticket to the Vinfort"
	contains = list(/obj/item/clothing/head/amulet/ticket)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "Ticket crate"
	group = "Hospitality"

/datum/supply_packs/randomised
	var/num_contained = 3 //number of items picked to be contained in a randomised crate
/datum/supply_packs/randomised/New()
	manifest += "Contains any [num_contained] of:"
	..()

/datum/supply_packs/alchemy
	name = "Pcheloved suit"
	contains = list(/obj/item/clothing/suit/bio_suit,
					/obj/item/clothing/head/bio_hood,
					/obj/item/clothing/mask/bee
					)
	cost = 90
	containertype = /obj/structure/closet/crate/secure
	containername = "Pcheloved suit"
	group = "Hospitality"