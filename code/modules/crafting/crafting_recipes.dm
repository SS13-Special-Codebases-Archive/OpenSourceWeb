/datum/craft_recipe
	var/name
	var/id
	var/craft_type
	var/skillRequired
	var/skill_value
	var/list/materials
	var/desc_materials
	var/path_type
	var/under_self = FALSE
	var/max_count = 1
	var/nostructure = TRUE
	var/between_walls = FALSE
	var/place_on_wall = FALSE

proc/pick_craft_recipe(var/recipe_id)
	var/list/recipes = subtypesof(/datum/craft_recipe)
	for(var/CR in recipes)
		var/datum/craft_recipe/R = new CR
		if(R.id == recipe_id)
			return R
		qdel(R)
	return null
//FURNITURE//

/datum/craft_recipe/furniture/woodfloor
	name = "Wood floor"
	id = "woodfloor"
	skillRequired = SKILL_CRAFT
	skill_value = 7
	materials = list(/obj/item/stack/sheet/wood = 1)
	desc_materials = "1 shroomwood logs"
	path_type = /turf/simulated/floor/lifeweb/wood
	under_self = TRUE

/datum/craft_recipe/furniture/woodwall
	name = "Wood wall"
	id = "woodwall"
	skillRequired = SKILL_CRAFT
	skill_value = 7
	materials = list(/obj/item/stack/sheet/wood = 3)
	desc_materials = "3 shroomwood logs"
	path_type = /turf/simulated/wall/woodwall

/datum/craft_recipe/furniture/wooddoor
	name = "Wooden Door"
	id = "wooddoor"
	skillRequired = SKILL_CRAFT
	skill_value = 7
	materials = list(/obj/item/stack/sheet/wood = 3)
	desc_materials = "3 shroomwood logs"
	path_type = /obj/structure/mineral_door/wood
	between_walls = TRUE

/datum/craft_recipe/furniture/woodchair
	name = "Wooden chair"
	id = "woodchair"
	skillRequired = SKILL_CRAFT
	skill_value = 3
	materials = list(/obj/item/stack/sheet/wood = 2)
	desc_materials = "2 shroomwood logs"
	path_type = /obj/structure/stool/bed/chair/comfy/woodencave

/datum/craft_recipe/furniture/bed
	name = "Bed"
	id = "bed"
	skillRequired = SKILL_CRAFT
	skill_value = 3
	materials = list(/obj/item/stack/sheet/wood = 2)
	desc_materials = "2 shroomwood logs"
	path_type = /obj/structure/stool/bed

/datum/craft_recipe/furniture/chest
	name = "Chest"
	id = "chest"
	skillRequired = SKILL_CRAFT
	skill_value = 5
	materials = list(/obj/item/stack/sheet/wood = 3)
	desc_materials = "3 shroomwood logs"
	path_type = /obj/structure/closet/crate

/datum/craft_recipe/furniture/coffin
	name = "Wooden coffin"
	id = "coffin"
	skillRequired = SKILL_CRAFT
	skill_value = 7
	materials = list(/obj/item/stack/sheet/wood = 6)
	desc_materials = "6 shroomwood logs"
	path_type = /obj/structure/closet/coffin/wood

/datum/craft_recipe/furniture/toilet
	name = "Toilet"
	id = "toilet"
	skillRequired = SKILL_CRAFT
	skill_value = 5
	materials = list(/obj/item/weapon/stone = 3)
	desc_materials = "3 stone"
	path_type = /obj/structure/toilet/stone

/datum/craft_recipe/furniture/campfire
	name = "Campfire"
	id = "campfire"
	skillRequired = SKILL_SURVIV
	skill_value = 3
	materials = list(/obj/item/stack/sheet/wood = 2)
	desc_materials = "2 shroomwood logs"
	path_type = /obj/structure/campfire

/datum/craft_recipe/furniture/fireplace
	name = "Fireplace"
	id = "fireplace"
	skillRequired = SKILL_CRAFT
	skill_value = 7
	materials = list(/obj/item/weapon/stone = 4, /obj/item/weapon/ore/lw/coal = 1)
	desc_materials = "4 stone, 1 coal"
	path_type = /obj/structure/fireplace/off

