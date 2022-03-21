/obj/structure/lifeweb/statue
	name = "statue"
	desc = "A statue from the past..."
	icon = 'icons/obj/miscobjs.dmi'
	breakable = TRUE
	display_hiding = TRUE
	hits = 20
	//mouse_opacity = 0

/obj/structure/lifeweb/statue/angel
	icon_state = "angel"


/obj/structure/lifeweb/statue/wcross
	icon = 'icons/life/LFWB_USEFUL.dmi'
	icon_state = "wcross"


/obj/structure/lifeweb/statue/angel2
	icon_state = "angel2"

/obj/structure/lifeweb/statue/gargoyle
	icon_state = "gargoyle"

/obj/structure/lifeweb/statue/gargoyleba
	icon_state = "statue8"

/obj/structure/lifeweb/statue/statue6
	icon_state = "statue6"

/obj/structure/lifeweb/statue/statue7
	icon_state = "statue7"

/obj/structure/lifeweb/statue/statue5
	icon_state = "statue5"

/obj/structure/lifeweb/statue/well
	name = "well"
	desc = "A well used to take water from."
	icon_state = "uell"
	density = 0

/obj/structure/lifeweb/statue/well
	name = "well"
	desc = "A well used to take water from."
	icon_state = "uell"
	density = 0

/obj/structure/lifeweb/statue/well/attackby(obj/item/O as obj, mob/living/carbon/human/user as mob)
	var/turf/simulated/below = locate(src.x, src.y, src.z-1)
	if(below.liquid)
		var/obj/reagent/R = below.liquid
		if(R.depth >= 10 && user.a_intent != "hurt")
			if (istype(O, /obj/item/weapon/reagent_containers))
				var/obj/item/weapon/reagent_containers/RG = O
				R.reagents.trans_to(RG, R.reagents.total_volume/6)
				user.visible_message("<span class='passivebold'>[user]</span><span class='passive'> fills \the [RG] on \the [R].</span>")
				playsound(R, pick('sound/webbers/water_max1.ogg', 'sound/webbers/water_max2.ogg'), rand(35, 50), 1)
				return

/obj/structure/lifeweb/statue/gargoyle/decor
	density = 0
	pixel_y = 28

/obj/structure/lifeweb/statue/gargoyle2
	icon_state = "gargoyle2"

/obj/structure/lifeweb/statue/comatic
	icon_state = "comatic2"

/obj/structure/lifeweb/statue/cthulhu
	icon_state = "cthulhu"

/obj/structure/lifeweb/statue/green1
	icon_state = "statue1"

/obj/structure/lifeweb/statue/green2
	icon_state = "statue2"

/obj/structure/lifeweb/statue/green3
	icon_state = "statue3"

/obj/structure/lifeweb/statue/green4
	icon_state = "statue4"

/obj/structure/lifeweb/statue/guardian
	icon_state = "guardian"

/obj/structure/lifeweb/statue/pillar
	name = "column"
	desc = "Avoid placing more than four of these, or things may escalate quickly."
	icon_state = "column"
	icon = 'icons/mining.dmi'
	var/chiseled = FALSE


/obj/structure/lifeweb/statue/pillar/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/chisel) && !chiseled)
		playsound(src, 'obj_stone_generic_switch_enter_01.ogg', 80, 0,0)
		var/list/styles = list("Style I", "Style II", "Style III", "(Return)")
		var/styletype = input(user,"Select a column appearance style.","[src]") in styles
		switch(styletype)
			if("Style I")
				icon_state = "column1"
			if("Style II")
				icon_state = "column2"
			if("Style III")
				icon_state = "column3"
			if("(Return)")
				return
		playsound(src, 'obj_stone_generic_switch_enter_01.ogg', 80, 0,0)
		chiseled = TRUE
		user.visible_message("<span class='passive'>\The [user] chisels \the [src]</span>")
		return
	..()
/obj/structure/lifeweb/statue/pillar/destroy()
	for(var/turf/simulated/wall/r_wall/cave/C in range(5, src))
		if(C.collapse_check())
			break
	..()
/obj/structure/lifeweb/statue/pillar/New()
	..()
	dir = SOUTH

/obj/structure/lifeweb/statue/pillar/fancy
	icon_state = "column1"

/obj/structure/lifeweb/statue/pillar/fancy2
	icon_state = "column2"

/obj/structure/lifeweb/statue/pillar/fancy3
	icon_state = "column3"

/obj/structure/decor
	name = "statue"
	desc = "A statue from the past..."
	icon = 'icons/obj/miscobjs.dmi'
	density = 1
	anchored = 1
	breakable = TRUE

/obj/structure/decor/sign
	name = "Firethorn"
	desc = "This is the way to Firethorn!"
	icon_state = "tohell"
	breakable = FALSE

/obj/structure/decor/fakebomb
	name = "\improper Nuclear Fission Explosive"
	desc = "Uh oh. RUN!!!!"
	icon = 'icons/obj/nbomb.dmi'
	icon_state = "nuke"
	breakable = FALSE