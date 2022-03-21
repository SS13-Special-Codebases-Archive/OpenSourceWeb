//Terribly sorry for the code doubling, but things go derpy otherwise.
/obj/machinery/door/airlock/multi_tile
	width = 2

/obj/machinery/door/airlock/multi_tile/glass
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Door2x1glass.dmi'
	opacity = 0
	glass = 1
	assembly_type = "obj/structure/door_assembly/multi_tile"

/obj/machinery/door/airlock/multi_tile/metal
	name = "Airlock"
	icon = 'icons/obj/doors/Door2x1metal.dmi'
	glass = 1
	assembly_type = "obj/structure/door_assembly/multi_tile"

/obj/machinery/door/airlock/multi_tile/noble
	name = "Keep Airlock"
	icon = 'icons/obj/doors/Door2x1keep.dmi'
	glass = 0
	opacity = 1
	assembly_type = "obj/structure/door_assembly/multi_tile"

/obj/machinery/door/airlock/multi_tile/noble/church
	name = "Church Airlock"
	icon = 'icons/obj/doors/Door2x1church.dmi'
	glass = 0
	opacity = 1
	assembly_type = "obj/structure/door_assembly/multi_tile"

/obj/machinery/door/airlock/multi_tile/noble/New()
	..()
	if(src.dir > 3)
		f5 = new/obj/machinery/filler_object(src.loc)
		f6 = new/obj/machinery/filler_object(get_step(src,EAST))
	else
		f5 = new/obj/machinery/filler_object(src.loc)
		f6 = new/obj/machinery/filler_object(get_step(src,NORTH))
	f5.density = FALSE
	f6.density = FALSE
	f5.opacity = (opacity)
	f6.opacity = (opacity)

/obj/machinery/door/airlock/multi_tile/noble/Destroy()
	qdel(f5)
	qdel(f6)
	. = ..()

/obj/machinery/filler_object
	name = ""
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = ""
	density = FALSE
	anchored = TRUE