/datum/craft_recipe/furniture/traindoll
	name = "Training doll"
	id = "traindoll"
	skillRequired = SKILL_CRAFT
	skill_value = 7
	materials = list(/obj/item/stack/sheet/wood = 3)
	desc_materials = "3 shroomwood logs"
	path_type = /obj/structure/lifeweb/statue/dummy

/datum/craft_recipe/furniture/mining_cart
	name = "Wooden mining cart"
	id = "mining_cart"
	skillRequired = SKILL_CRAFT
	skill_value = 7
	materials = list(/obj/item/stack/sheet/wood = 5)
	desc_materials = "5 shroomwood logs"
	path_type = /obj/structure/miningcar/wooden

/datum/craft_recipe/furniture/w_table
	name = "Wooden table"
	id = "w_table"
	skillRequired = SKILL_CRAFT
	skill_value = 7
	materials = list(/obj/item/stack/sheet/wood = 2)
	desc_materials = "2 shroomwood logs"
	path_type = /obj/structure/rack/lwtable/table3

/datum/craft_recipe/furniture/bookcase
	name = "Wooden bookcase"
	id = "bookcase"
	skillRequired = SKILL_CRAFT
	skill_value = 5
	materials = list(/obj/item/stack/sheet/wood = 3)
	desc_materials = "3 shroomwood logs"
	path_type = /obj/structure/bookcase/empty

/datum/craft_recipe/furniture/w_rack
	name = "Wooden rack"
	id = "w_rack"
	skillRequired = SKILL_CRAFT
	skill_value = 5
	materials = list(/obj/item/stack/sheet/wood = 2)
	desc_materials = "2 shroomwood logs"
	path_type = /obj/structure/rack

/datum/craft_recipe/furniture/hearth
	name = "Hearth"
	id = "hearth"
	skillRequired = SKILL_CRAFT
	skill_value = 5
	materials = list(/obj/item/stack/sheet/wood = 2)
	desc_materials = "2 shroomwood logs"
	path_type = /obj/structure/fireplace/hearth

//ITEMS//

/datum/craft_recipe/items/torch
	name = "Torch"
	id = "torch"
	skillRequired = SKILL_SURVIV
	skill_value = 2
	materials = list(/obj/item/stack/sheet/wood = 1)
	desc_materials = "1 shroomwood logs"
	path_type = /obj/item/weapon/flame/torch
	max_count = 3
	nostructure = FALSE

/datum/craft_recipe/items/stake
	name = "Wooden stake"
	id = "stake"
	skillRequired = SKILL_SURVIV
	skill_value = 2
	materials = list(/obj/item/stack/sheet/wood = 1)
	desc_materials = "1 shroomwood logs"
	path_type = /obj/item/weapon/kitchen/utensil/knife/dagger/wood_stake
	max_count = 5
	nostructure = FALSE

//MASON//

/datum/craft_recipe/mason/stonefloor
	name = "Stone floor"
	id = "stonefloor"
	skillRequired = SKILL_MASON
	skill_value = 7
	materials = list(/obj/item/weapon/stone = 1)
	desc_materials = "1 stone"
	path_type = /turf/simulated/floor/lifeweb/stone/handmade
	under_self = TRUE

/datum/craft_recipe/mason/stonewall
	name = "Stone wall"
	id = "stonewall"
	skillRequired = SKILL_MASON
	skill_value = 7
	materials = list(/obj/item/weapon/stone = 3)
	desc_materials = "3 stone"
	path_type = /turf/simulated/wall/stone

/datum/craft_recipe/mason/torchwall
	name = "Torch Fixture"
	id = "torchwall"
	skillRequired = SKILL_MASON
	skill_value = 5
	materials = list(/obj/item/weapon/stone = 2)
	desc_materials = "2 stone"
	path_type = /obj/structure/torchwall/empty
	under_self = TRUE
	place_on_wall = TRUE
	nostructure = FALSE

/datum/craft_recipe/mason/pillar
	name = "Stone column"
	id = "pillar"
	skillRequired = SKILL_MASON
	skill_value = 7
	materials = list(/obj/item/weapon/stone = 2)
	desc_materials = "2 stone"
	path_type = /obj/structure/lifeweb/statue/pillar

