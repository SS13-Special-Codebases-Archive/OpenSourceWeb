// pra adicionar algo no menu de craftings de uma dessas categorias, so seguir os samples que eu deixei ai
// observaçao, o negocio de code = "" nessas lista, tem que ser individual pra cada uma, ele e a unica coisa que tem que ser unica
//sim da pra ter multiplos componentes na materials, so criar mais lista e seguir aquele formato


var/global/list/allRecipes = list("Cult", "Old Ways", "Gray Church", "Furniture", "Items", "Leather", "Mason", "Tanning", "Signs", "Weapons", "Other")

/mob/living/carbon/human/proc/showRecipes(var/recipes_type)
	var/fullHTML = "<html><head><style>.desc{color: #434446; font-size: 65%} .materials{color: #434446; font-size: 70%;} a{color:#656366; font-size: 76%;  font-weight: bold; text-decoration: none; font-decoration: none} a:hover{background-color: #656366; color: black} body{font-size: 135%}</style><title>Crafting</title> <body style='background-color:#0e0c0e; color: #43302f; text-align: center;'> <h3 style='color: #49484a;'>Craft</h3>"
	var/list/recipes = subtypesof(text2path("/datum/craft_recipe/[lowertext(recipes_type)]"))
	for(var/C in recipes)
		var/datum/craft_recipe/CR = new C
		if(recipes_type == "Cult")
			var/datum/craft_recipe/cult/R = CR
			if(R.cult_type && (src.religion != R.cult_type))
				qdel(CR)
				continue
		if(CR.skillRequired)
			var/skill_level = src.my_skills.GET_SKILL(CR.skillRequired)
			if(skill_level < CR.skill_value)
				qdel(CR)
				continue
		fullHTML += "<A href='?src=\ref[src];[CR.id]=1'>[CR.under_self ? "*" : ""][CR.between_walls ? "**" : ""][CR.name]</A><BR><span class='materials'>[CR.desc_materials]</span><BR><BR>"
		qdel(CR)

	fullHTML += "<BR><BR><div class='desc'>* materials go in front of the character</div><div class='desc'>** Between the walls</div></body></head></html>"
	return fullHTML

/mob/living/carbon/human/verb/furniture()
	set name = "Furniture"
	set category = "Craft"

	usr << browse(showRecipes("Furniture"), "window=player_panel;size=300x650;can_close=1;can_resize=0;border=0;titlebar=1")

/mob/living/carbon/human/verb/cult()
	set name = "Cult"
	set category = "Craft"

	usr << browse(showRecipes("Cult"), "window=player_panel;size=300x650;can_close=1;can_resize=0;border=0;titlebar=1")

/mob/living/carbon/human/verb/items()
	set name = "Items"
	set category = "Craft"

	usr << browse(showRecipes("Items"), "window=player_panel;size=300x650;can_close=1;can_resize=0;border=0;titlebar=1")

/mob/living/carbon/human/verb/leather()
	set name = "Leather"
	set category = "Craft"

	usr << browse(showRecipes("Leather"), "window=player_panel;size=300x650;can_close=1;can_resize=0;border=0;titlebar=1")

/mob/living/carbon/human/verb/mason()
	set name = "Mason"
	set category = "Craft"

	usr << browse(showRecipes("Mason"), "window=player_panel;size=300x650;can_close=1;can_resize=0;border=0;titlebar=1")

/mob/living/carbon/human/verb/tanning()
	set name = "Tanning"
	set category = "Craft"

	usr << browse(showRecipes("Tanning"), "window=player_panel;size=300x650;can_close=1;can_resize=0;border=0;titlebar=1")


/mob/living/carbon/human/verb/signs()
	set name = "Signs"
	set category = "Craft"

	usr << browse(showRecipes("Signs"), "window=player_panel;size=300x650;can_close=1;can_resize=0;border=0;titlebar=1")

/mob/living/carbon/human/verb/weapons()
	set name = "Weapons"
	set category = "Craft"

	usr << browse(showRecipes("Weapons"), "window=player_panel;size=300x650;can_close=1;can_resize=0;border=0;titlebar=1")

