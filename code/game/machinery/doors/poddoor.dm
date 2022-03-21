/obj/machinery/door/poddoor
	name = "Podlock"
	desc = "Why it no open!!!"
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = "pdoor1"
	var/id = 1.0
	dir = 1
	explosion_resistance = 25

/obj/machinery/door/poddoor/preopen
	icon_state = "pdoor0"
	density = 0
	opacity = 0

/obj/machinery/door/poddoor/dark
	icon = 'icons/obj/doors/blastdoor_dark.dmi'

/obj/machinery/door/poddoor/dark/preopen
	icon_state = "open"
	density = 0
	opacity = 0

/obj/machinery/door/poddoor/Bumped(atom/AM)
	if(!density)
		return ..()
	else
		return 0

/obj/machinery/door/poddoor/attackby(obj/item/weapon/C as obj, mob/user as mob)
	src.add_fingerprint(user)
	if (!( istype(C, /obj/item/weapon/crowbar) || (istype(C, /obj/item/weapon/twohanded/fireaxe) && C:wielded == 1) ))
		return
	if ((src.density && (stat & NOPOWER) && !( src.operating )))
		spawn( 0 )
			src.operating = 1
			flick("pdoorc0", src)
			src.icon_state = "pdoor0"
			src.set_opacity(0)
			sleep(15)
			src.density = 0
			src.operating = 0
			return
	return

/obj/machinery/door/poddoor/open()
	if (src.operating == 1) //doors can still open when emag-disabled
		return
	if (!ticker)
		return 0
	if(!src.operating) //in case of emag
		src.operating = 1
	flick("pdoorc0", src)
	src.icon_state = "pdoor0"
	src.set_opacity(0)
	sleep(10)
	layer = initial(layer)
	src.density = 0
	update_nearby_tiles()

	if(operating == 1) //emag again
		src.operating = 0
	if(autoclose)
		spawn(30)
			autoclose()
	return 1

/obj/machinery/door/poddoor/close()
	if (src.operating)
		return
	src.operating = 1
	layer = 3.3
	flick("pdoorc1", src)
	src.icon_state = "pdoor1"
	src.density = 1
	src.set_opacity(initial(opacity))
	update_nearby_tiles()
	crush()
	sleep(10)
	src.operating = 0
	return


/obj/machinery/door/poddoor/two_tile_hor/open()
	if (src.operating == 1) //doors can still open when emag-disabled
		return
	if (!ticker)
		return 0
	if(!src.operating) //in case of emag
		src.operating = 1
	flick("pdoorc0", src)
	src.icon_state = "pdoor0"
	src.set_opacity(0)
	f1.set_opacity(0)
	f2.set_opacity(0)

	sleep(10)
	src.density = 0
	f1.density = 0
	f2.density = 0

	update_nearby_tiles()

	if(operating == 1) //emag again
		src.operating = 0
	if(autoclose)
		spawn(150)
			autoclose()
	return 1

/obj/machinery/door/poddoor/two_tile_hor/close()
	if (src.operating)
		return
	src.operating = 1
	flick("pdoorc1", src)
	src.icon_state = "pdoor1"

	src.density = 1
	f1.density = 1
	f2.density = 1

	sleep(10)
	src.set_opacity(initial(opacity))
	f1.set_opacity(initial(opacity))
	f2.set_opacity(initial(opacity))

	update_nearby_tiles()

	src.operating = 0
	return

/obj/machinery/door/poddoor/four_tile_hor/open()
	if (src.operating == 1) //doors can still open when emag-disabled
		return
	if (!ticker)
		return 0
	if(!src.operating) //in case of emag
		src.operating = 1
	flick("pdoorc0", src)
	src.icon_state = "pdoor0"
	sleep(10)
	src.density = 0
	src.set_opacity(0)

	f1.density = 0
	f1.set_opacity(0)
	f2.density = 0
	f2.set_opacity(0)
	f3.density = 0
	f3.set_opacity(0)
	f4.density = 0
	f4.set_opacity(0)

	update_nearby_tiles()

	if(operating == 1) //emag again
		src.operating = 0
	if(autoclose)
		spawn(150)
			autoclose()
	return 1

/obj/machinery/door/poddoor/four_tile_hor/close()
	if (src.operating)
		return
	src.operating = 1
	flick("pdoorc1", src)
	src.icon_state = "pdoor1"
	src.density = 1

	f1.density = 1
	f1.set_opacity(1)
	f2.density = 1
	f2.set_opacity(1)
	f3.density = 1
	f3.set_opacity(1)
	f4.density = 1
	f4.set_opacity(1)

	if (src.visible)
		src.set_opacity(1)
	update_nearby_tiles()

	sleep(10)
	src.operating = 0
	return

/obj/machinery/door/poddoor/two_tile_ver/open()
	if (src.operating == 1) //doors can still open when emag-disabled
		return
	if (!ticker)
		return 0
	if(!src.operating) //in case of emag
		src.operating = 1
	flick("pdoorc0", src)
	src.icon_state = "pdoor0"
	sleep(10)
	src.density = 0
	src.set_opacity(0)

	f1.density = 0
	f1.set_opacity(0)
	f2.density = 0
	f2.set_opacity(0)

	update_nearby_tiles()

	if(operating == 1) //emag again
		src.operating = 0
	if(autoclose)
		spawn(150)
			autoclose()
	return 1