/datum/craft_recipe/mason/forja
	name = "Forja"
	id = "forja"
	skillRequired = SKILL_MASON
	skill_value = 7
	materials = list(/obj/item/weapon/stone = 5, /obj/item/weapon/ore/lw/coal = 1)
	desc_materials = "5 stone, 1 coal"
	path_type = /obj/structure/forja

/datum/craft_recipe/mason/anvil
	name = "Anvil"
	id = "anvil"
	skillRequired = SKILL_MASON
	skill_value = 7
	materials = list(/obj/item/weapon/stone = 6)
	desc_materials = "6 stone"
	path_type = /obj/structure/anvil

/datum/craft_recipe/mason/smelter
	name = "Smelter"
	id = "smelter"
	skillRequired = SKILL_MASON
	skill_value = 7
	materials = list(/obj/item/weapon/stone = 6)
	desc_materials = "6 stone"
	path_type = /obj/item/weapon/storage/forge

/datum/craft_recipe/mason/furnace
	name = "Furnace"
	id = "furnace"
	skillRequired = SKILL_MASON
	skill_value = 7
	materials = list(/obj/item/weapon/stone = 5)
	desc_materials = "5 stone"
	path_type = /obj/machinery/microwave

//WEAPONS//

/datum/craft_recipe/weapons/woodclub
	name = "Wooden club"
	id = "woodclub"
	skillRequired = SKILL_MASON
	skill_value = 5
	materials = list(/obj/item/stack/sheet/wood = 2)
	desc_materials = "2 shroomwood logs"
	path_type = /obj/item/weapon/melee/classic_baton/woodenclub
	nostructure = FALSE

/datum/craft_recipe/weapons/woodspear
	name = "Wooden spear"
	id = "woodspear"
	skillRequired = SKILL_MASON
	skill_value = 5
	materials = list(/obj/item/stack/sheet/wood = 3)
	desc_materials = "3 shroomwood logs"
	path_type = /obj/item/weapon/claymore/wspear
	nostructure = FALSE

/datum/craft_recipe/weapons/woodsword
	name = "Wooden sword"
	id = "woodsword"
	skillRequired = SKILL_MASON
	skill_value = 5
	materials = list(/obj/item/stack/sheet/wood = 2)
	desc_materials = "2 shroomwood logs"
	path_type = /obj/item/weapon/claymore/wood
	nostructure = FALSE

//OTHER//

/datum/craft_recipe/other/shovel
	name = "Shovel"
	id = "shovel"
	skillRequired = SKILL_CRAFT
	skill_value = 3
	materials = list(/obj/item/stack/sheet/wood = 2)
	desc_materials = "2 shroomwood logs"
	path_type = /obj/item/weapon/shovel
	max_count = 3
	nostructure = FALSE

/datum/craft_recipe/other/mug
	name = "Mug"
	id = "mug"
	skillRequired = SKILL_CRAFT
	skill_value = 3
	materials = list(/obj/item/stack/sheet/wood = 1)
	desc_materials = "1 shroomwood logs"
	path_type = /obj/item/weapon/reagent_containers/glass/wood
	max_count = 5
	nostructure = FALSE

/datum/craft_recipe/other/bucket
	name = "Bucket"
	id = "bucket"
	skillRequired = SKILL_CRAFT
	skill_value = 3
	materials = list(/obj/item/stack/sheet/wood = 3)
	desc_materials = "3 shroomwood logs"
	path_type = /obj/item/weapon/reagent_containers/glass/bucket
	nostructure = FALSE

//CULT//
/datum/craft_recipe/cult
	var/cult_type

/datum/craft_recipe/cult/angelstatue
	name = "Angel statue"
	id = "angelstatue"
	skillRequired = SKILL_CRAFT
	skill_value = 7
	materials = list(/obj/item/weapon/stone = 5)
	desc_materials = "5 stone"
	path_type = /obj/structure/lifeweb/statue/angel2