/mob/living/carbon/human/verb/other()
	set name = "Other"
	set category = "Craft"

	usr << browse(showRecipes("Other"), "window=player_panel;size=300x650;can_close=1;can_resize=0;border=0;titlebar=1")

/mob/living/carbon/human/Topic(href, href_list)
	var/hrefParsed = splittext(href, ";")[2]
	var/datum/craft_recipe/CR = pick_craft_recipe(replacetext(hrefParsed, "=1", ""))
	if(CR)
		if(get_active_hand() || get_inactive_hand() || handcuffed)
			to_chat(src, "<span class='combatbold'>[pick(nao_consigoen)] I need free hands.</span>")
			return
		var/resources
		var/list/removeLater = list()
		var/have_resources = TRUE
		var/turf/mat_loc
		var/GURPS_mod = 0
		var/SR = CR.skillRequired
		if(CR.under_self)
			mat_loc = loc
		else
			mat_loc = get_step(loc, usr.dir)
		if(!SR)
			SR = SKILL_CRAFT
		for(var/M in CR.materials)
			resources = 0
			for(var/atom/I in mat_loc.contents)
				if(istype(I, M) && (resources < CR.materials[M]))
					if(istype(I, /obj/item/stack))
						var/obj/item/stack/RS = I
						var/needed = (CR.materials[M] - resources)
						//var/have_that = RS.use(needed)
						var/have_that = RS.amount - needed
						if(have_that >= 0)
							resources += needed
							removeLater[RS] = needed
						else
							resources += RS.amount
							removeLater[RS] = RS.amount

					else
						resources++
						removeLater += I
				else if(istype(I, /obj/structure/rack/lwtable))
					GURPS_mod += 3
					continue
			if(resources < CR.materials[M])
				have_resources = FALSE
				break
		var/turf/newLoc
		if(CR.place_on_wall)
			var/turf/is_wall = get_step(loc, usr.dir)
			if(!istype(is_wall, /turf/simulated/wall))
				to_chat(usr, "<span class='combat'>[pick(nao_consigoen)] I need to face a wall!</span>")
				return
			newLoc = locate(x,y,z)
		else
			newLoc = get_step(loc, usr.dir)
		if(!have_resources)
			to_chat(usr, "<i><b>Not enough resources! I can't do it!</b></i>")
			return
		if(newLoc.density)
			return
		if(CR.nostructure)
			for(var/atom/A in newLoc.contents)
				if((!isobj(A) || A.density || ismob(A)))
					to_chat(src, "<span class='combatbold'>[pick(nao_consigoen)] Something in the way!</span>")
					return
		if(CR.between_walls)
			var/turf/T1
			var/turf/T2
			switch(usr.dir)
				if(NORTH, SOUTH)
					T1 = locate(newLoc.x+1,newLoc.y,newLoc.z)
					T2 = locate(newLoc.x-1,newLoc.y,newLoc.z)
				if(WEST, EAST)
					T1 = locate(newLoc.x,newLoc.y+1,newLoc.z)
					T2 = locate(newLoc.x,newLoc.y-1,newLoc.z)
			if(!T1 || !T2)
				return
			if(!istype(T1, /turf/simulated/wall) || !istype(T2, /turf/simulated/wall))
				to_chat(usr, "<span class='combat'>[pick(nao_consigoen)] [CR.name] need to be between 2 walls!</span>")
				return
		if(check_event("failed"))
			GURPS_mod -= 5
		var/list/rolled = roll3d6(src, SR, GURPS_mod)
		switch(rolled[GP_RESULT])
			if(GP_FAILED)
				to_chat(src, "<span class='combatbold'>[pick(nao_consigoen)] I failed...</span>")
				src.add_event("failed", /datum/happiness_event/misc/ivefailed)
				return
			if(GP_CRITFAIL)
				usr.visible_message("<span class='hitbold'>CRITICAL FAILURE!</span> <span class='hit'>[usr] fails to craft!</span>")
				src.add_event("failed", /datum/happiness_event/misc/ivefailed)
				for(var/obj/item/A in newLoc.contents)
					if(!A.density &&  !ismob(A))
						var/list/turfs = circleview(newLoc, 5)
						var/turf/TUR = pick(turfs)
						A.throw_at(TUR, 6,1)
				return
		var/foi = 0
		for(var/atom/RMV in removeLater)
			if(istype(RMV, /obj/item/stack))
				var/obj/item/stack/STCK = RMV
				STCK.use(removeLater[RMV])
			else
				qdel(RMV)
		var/newItemPath =  CR.path_type
		var/atom/newItem
		if(ispath(newItemPath, /turf))
			newLoc.ChangeTurfNew(newItemPath, TRUE, TRUE)
			itemscrafted += 1
		else if(CR.max_count > 1 && rolled[GP_MARGIN])
			var/max_c = min(CR.max_count, rolled[GP_MARGIN] / 2)
			for(var/i = 0, i < max_c, i++)
				newItem = new newItemPath(newLoc)
				itemscrafted += 1
		else
			newItem = new newItemPath(newLoc)
			itemscrafted += 1
		if(istype(newItem, /obj/structure/lifeweb/statue))
			newItem.dir = SOUTH
		else if(CR.place_on_wall)
			newItem.dir = turn(usr.dir, 180)
			if(istype(newItem, /obj/structure/torchwall) && (newItem.dir == SOUTH))
				newItem.pixel_y = 28
		else
			newItem?.dir = usr.dir
		if(usr.mind && usr.mind.antag_datums)
			if(istype(newItem, /obj/structure/wonder/first))
				var/obj/structure/wonder/first/F = newItem
				F.key = usr.mind.antag_datums.key1
				F.heart_key = usr.mind.antag_datums.heart_key1
				F.desc += " Oh, this is an [usr.mind.antag_datums.heart_key1]"
				foi = 1
				usr.visible_message("<span class='passivebold'>[usr]</span> <span class='passive'>crafts a</span> <span class='passivebold'>[newItem] of [usr.mind.antag_datums.heart_key1]!</span><span class='passive'>!</span>")
			if(istype(newItem, /obj/structure/wonder/second))
				var/obj/structure/wonder/second/F = newItem
				F.key = usr.mind.antag_datums.key2
				F.heart_key = usr.mind.antag_datums.heart_key2
				F.desc += " Oh, this is an [usr.mind.antag_datums.heart_key2]"
				foi = 1
				usr.visible_message("<span class='passivebold'>[usr]</span> <span class='passive'>crafts a</span> <span class='passivebold'>[newItem] of [usr.mind.antag_datums.heart_key2]!</span><span class='passive'>!</span>")
			if(istype(newItem, /obj/structure/wonder/third))
				var/obj/structure/wonder/third/F = newItem
				F.key = usr.mind.antag_datums.key3
				F.heart_key = usr.mind.antag_datums.heart_key3
				F.desc += " Oh, this is an [usr.mind.antag_datums.heart_key3]"
				foi = 1
				usr.visible_message("<span class='passivebold'>[usr]</span> <span class='passive'>crafts a</span> <span class='passivebold'>[newItem] of [usr.mind.antag_datums.heart_key3]!</span><span class='passive'>!</span>")
			if(istype(newItem, /obj/structure/wonder/fourth))
				var/obj/structure/wonder/fourth/F = newItem
				F.key = usr.mind.antag_datums.key4
				F.heart_key = usr.mind.antag_datums.heart_key4
				F.desc += " Oh, this is an [usr.mind.antag_datums.heart_key4]"
				foi = 1
				usr.visible_message("<span class='passivebold'>[usr]</span> <span class='passive'>crafts a</span> <span class='passivebold'>[newItem] of [usr.mind.antag_datums.heart_key4]!</span><span class='passive'>!</span>")
			playsound(usr.loc, 'sound/lfwbsounds/wonder.ogg', 100)
		if(!foi)
			usr.visible_message("<span class='passivebold'>[usr]</span> <span class='passive'>crafts a</span> <span class='passivebold'>[CR]</span><span class='passive'>!</span>")
		return newItem
	..()