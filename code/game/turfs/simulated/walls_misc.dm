/turf/simulated/wall/cult
	name = "wall"
	desc = "The patterns engraved on the wall seem to shift as you try to focus on them. You feel sick"
	icon_state = "cult"
	walltype = "cult"

/turf/simulated/wall/heatshield
	thermal_conductivity = 0
	opacity = 0
	name = "heat shielding"
	icon = 'icons/turf/hshield.dmi'
	icon_state = "thermal"

/turf/simulated/wall/rust
	name = "rusted wall"
	desc = "A rusted metal wall."
	icon_state = "arust"
	walltype = "metal"

/turf/simulated/wall/r_wall/rust
	name = "rusted reinforced wall"
	desc = "A huge chunk of rusted reinforced metal."
	icon_state = "rrust"
	walltype = "metal"

/turf/simulated/wall/stone
	name = "wall"
	desc = "A wooden wall."
	icon = 'icons/turf/stone_walls.dmi'
	icon_state = "wall15"
	walltype = "rwall"
	climbable = TRUE
	turf_above = /turf/simulated/floor/lifeweb

/turf/simulated/wall/New()
	..()
	var/turf/above = locate(src.x, src.y, src.z+1)
	if(istype(above, /turf/simulated/floor/open))
		new turf_above(above)
/obj/New()
	..()
	if(istype(loc, /turf/simulated/wall))
		src.plane = 21
		src.layer = 10

/turf/simulated/wall/soulbreakernew
	name = "hive wall"
	desc = "A metal wall."
	icon = 'icons/turf/soulwall1.dmi'
	icon_state = "rwall0"
	walltype = "rwall"


/turf/simulated/wall/soulbreakernew2
	name = "hive wall"
	desc = "A metal wall."
	icon = 'icons/turf/soulwall2.dmi'
	icon_state = "rwall0"
	walltype = "rwall"


/turf/simulated/wall/bullet_act()
	..()
	var/som = pick('sound/projectilesnew/rock1.ogg', 'sound/projectilesnew/rock2.ogg', 'sound/projectilesnew/rock3.ogg', 'sound/projectilesnew/rock4.ogg', 'sound/projectilesnew/rock5.ogg')
	playsound(src, som, 300, 0)

/turf/simulated/wall/stone/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mover
		if(H.isChild() && H.jumping)
			for(var/obj/structure/lfwindow/S in src.contents)
				if(S && !S.closed)
					return 1
	..()

/turf/simulated/wall/stone/handcrafted
	name = "wall"
	desc = "A stone wall, built recently."
	icon = 'icons/turf/stone_walls.dmi'
	icon_state = "wall15"
	walltype = "rwall"
	climbable = TRUE
/*
/turf/simulated/wall/stone/handcrafted/New()
	var/turf/controllerlocation = locate(src.x, src.y, src.z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		if(controller.up)
			var/turf/above = locate(src.x, src.y, controller.up_target)
			if(above)
				if(istype(above,/turf/space) || istype(above,/turf/simulated/floor/open))
					var/turf/simulated/floor/lifeweb/stone/NG = new(locate(src.x, src.y, controller.up_target))
					NG.desc = "Um chão de pedra, parece ter um suporte em baixo e recém construido."
					NG = locate(src.x, src.y, controller.up_target)
	return
*/
/turf/simulated/wall/stonemanual
	name = "wall"
	desc = "A wooden wall."
	icon = 'icons/turf/stone_walls.dmi'
	icon_state = "walls_manuais"
	walltype = "rwall"


/turf/simulated/wall/soulbreakermanual
	name = "wall"
	desc = "A metal wall."
	icon = 'icons/turf/soul_wall.dmi'
	icon_state = "rwall15"
	walltype = "rwall"


/turf/simulated/wall/train
	name = "wall"
	desc = "A metal wall."
	icon = 'icons/turf/train.dmi'
	icon_state = "1"
	walltype = "rwall"


/turf/simulated/wall/train/New()
	return 0

/turf/simulated/wall/train/_2
	icon_state = "2"

/turf/simulated/wall/train/_3
	icon_state = "3"

/turf/simulated/wall/greenwall
	name = "wall"
	desc = "A metal wall."
	icon = 'icons/turf/anothawall.dmi'
	icon_state = "rwall0"
	walltype = "rwall"

/turf/simulated/wall/woodwall
	name = "wall"
	desc = "A wood wall."
	icon = 'icons/turf/woodwall.dmi'
	icon_state = "rwall0"
	walltype = "rwall"
	burnAble = 1
	flammable = 1
	turf_above = /turf/simulated/floor/lifeweb/wood

/turf/simulated/wall/stonenoopacity
	name = "wall"
	desc = "A wooden wall."
	opacity = 0
	icon = 'icons/turf/stone_walls.dmi'
	icon_state = "wall15"
	walltype = "rwall"


/obj/structure/lfwindow/stonewindow
	icon = 'icons/turf/stone_walls.dmi'
	name = "stone window"
	opacity = 0
	desc = "A stone window."
	icon_state = "fort3"

/obj/structure/lfwindow/stonewindowopen
	name = "stone window"
	icon = 'icons/turf/stone_walls.dmi'
	desc = "A stone window."
	icon_state = "fort2"
	density = 1
	anchored = 1
	opacity = 0