/datum/craft_recipe/cult/stonecross
	name = "Cross"
	id = "stonecross"
	cult_type = "Gray Church"
	skillRequired = SKILL_CRAFT
	skill_value = 7
	materials = list(/obj/item/weapon/stone = 5)
	desc_materials = "5 stone"
	path_type = /obj/structure/lifeweb/statue/wcross

/datum/craft_recipe/cult/lazaro
	name = "Lazaro"
	id = "lazaro"
	cult_type = "Old Ways"
	skillRequired = SKILL_CRAFT
	skill_value = 3
	materials = list(/obj/item/weapon/stone = 5)
	desc_materials = "5 stone"
	path_type = /obj/structure/oldways/lazaro

/datum/craft_recipe/cult/boto
	name = "Boto"
	id = "boto"
	cult_type = "Old Ways"
	skillRequired = SKILL_CRAFT
	skill_value = 3
	materials = list(/obj/item/weapon/stone = 5)
	desc_materials = "5 stone"
	path_type = /obj/structure/oldways/boto

/datum/craft_recipe/cult/guarani
	name = "Guarani"
	id = "guarani"
	cult_type = "Old Ways"
	skillRequired = SKILL_CRAFT
	skill_value = 3
	materials = list(/obj/item/weapon/stone = 5)
	desc_materials = "5 stone"
	path_type = /obj/structure/oldways/guarani


/datum/craft_recipe/cult/alefau
	name = "Alefau"
	id = "alefau"
	cult_type = "Old Ways"
	skillRequired = SKILL_CRAFT
	skill_value = 3
	materials = list(/obj/item/weapon/stone = 5)
	desc_materials = "5 stone"
	path_type = /obj/structure/oldways/alefau

/datum/craft_recipe/cult/irineo
	name = "Irineo"
	id = "irineo"
	cult_type = "Old Ways"
	skillRequired = SKILL_CRAFT
	skill_value = 3
	materials = list(/obj/item/weapon/stone = 5)
	desc_materials = "5 stone"
	path_type = /obj/structure/oldways/irineo

/datum/craft_recipe/cult/lula
	name = "Lula"
	id = "lula"
	cult_type = "Old Ways"
	skillRequired = SKILL_CRAFT
	skill_value = 3
	materials = list(/obj/item/weapon/stone = 5)
	desc_materials = "5 stone"
	path_type = /obj/structure/oldways/lula

//TANNING//

/datum/craft_recipe/tanning/satchel
	name = "Satchel"
	id = "satchel"
	skillRequired = SKILL_TAN
	skill_value = 5
	materials = list(/obj/item/stack/sheet/leather = 2)
	desc_materials = "2 leather"
	path_type = /obj/item/weapon/storage/backpack/satchel
	nostructure = FALSE

/datum/craft_recipe/tanning/leather_pants
	name = "Leather pants"
	id = "leather_pants"
	skillRequired = SKILL_TAN
	skill_value = 5
	materials = list(/obj/item/stack/sheet/leather = 2)
	desc_materials = "2 leather"
	path_type = /obj/item/clothing/under/rank/hydroponics
	nostructure = FALSE

/datum/craft_recipe/tanning/apron
	name = "Apron"
	id = "apron"
	skillRequired = SKILL_TAN
	skill_value = 5
	materials = list(/obj/item/stack/sheet/leather = 2)
	desc_materials = "2 leather"
	path_type = /obj/item/clothing/suit/apron
	nostructure = FALSE

/datum/craft_recipe/tanning/leahelmet
	name = "Leather helmet"
	id = "leahelmet"
	skillRequired = SKILL_TAN
	skill_value = 5
	materials = list(/obj/item/stack/sheet/leather = 2)
	desc_materials = "2 leather"
	path_type = /obj/item/clothing/head/helmet/lw/leatherhelm
	nostructure = FALSE

/datum/craft_recipe/tanning/leagloves
	name = "Leather gloves"
	id = "leagloves"
	skillRequired = SKILL_TAN
	skill_value = 5
	materials = list(/obj/item/stack/sheet/leather = 2)
	desc_materials = "2 leather"
	path_type = /obj/item/clothing/gloves/botanic_leather
	nostructure = FALSE