/obj/machinery/door/poddoor/two_tile_ver/close()
	if (src.operating)
		return
	src.operating = 1
	flick("pdoorc1", src)
	src.icon_state = "pdoor1"
	src.density = 1

	f1.density = 1
	f1.set_opacity(1)
	f2.density = 1
	f2.set_opacity(1)

	if (src.visible)
		src.set_opacity(1)
	update_nearby_tiles()

	sleep(10)
	src.operating = 0
	return

/obj/machinery/door/poddoor/four_tile_ver/open()
	if (src.operating == 1) //doors can still open when emag-disabled
		return
	if (!ticker)
		return 0
	if(!src.operating) //in case of emag
		src.operating = 1
	flick("pdoorc0", src)
	src.icon_state = "pdoor0"
	sleep(10)
	src.density = 0
	src.set_opacity(0)

	f1.density = 0
	f1.set_opacity(0)
	f2.density = 0
	f2.set_opacity(0)
	f3.density = 0
	f3.set_opacity(0)
	f4.density = 0
	f4.set_opacity(0)

	update_nearby_tiles()

	if(operating == 1) //emag again
		src.operating = 0
	if(autoclose)
		spawn(35)
			autoclose()
	return 1

/obj/machinery/door/poddoor/four_tile_ver/close()
	if (src.operating)
		return
	src.operating = 1
	flick("pdoorc1", src)
	src.icon_state = "pdoor1"
	src.density = 1

	f1.density = 1
	f1.set_opacity(1)
	f2.density = 1
	f2.set_opacity(1)
	f3.density = 1
	f3.set_opacity(1)
	f4.density = 1
	f4.set_opacity(1)

	if (src.visible)
		src.set_opacity(1)
	update_nearby_tiles()

	sleep(10)
	src.operating = 0
	return




/obj/machinery/door/poddoor/two_tile_hor
	var/obj/machinery/door/poddoor/filler_object/f1
	var/obj/machinery/door/poddoor/filler_object/f2
	icon = 'icons/obj/doors/1x2blast_hor.dmi'

	New()
		..()
		f1 = new/obj/machinery/door/poddoor/filler_object (src.loc)
		f2 = new/obj/machinery/door/poddoor/filler_object (get_step(src,EAST))
		f1.density = density
		f2.density = density
		f1.set_opacity(opacity)
		f2.set_opacity(opacity)

	Destroy()
		del f1
		del f2
		..()

/obj/machinery/door/poddoor/two_tile_ver
	var/obj/machinery/door/poddoor/filler_object/f1
	var/obj/machinery/door/poddoor/filler_object/f2
	icon = 'icons/obj/doors/1x2blast_vert.dmi'

	New()
		..()
		f1 = new/obj/machinery/door/poddoor/filler_object (src.loc)
		f2 = new/obj/machinery/door/poddoor/filler_object (get_step(src,NORTH))
		f1.density = density
		f2.density = density
		f1.set_opacity(opacity)
		f2.set_opacity(opacity)

	Destroy()
		del f1
		del f2
		..()

/obj/machinery/door/poddoor/four_tile_hor
	var/obj/machinery/door/poddoor/filler_object/f1
	var/obj/machinery/door/poddoor/filler_object/f2
	var/obj/machinery/door/poddoor/filler_object/f3
	var/obj/machinery/door/poddoor/filler_object/f4
	icon = 'icons/obj/doors/1x4blast_hor.dmi'

	New()
		..()
		f1 = new/obj/machinery/door/poddoor/filler_object (src.loc)
		f2 = new/obj/machinery/door/poddoor/filler_object (get_step(f1,EAST))
		f3 = new/obj/machinery/door/poddoor/filler_object (get_step(f2,EAST))
		f4 = new/obj/machinery/door/poddoor/filler_object (get_step(f3,EAST))
		f1.density = density
		f2.density = density
		f3.density = density
		f4.density = density
		f1.set_opacity(opacity)
		f2.set_opacity(opacity)
		f4.set_opacity(opacity)
		f3.set_opacity(opacity)

	Destroy()
		del f1
		del f2
		del f3
		del f4
		..()

/obj/machinery/door/poddoor/four_tile_ver
	var/obj/machinery/door/poddoor/filler_object/f1
	var/obj/machinery/door/poddoor/filler_object/f2
	var/obj/machinery/door/poddoor/filler_object/f3
	var/obj/machinery/door/poddoor/filler_object/f4
	icon = 'icons/obj/doors/1x4blast_vert.dmi'

	New()
		..()
		f1 = new/obj/machinery/door/poddoor/filler_object (src.loc)
		f2 = new/obj/machinery/door/poddoor/filler_object (get_step(f1,NORTH))
		f3 = new/obj/machinery/door/poddoor/filler_object (get_step(f2,NORTH))
		f4 = new/obj/machinery/door/poddoor/filler_object (get_step(f3,NORTH))
		f1.density = density
		f2.density = density
		f3.density = density
		f4.density = density
		f1.set_opacity(opacity)
		f2.set_opacity(opacity)
		f4.set_opacity(opacity)
		f3.set_opacity(opacity)

	Destroy()
		del f1
		del f2
		del f3
		del f4
		..()

/obj/machinery/door/poddoor/four_tile_ver/podlock
	autoclose = 1
	icon = 'icons/obj/doors/1x4blast_pod_vert.dmi'

/obj/machinery/door/poddoor/filler_object
	name = ""
	icon_state = ""

/obj/machinery/door/poddoor/autoclose()
	var/obj/machinery/door/poddoor/A = src
	if(!A.density && !A.operating && !A.locked && A.autoclose)
		close()
	return