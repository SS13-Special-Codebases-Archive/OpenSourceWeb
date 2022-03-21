/obj/structure/oven
	name = "Furnace"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "oven0"
	layer = 2.9
	density = 0
	anchored = 1
	flags = OPENCONTAINER | NOREACT
	var/operating = 0 // Is it on?
	var/global/list/datum/recipe/available_recipes // List of the recipes you can use
	var/global/list/acceptable_items // List of the items you can put in
	var/global/list/acceptable_reagents // List of the reagents you can put in
	var/global/max_n_of_items = 0
	var/efficiency = 0
	var/lit = 0
	var/open = 0

/obj/structure/oven/south
	pixel_y = -32

/obj/structure/oven/north
	pixel_y = 32

/obj/structure/oven/east
	pixel_x = 32

/obj/structure/oven/west
	pixel_x = -32


// see code/modules/food/recipes_microwave.dm for recipes

/*******************
*   Initialising
********************/

/obj/structure/oven/New()
	//..() //do not need this
	reagents = new/datum/reagents(100)
	reagents.my_atom = src
	if (!available_recipes)
		available_recipes = new
		for (var/type in (typesof(/datum/recipe)-/datum/recipe/alchemy))//(typesof(/datum/recipe)-/datum/recipe))
			available_recipes+= new type
		acceptable_items = new
		acceptable_reagents = new
		for (var/datum/recipe/recipe in available_recipes)
			for (var/item in recipe.items)
				acceptable_items |= item
			for (var/reagent in recipe.reagents)
				acceptable_reagents |= reagent
			if (recipe.items)
				max_n_of_items = max(max_n_of_items,recipe.items.len)

		acceptable_items |= /obj/item/mob_holder

/obj/machinery/microwave/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(user.stat || user.restrained()) return

	if(istype(O, /obj/item/weapon/flame))
		var/obj/item/weapon/flame/I = O
		if(I.lit && !lit)
			lit = 1
			update_icon()
			processing_objects.Add(src)
			spawn(2000)
				lit = 0
				update_icon()
				processing_objects.Remove(src)

		return

	if(!open)
		return ..()

	else if(is_type_in_list(O,acceptable_items) || check_dish(available_recipes,O))
		if (contents.len>=max_n_of_items)
			user << "\red \the [src] is full, you cannot put more in."
			return
		if (istype(O,/obj/item/stack) && O:amount>1)
			new O.type (src)
			O:use(1)
			user.visible_message("<span class='passive'><span class='passivebold'>[user]</span> has placed one of <span class='passivebold'>[O]</span> in \the <span class='passivebold'>[src]</span>.</span>")
			return
		else
			user.drop_item()
			O.loc = src
			user.visible_message("<span class='passive'><span class='passivebold'>[user]</span> has placed \the <span class='passivebold'>[O]</span> in \the <span class='passivebold'>[src]</span>.</span>")
			return

	else if(istype(O,/obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = O
		return
	else
		to_chat(user,"<span class='combat'><span class='combatbold'>[pick(nao_consigoen)]</span> What could I possibly cook with the  \the <span class='combatbold'>[O]</span>?</span>")
		return




obj/structure/oven/proc/create_recipe()
	var/datum/recipe/recipe = select_recipe(available_recipes,src)
	var/obj/item/weapon/reagent_containers/food/to_cook = null
	if(recipe)
		to_cook = recipe.make_food(src)
		if(to_cook)
			to_cook.loc = src
			return 1
	return 0

obj/structure/oven/proc/check_dish(var/list/datum/recipe/avaiable_recipes, var/obj/obj)
	for(var/datum/recipe/recipe in avaiable_recipes)
		var/O = recipe.result
		//the istype is a bit of a hack. But it saves me from writing a second prompt for checking items that are put into the oven.
		if (locate(O) in obj)
			return TRUE
		else if (istype(obj,O))
			return TRUE
	return FALSE
