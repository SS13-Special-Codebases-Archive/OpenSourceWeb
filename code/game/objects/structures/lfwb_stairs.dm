/obj/structure/lifeweb/stairs
	name = "stairs down"
	icon_state = "ramptop"
	layer = 2
	plane = 0
	can_in = TRUE
	var/istop = TRUE
	var/obj/structure/lifeweb/stairs/stairs_where
	donation_storage = FALSE

	New()
		..()
		init_obj.Add(src)

/obj/structure/lifeweb/stairs/initialize()
	find_stairs_where()

/obj/structure/lifeweb/stairs/proc/find_stairs_where()
	var/turf/T = istop ? GetBelow() : GetAbove()
	stairs_where = locate(/obj/structure/lifeweb/stairs) in T

/obj/structure/lifeweb/stairs/Bumped(var/atom/movable/M)
	if(M.loc != src.loc)
		return 0

	var/dir_bimp = reverse ? turn(dir, 180) : dir

	if(M.dir != dir_bimp)
		return

	if(!M.gravitydep)
		return

	if(!stairs_where)
		if(istop)
			to_chat(M, "<span class='combat'>There are no stairs down!</span>")
		else
			to_chat(M, "<span class='combat'>There are no stairs up!</span>")
		return 0

	if(ismob(M) && M:client)
		M:client.moving = 1

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.sprinting || H.confused)
			var/damage = 8
			H.apply_damage(damage + rand(-5,5), BRUTE, "l_leg")
			H.apply_damage(damage + rand(-5,5), BRUTE, "r_leg")
			H.apply_damage(damage + rand(-5,5), BRUTE, "r_foot")
			H.apply_damage(damage + rand(-5,5), BRUTE, "l_foot")
			H:weakened = max(H:weakened,4)
			recoil(H)
			H.adjustStaminaLoss(rand(2,5))
			playsound(H.loc, 'sound/weapons/bite.ogg', 70, 0)
			H.sound2()
			H.sprinting = FALSE
			H.CU()
			if(prob(80))
				H.apply_effect(5, PARALYZE)
				visible_message("<span class='combatglow'><b>[H]</b> has been knocked unconscious!</span>")
				H.ear_deaf = max(H.ear_deaf,6)
				H.CU()

	M.forceMove(stairs_where.loc)
	if(isliving(M))
		var/mob/living/L = M
		if(L.client)
			if(istop)
				to_chat(L,"<i>You climb down the stairs.</i>")
			else
				to_chat(L,"<i>You climb up the stairs.</i>")
	if (ismob(M) && M:client)
		M:client.moving = 0

/obj/structure/lifeweb/stairs/Click()
	if(!istype(usr,/mob/dead/observer))
		return ..()
	if(usr.loc != src.loc)
		return 0
	usr.client.moving = 1
	usr.forceMove(stairs_where.loc)
	usr.client.moving = 0

/obj/structure/lifeweb/stairs/proc/GetBelow()
	var/turf/T = locate(x,y,z-1)
	return T

/obj/structure/lifeweb/stairs/proc/GetAbove()
	var/turf/T = locate(x,y,z+1)
	return T

/obj/structure/lifeweb/stairs/down
	name = "stairs up"
	icon_state = "rampbottom"
	istop = FALSE
	onedir = TRUE
	reverse = TRUE

/obj/structure/lifeweb/stairs/cave
	name = "cave stairs down"
	icon_state = "caveramp"

/obj/structure/lifeweb/stairs/cave/down
	name = "cave stairs up"
	istop = FALSE
	onedir = TRUE
	reverse = TRUE

/obj/structure/lifeweb/stairs/wooden
	name = "wooden stairs down"
	icon_state = "wramp"

/obj/structure/lifeweb/stairs/wooden/down
	name = "wooden stairs up"
	istop = FALSE
	onedir = TRUE
	reverse = TRUE
