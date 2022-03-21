/* Tables and Racks
 * Contains:
 *		Tables
 *		Wooden tables
 *		Reinforced tables
 *		Racks
 */


/*
 * Tables
 */
/obj/structure/table
	name = "table"
	desc = "A square piece of metal standing on four metal legs. It can not move."
	icon = 'icons/obj/structures.dmi'
	icon_state = "table"
//	density = 1
	anchored = 1.0
	layer = 2.8
	throwpass = 1	//You can throw objects over this, despite it's density.")
	parts = /obj/item/weapon/table_parts
	var/busy = 0

	var/flipped = 0
	var/dented = 0
	var/health = 100

	var/frame = /obj/structure/table_frame
	var/mob/tableclimber

/obj/structure/table/proc/update_adjacent()
	for(var/direction in list(1,2,4,8,5,6,9,10))
		if(locate(/obj/structure/table,get_step(src,direction)))
			var/obj/structure/table/T = locate(/obj/structure/table,get_step(src,direction))
			T.update_icon()

/obj/structure/table/New()
	..()
	for(var/obj/structure/table/T in src.loc)
		if(T != src)
			qdel(T)
	update_icon()
	update_adjacent()

/obj/structure/table/Destroy()
	update_adjacent()
	..()


//Thanks InfinityStation!
/obj/structure/table/Crossed(var/mob/living/M as mob)
	if(istype(src, /obj/structure/table/glass))
		return 0
	if(!flipped)
		if(istype(M))
			M.pixel_y = 12

/obj/structure/table/Uncrossed(var/mob/living/M as mob)
	if(!flipped)
		if(istype(M))
			M.pixel_y = 0

/obj/structure/table/update_icon()
	spawn(2) //So it properly updates when deleting

		if(flipped)
			var/type = 0
			var/tabledirs = 0
			for(var/direction in list(turn(dir,90), turn(dir,-90)) )
				var/obj/structure/table/T = locate(/obj/structure/table,get_step(src,direction))
				if (T && T.flipped && T.dir == src.dir)
					type++
					tabledirs |= direction
			var/base = "table"
			if (istype(src, /obj/structure/table/woodentable))
				base = "wood"
			if (istype(src, /obj/structure/table/reinforced))
				base = "rtable"

			icon_state = "[base]flip[type]"
			if (type==1)
				if (tabledirs & turn(dir,90))
					icon_state = icon_state+"-"
				if (tabledirs & turn(dir,-90))
					icon_state = icon_state+"+"
			return 1

		var/dir_sum = 0
		for(var/direction in list(1,2,4,8,5,6,9,10))
			var/skip_sum = 0
			for(var/obj/structure/window/W in src.loc)
				if(W.dir == direction) //So smooth tables don't go smooth through windows
					skip_sum = 1
					continue
			var/inv_direction //inverse direction
			switch(direction)
				if(1)
					inv_direction = 2
				if(2)
					inv_direction = 1
				if(4)
					inv_direction = 8
				if(8)
					inv_direction = 4
				if(5)
					inv_direction = 10
				if(6)
					inv_direction = 9
				if(9)
					inv_direction = 6
				if(10)
					inv_direction = 5
			for(var/obj/structure/window/W in get_step(src,direction))
				if(W.dir == inv_direction) //So smooth tables don't go smooth through windows when the window is on the other table's tile
					skip_sum = 1
					continue
			if(!skip_sum) //means there is a window between the two tiles in this direction
				var/obj/structure/table/T = locate(/obj/structure/table,get_step(src,direction))
				if(T && !T.flipped)
					if(direction <5)
						dir_sum += direction
					else
						if(direction == 5)	//This permits the use of all table directions. (Set up so clockwise around the central table is a higher value, from north)
							dir_sum += 16
						if(direction == 6)
							dir_sum += 32
						if(direction == 8)	//Aherp and Aderp.  Jezes I am stupid.  -- SkyMarshal
							dir_sum += 8
						if(direction == 10)
							dir_sum += 64
						if(direction == 9)
							dir_sum += 128

		var/table_type = 0 //stand_alone table
		if(dir_sum%16 in cardinal)
			table_type = 1 //endtable
			dir_sum %= 16
		if(dir_sum%16 in list(3,12))
			table_type = 2 //1 tile thick, streight table
			if(dir_sum%16 == 3) //3 doesn't exist as a dir
				dir_sum = 2
			if(dir_sum%16 == 12) //12 doesn't exist as a dir.
				dir_sum = 4
		if(dir_sum%16 in list(5,6,9,10))
			if(locate(/obj/structure/table,get_step(src.loc,dir_sum%16)))
				table_type = 3 //full table (not the 1 tile thick one, but one of the 'tabledir' tables)
			else
				table_type = 2 //1 tile thick, corner table (treated the same as streight tables in code later on)
			dir_sum %= 16
		if(dir_sum%16 in list(13,14,7,11)) //Three-way intersection
			table_type = 5 //full table as three-way intersections are not sprited, would require 64 sprites to handle all combinations.  TOO BAD -- SkyMarshal
			switch(dir_sum%16)	//Begin computation of the special type tables.  --SkyMarshal
				if(7)
					if(dir_sum == 23)
						table_type = 6
						dir_sum = 8
					else if(dir_sum == 39)
						dir_sum = 4
						table_type = 6
					else if(dir_sum == 55 || dir_sum == 119 || dir_sum == 247 || dir_sum == 183)
						dir_sum = 4
						table_type = 3
					else
						dir_sum = 4
				if(11)
					if(dir_sum == 75)
						dir_sum = 5
						table_type = 6
					else if(dir_sum == 139)
						dir_sum = 9
						table_type = 6
					else if(dir_sum == 203 || dir_sum == 219 || dir_sum == 251 || dir_sum == 235)
						dir_sum = 8
						table_type = 3
					else
						dir_sum = 8
				if(13)
					if(dir_sum == 29)
						dir_sum = 10
						table_type = 6
					else if(dir_sum == 141)
						dir_sum = 6
						table_type = 6
					else if(dir_sum == 189 || dir_sum == 221 || dir_sum == 253 || dir_sum == 157)
						dir_sum = 1
						table_type = 3
					else
						dir_sum = 1
				if(14)
					if(dir_sum == 46)
						dir_sum = 1
						table_type = 6
					else if(dir_sum == 78)
						dir_sum = 2
						table_type = 6
					else if(dir_sum == 110 || dir_sum == 254 || dir_sum == 238 || dir_sum == 126)
						dir_sum = 2
						table_type = 3
					else
						dir_sum = 2 //These translate the dir_sum to the correct dirs from the 'tabledir' icon_state.
		if(dir_sum%16 == 15)
			table_type = 4 //4-way intersection, the 'middle' table sprites will be used.

		if(istype(src,/obj/structure/table/reinforced))
			switch(table_type)
				if(0)
					icon_state = "reinf_table"
				if(1)
					icon_state = "reinf_1tileendtable"
				if(2)
					icon_state = "reinf_1tilethick"
				if(3)
					icon_state = "reinf_tabledir"
				if(4)
					icon_state = "reinf_middle"
				if(5)
					icon_state = "reinf_tabledir2"
				if(6)
					icon_state = "reinf_tabledir3"
		else if(istype(src,/obj/structure/table/woodentable))
			switch(table_type)
				if(0)
					icon_state = "wood_table"
				if(1)
					icon_state = "wood_1tileendtable"
				if(2)
					icon_state = "wood_1tilethick"
				if(3)
					icon_state = "wood_tabledir"
				if(4)
					icon_state = "wood_middle"
				if(5)
					icon_state = "wood_tabledir2"
				if(6)
					icon_state = "wood_tabledir3"
		else if(istype(src,/obj/structure/table/glass))
			switch(table_type)
				if(0)
					icon_state = "glasstable"
				if(1)
					icon_state = "glasstable_1tileendtable"
				if(2)
					icon_state = "glasstable_1tilethick"
				if(3)
					icon_state = "glasstable_dir"
				if(4)
					icon_state = "glasstable_middle"
				if(5)
					icon_state = "glasstable_dir2"
				if(6)
					icon_state = "glasstable_dir3"
		else
			switch(table_type)
				if(0)
					icon_state = "table"
				if(1)
					icon_state = "table_1tileendtable"
				if(2)
					icon_state = "table_1tilethick"
				if(3)
					icon_state = "tabledir"
				if(4)
					icon_state = "table_middle"
				if(5)
					icon_state = "tabledir2"
				if(6)
					icon_state = "tabledir3"
		if (dir_sum in list(1,2,4,8,5,6,9,10))
			dir = dir_sum
		else
			dir = 2

/obj/structure/table/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				destroy()
		else
	return


/obj/structure/table/examine()
	set src in oview()
	..()
	if(dented)
		usr << "It looks to have [dented] [prob(30) ? "face shaped " : ""] dents in it."


/obj/structure/table/blob_act()
	if(prob(75))
		destroy()

/obj/structure/table/attack_paw(mob/user)
	if(HULK in user.mutations)
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
		visible_message("<span class='danger'>[user] smashes the [src] apart!</span>")
		destroy()

/obj/structure/table/attack_animal(mob/living/simple_animal/user)
	if(user.wall_smash)
		visible_message("<span class='danger'>[user] smashes [src] apart!</span>")
		destroy()

/obj/structure/table/attack_tk() // no telehulk sorry
	return

/obj/structure/table/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover,/obj/item/projectile))
		return (check_cover(mover,target))
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	if(locate(/obj/structure/table) in get_turf(mover))
		return 1
	if (flipped)
		if (get_dir(loc, target) == dir)
			return density
		else
			return 1
	return 0

//checks if projectile 'P' from turf 'from' can hit whatever is behind the table. Returns 1 if it can, 0 if bullet stops.
/obj/structure/table/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover = flipped ? get_turf(src) : get_step(loc, get_dir(from, loc))
	if (get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return 1
	if (get_turf(P.original) == cover)
		var/chance = 20
		if (ismob(P.original))
			var/mob/M = P.original
			if (M.lying)
				chance += 20				//Lying down lets you catch less bullets
		if(flipped)
			if(get_dir(loc, from) == dir)	//Flipped tables catch mroe bullets
				chance += 20
			else
				return 1					//But only from one side
		if(prob(chance))
			health -= P.damage/2
			if (health > 0)
				visible_message("<span class='warning'>[P] hits \the [src]!</span>")
				return 0
			else
				visible_message("<span class='warning'>[src] breaks down!</span>")
				destroy()
				return 1
	return 1

/obj/structure/table/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSTABLE))
		return 1
	if (flipped)
		if (get_dir(loc, target) == dir)
			return density
		else
			return 1
	return 1

/obj/structure/table/MouseDrop_T(obj/O as obj, mob/user as mob)
	if(ismob(O) && user == O && ishuman(user))
		if(user.canmove)
			climb_table(user)
			return
	if ((!( istype(O, /obj/item/weapon) ) || user.get_active_hand() != O))
		return
	if(isrobot(user))
		return
	if(!user.drop_item())
		return
	if (O.loc != src.loc)
		step(O, get_dir(O, src))
	return


/obj/structure/table/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = W
		if(G.state == 2 && G.assailant.zone_sel.selecting == "head")
			if(ishuman(G.affecting))
				G.affecting.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been smashed on a table by [G.assailant.name] ([G.assailant.ckey])</font>")
				G.assailant.attack_log += text("\[[time_stamp()]\] <font color='red'>Smashed [G.affecting.name] ([G.affecting.ckey]) on a table.</font>")

				//log_admin("ATTACK: [G.assailant] ([G.assailant.ckey]) smashed [G.affecting] ([G.affecting.ckey]) on a table.", 2)
				message_admins("ATTACK: [G.assailant] ([G.assailant.ckey])(<A HREF='?_src_=holder;adminplayerobservejump=\ref[G]'>JMP</A>) smashed [G.affecting] ([G.affecting.ckey]) on a table.", 2)
				log_attack("[G.assailant] ([G.assailant.ckey]) smashed [G.affecting] ([G.affecting.ckey]) on a table.")

				var/mob/living/carbon/human/H = G.affecting
				var/datum/organ/external/affecting = H.get_organ("head")
				if(prob(25))
					add_blood(G.affecting, 1) //Forced
					affecting.take_damage(rand(10,15), 0)
					H.Weaken(2)
					if(prob(20)) // One chance in 20 to DENT THE TABLE
						affecting.take_damage(rand(5,10), 0) //Extra damage
						if(dented)
							G.assailant.visible_message("\red \The [G.assailant] smashes \the [H]'s head on \the [src] with enough force to further deform \the [src]!\nYou wish you could unhear that sound.",\
							"\red You smash \the [H]'s head on \the [src] with enough force to leave another dent!\n[prob(50)?"That was a satisfying noise." : "That sound will haunt your nightmares"]",\
							"\red You hear the nauseating crunch of bone and gristle on solid metal and the squeal of said metal deforming.")
						else
							G.assailant.visible_message("\red \The [G.assailant] smashes \the [H]'s head on \the [src] so hard it left a dent!\nYou wish you could unhear that sound.",\
							"\red You smash \the [H]'s head on \the [src] with enough force to leave a dent!\n[prob(5)?"That was a satisfying noise." : "That sound will haunt your nightmares"]",\
							"\red You hear the nauseating crunch of bone and gristle on solid metal and the squeal of said metal deforming.")
						dented++
					else if(prob(50))
						G.assailant.visible_message("\red [G.assailant] smashes \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] bone and cartilage making a loud crunch!",\
						"\red You smash \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] bone and cartilage making a loud crunch!",\
						"\red You hear the nauseating crunch of bone and gristle on solid metal, the noise echoing through the room.")
					else
						G.assailant.visible_message("\red [G.assailant] smashes \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] nose smashed and face bloodied!",\
						"\red You smash \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] nose smashed and face bloodied!",\
						"\red You hear the nauseating crunch of bone and gristle on solid metal and the gurgling gasp of someone who is trying to breathe through their own blood.")
				else
					affecting.take_damage(rand(5,10), 0)
					G.assailant.visible_message("\red [G.assailant] smashes \the [H]'s head on \the [src]!",\
					"\red You smash \the [H]'s head on \the [src]!",\
					"\red You hear the nauseating crunch of bone and gristle on solid metal.")
				H.UpdateDamageIcon()
				H.updatehealth()
				playsound(src.loc, 'sound/weapons/tablehit1.ogg', 50, 1, -3)
			return
		if(!G.affecting.buckled)
			G.affecting.loc = src.loc
			G.affecting.Weaken(5)
			for(var/mob/O in viewers(world.view, src))
				if (O.client)
					O << "\red [G.assailant] puts [G.affecting] on the table."
			qdel(W)
		return

	if (istype(W, /obj/item/weapon/wrench))
		user << "\blue Now disassembling table"
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user,50))
			destroy()
		return

	if(isrobot(user))
		return

	if(istype(W, /obj/item/weapon/melee/energy/blade))
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, src.loc)
		spark_system.start()
		playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
		playsound(src.loc, "sparks", 50, 1)
		for(var/mob/O in viewers(user, 4))
			O.show_message("\blue The [src] was sliced apart by [user]!", 1, "\red You hear [src] coming apart.", 2)
		destroy()

	user.drop_item(src)
	return

/obj/structure/table/proc/straight_table_check(var/direction)
	var/obj/structure/table/T
	for(var/angle in list(-90,90))
		T = locate() in get_step(src.loc,turn(direction,angle))
		if(T && !T.flipped)
			return 0
	T = locate() in get_step(src.loc,direction)
	if (!T || T.flipped)
		return 1
	if (istype(T,/obj/structure/table/reinforced/))
		var/obj/structure/table/reinforced/R = T
		if (R.status == 2)
			return 0
	return T.straight_table_check(direction)

/obj/structure/table/verb/can_touch(var/mob/user)
	if (!user)
		return 0
	if (user.stat)	//zombie goasts go away
		return 0
	if (issilicon(user))
		user << "<span class='notice'>You need hands for this.</span>"
		return 0
	return 1

/obj/structure/table/verb/do_flip()
	set name = "Flip table"
	set desc = "Flips a non-reinforced table"
	set category = "Object"
	set src in oview(1)
	if(ismouse(usr))
		return
	if (!can_touch(usr))
		return
	if(!flip(get_cardinal_dir(usr,src)))
		usr << "<span class='notice'>It won't budge.</span>"
	else
		usr.visible_message("<span class='warning'>[usr] flips \the [src]!</span>")
		return

/obj/structure/table/proc/unflipping_check(var/direction)
	for(var/mob/M in oview(src,0))
		return 0

	var/list/L = list()
	if(direction)
		L.Add(direction)
	else
		L.Add(turn(src.dir,-90))
		L.Add(turn(src.dir,90))
	for(var/new_dir in L)
		var/obj/structure/table/T = locate() in get_step(src.loc,new_dir)
		if(T)
			if(T.flipped && T.dir == src.dir && !T.unflipping_check(new_dir))
				return 0
	return 1

/obj/structure/table/proc/do_put()
	set name = "Put table back"
	set desc = "Puts flipped table back"
	set category = "Object"
	set src in oview(1)

	if (!can_touch(usr))
		return

	if (!unflipping_check())
		usr << "<span class='notice'>It won't budge.</span>"
		return
	unflip()

/obj/structure/table/proc/flip(var/direction)
	if( !straight_table_check(turn(direction,90)) || !straight_table_check(turn(direction,-90)) )
		return 0

	verbs -=/obj/structure/table/verb/do_flip
	verbs +=/obj/structure/table/proc/do_put

	var/list/targets = list(get_step(src,dir),get_step(src,turn(dir, 45)),get_step(src,turn(dir, -45)))
	for (var/atom/movable/A in get_turf(src))
		if (!A.anchored)
			spawn(0)
				A.throw_at(pick(targets),1,1)

	dir = direction
	if(dir != NORTH)
		layer = 5
	flipped = 1
	flags |= ON_BORDER
	for(var/D in list(turn(direction, 90), turn(direction, -90)))
		var/obj/structure/table/T = locate() in get_step(src,D)
		if(T && !T.flipped)
			T.flip(direction)
	update_icon()
	update_adjacent()

	return 1

/obj/structure/table/proc/unflip()
	verbs -=/obj/structure/table/proc/do_put
	verbs +=/obj/structure/table/verb/do_flip

	layer = initial(layer)
	flipped = 0
	flags &= ~ON_BORDER
	for(var/D in list(turn(dir, 90), turn(dir, -90)))
		var/obj/structure/table/T = locate() in get_step(src.loc,D)
		if(T && T.flipped && T.dir == src.dir)
			T.unflip()
	update_icon()
	update_adjacent()

	return 1

/*
 * TABLE INTERACTION
 */

/obj/structure/table/proc/climb_table(mob/user)
	src.add_fingerprint(user)
	user.visible_message("<span class='combatbold'>[user]</span> <span class='combat'>starts climbing onto [src].</span>", \
								"<span class='passive'>I climb onto [src].</span>")
	var/climb_time = 5
	if(user.restrained()) //Table climbing takes twice as long when restrained.
		climb_time = 10
	tableclimber = user
	if(do_mob(user, user, climb_time))
		if(src.loc) //Checking if table has been destroyed
			user.pass_flags += PASSTABLE
			step(user,get_dir(user,src.loc))
			user.pass_flags -= PASSTABLE
			user.visible_message("<span class='warning'>[user] climbs onto [src].</span>", \
									"<span class='notice'>You climb onto [src].</span>")
			add_logs(user, src, "climbed onto")
			user.Stun(1)
			tableclimber = null
			return 1
	tableclimber = null
	return 0

/obj/structure/table/proc/tablepush(obj/item/I, mob/user)
	if(get_dist(src, user) < 2)
		var/obj/item/weapon/grab/G = I
		if(G.affecting.buckled)
			user << "<span class='warning'>[G.affecting] is buckled to [G.affecting.buckled]!</span>"
			return 0
		if(G.state < GRAB_AGGRESSIVE)
			user << "<span class='warning'>You need a better grip to do that!</span>"
			return 0
		if(!G.confirm())
			return 0
		if(G.assailant.zone_sel.selecting == "head")
			G.affecting.loc = src.loc
			G.affecting.Weaken(5)
			G.affecting.visible_message("<span class='danger'>[G.assailant] hits [G.affecting] head on the [src].</span>", \
										"<span class='userdanger'>[G.assailant] hits [G.affecting] head on the [src].</span>")
			add_logs(G.assailant, G.affecting, "hits head on table")
			qdel(I)
		else
			G.affecting.loc = src.loc
			G.affecting.Weaken(5)
			G.affecting.visible_message("<span class='danger'>[G.assailant] pushes [G.affecting] onto [src].</span>", \
										"<span class='userdanger'>[G.assailant] pushes [G.affecting] onto [src].</span>")
			add_logs(G.assailant, G.affecting, "pushed")
			qdel(I)

		return 1
	qdel(I)


/*
 * Glass tables
 */

/obj/structure/table/glass
	name = "glass table"
	desc = "What did I say about leaning on the glass tables? Now you need surgery."
	icon_state = "glasstable"
//	parts = // TODO: construction
	health = 30

/obj/structure/table/glass/tablepush(obj/item/I, mob/user)
	if(..())
		visible_message("<span class='warning'>[src] breaks!</span>")
		playsound(src.loc, "shatter", 50, 1)
		new frame(src.loc)
		new /obj/item/weapon/shard(src.loc)
		qdel(src)


/obj/structure/table/glass/climb_table(mob/user)
	if(..())
		visible_message("<span class='warning'>[src] breaks!</span>")
		playsound(src.loc, "shatter", 50, 1)
		new frame(src.loc)
		new /obj/item/weapon/shard(src.loc)
		qdel(src)
		user.Weaken(5)


/*
 * Wooden tables
 */
/obj/structure/table/woodentable
	name = "wooden table"
	desc = "Do not apply fire to this. Rumour says it burns easily."
	icon_state = "wood_table"
	parts = /obj/item/weapon/table_parts/wood
	health = 50
/*
 * Reinforced tables
 */
/obj/structure/table/reinforced
	name = "reinforced table"
	desc = "A version of the four legged table. It is stronger."
	icon_state = "reinf_table"
	health = 200
	var/status = 2
	parts = /obj/item/weapon/table_parts/reinforced

/obj/structure/table/reinforced/lw
	icon_state = "tablelw"

/obj/structure/table/reinforced/flip(var/direction)
	if (status == 2)
		return 0
	else
		return ..()

/obj/structure/table/reinforced/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			if(src.status == 2)
				user << "\blue Now weakening the reinforced table"
				playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
				if (do_after(user, 50))
					if(!src || !WT.isOn()) return
					user << "\blue Table weakened"
					src.status = 1
			else
				user << "\blue Now strengthening the reinforced table"
				playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
				if (do_after(user, 50))
					if(!src || !WT.isOn()) return
					user << "\blue Table strengthened"
					src.status = 2
			return
		return

	if (istype(W, /obj/item/weapon/wrench))
		if(src.status == 2)
			return

	..()


/*
 * Racks
 */
/obj/structure/rack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"
//	density = 1
	flags = FPRINT
	anchored = 1.0
	throwpass = 1	//You can throw objects over this, despite it's density.
	parts = /obj/item/weapon/rack_parts

/obj/structure/rack/iron
	icon_state = "rack1"

/obj/structure/rack/iron2
	icon_state = "rack2"

/obj/structure/rack/lwtable
	density = 1
	name = "table"
	desc = "A fancy table."
	layer = 2.8
	parts = null
	throwpass = 1
	anchored = 1
	var/narrow = 0
	var/flipped = 0
	var/health = 9000
	var/mob/tableclimber

/obj/structure/rack/lwtable/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover = flipped ? get_turf(src) : get_step(loc, get_dir(from, loc))
	if (get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return 1
	if (get_turf(P.original) == cover)
		var/chance = 20
		if (ismob(P.original))
			var/mob/M = P.original
			if (M.lying)
				chance += 20				//Lying down lets you catch less bullets
		if(prob(chance))
			health -= P.damage/2
			if (health > 0)
				visible_message("<span class='warning'>[P] hits \the [src]!</span>")
				return 0
			else
				visible_message("<span class='warning'>[src] breaks down!</span>")
				destroy()
				return 1
	return 1

/obj/structure/rack/lwtable/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover,/obj/item/projectile))
		return (check_cover(mover,target))
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	if(locate(/obj/structure/rack/lwtable) in get_turf(mover))
		return 1
	return 0

/obj/structure/rack/lwtable/MiddleClick(mob/living/user as mob)
	user.setClickCooldown(DEFAULT_SLOW_COOLDOWN)
	if(get_dist(src,user) <= 1)
		if(narrow == 1)
			if(!(ishuman(usr)  && istype(usr:species, /datum/species/human/alien)))
				to_chat(user,"<span class='combatbold'>[pick(nao_consigoen)] the table is too narrow!</span>")
				return

		if(user.stat)
			return

		if(user.resting)
			return

		if(user.sleeping)
			return

		if(user.stunned)
			return

		if(user.canmove)
			climb_table(user)
			return
	return

/obj/structure/rack/lwtable/Crossed(var/mob/living/M as mob)
	if(istype(src, /obj/structure/table/glass))
		return 0
	if(!flipped)
		if(istype(M))
			M.pixel_y = 12

/obj/structure/rack/lwtable/Uncrossed(var/mob/living/M as mob)
	if(!flipped)
		if(istype(M))
			M.pixel_y = 0

/*
/obj/structure/rack/lwtable/MiddleClick(obj/O as obj, mob/user as mob)
	if(narrow == 1)
		to_chat(user,"<span class='warning'>It's too narrow, I can't climb it!</span>")
		return
	if(ismob(O) && user == O && ishuman(user))
		if(user.canmove)
			climb_table(user)
			return
	if ((!( istype(O, /obj/item/weapon) ) || user.get_active_hand() != O))
		return
	if(isrobot(user))
		return
	if(!user.drop_item())
		return
	if (O.loc != src.loc)
		step(O, get_dir(O, src))
	return
*/
/obj/structure/rack/lwtable/proc/climb_table(mob/user)
	src.add_fingerprint(user)
	user.visible_message("<span class='warning'>[user] starts climbing onto [src].</span>", \
								"<span class='notice'>You start climbing onto [src]...</span>")
	var/climb_time = 1
	if(user.restrained()) //Table climbing takes twice as long when restrained.
		climb_time = 2
	var/mob/living/carbon/human/H = user
	var/list/rolled = roll3d6(user,SKILL_CLIMB,null)
	switch(rolled[GP_RESULT])
		if(GP_CRITFAIL)
			var/damage = 10
			visible_message("<span class='crithit'>CRITICAL FAILURE!</span> <span class='hitbold'><b>[H]</b></span><span class='hit'> fails to climb the table!</span>")
			H.apply_damage(damage + rand(-3,15), BRUTE, "head")
			H.apply_damage(damage + rand(-3,15), BRUTE, "r_chest")
			H:weakened = max(H:weakened,4)
			recoil(H)
			H.adjustStaminaLoss(rand(10,20))
			playsound(H.loc, 'sound/weapons/bite.ogg', 70, 0)
			step_away(H,src,1)
			H.sound2()
			if(prob(80))
				H.apply_effect(5, PARALYZE)
				visible_message("<span class='combatglow'><b>[H]</b>< has been knocked unconscious!</span>")
				H.ear_damage += rand(0, 3)
				H.ear_deaf = max(H.ear_deaf,6)
			H.CU()
			return
		else
			tableclimber = user
			if(do_mob(user, user, climb_time))
				if(src.loc) //Checking if table has been destroyed
					user.pass_flags += PASSTABLE
					step(user,get_dir(user,src.loc))
					user.pass_flags -= PASSTABLE
					user.visible_message("<span class='bname'>[user]</span> climbs onto [src]")
					playsound(user.loc, 'sound/effects/ontable.ogg', 100, 0)
					tableclimber = null
					return 1
			tableclimber = null
	return 0


/obj/structure/rack/lwtable/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = W
		if(G.state == 2 && G.assailant.zone_sel.selecting == "head")
			if(ishuman(G.affecting))
				G.affecting.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been smashed on a table by [G.assailant.name] ([G.assailant.ckey])</font>")
				G.assailant.attack_log += text("\[[time_stamp()]\] <font color='red'>Smashed [G.affecting.name] ([G.affecting.ckey]) on a table.</font>")

				//log_admin("ATTACK: [G.assailant] ([G.assailant.ckey]) smashed [G.affecting] ([G.affecting.ckey]) on a table.", 2)
				message_admins("ATTACK: [G.assailant] ([G.assailant.ckey])(<A HREF='?_src_=holder;adminplayerobservejump=\ref[G]'>JMP</A>) smashed [G.affecting] ([G.affecting.ckey]) on a table.", 2)
				log_attack("[G.assailant] ([G.assailant.ckey]) smashed [G.affecting] ([G.affecting.ckey]) on a table.")

				var/mob/living/carbon/human/H = G.affecting
				var/datum/organ/external/affecting = H.get_organ("head")
				if(prob(25))
					add_blood(G.affecting, 1) //Forced
					affecting.take_damage(rand(10,15), 0)
					H.Weaken(2)
					if(prob(20)) // One chance in 20 to DENT THE TABLE
						affecting.take_damage(rand(5,10), 0) //Extra damage
						G.assailant.visible_message("\red \The [G.assailant] smashes \the [H]'s head on \the [src] with enough force to further deform \the [src]!\nYou wish you could unhear that sound.",\
						"\red You smash \the [H]'s head on \the [src] with enough force to leave another dent!\n[prob(50)?"That was a satisfying noise." : "That sound will haunt your nightmares"]",\
						"\red You hear the nauseating crunch of bone and gristle on solid metal and the squeal of said metal deforming.")
					else if(prob(50))
						G.assailant.visible_message("\red [G.assailant] smashes \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] bone and cartilage making a loud crunch!",\
						"\red You smash \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] bone and cartilage making a loud crunch!",\
						"\red You hear the nauseating crunch of bone and gristle on solid metal, the noise echoing through the room.")
					else
						G.assailant.visible_message("\red [G.assailant] smashes \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] nose smashed and face bloodied!",\
						"\red You smash \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] nose smashed and face bloodied!",\
						"\red You hear the nauseating crunch of bone and gristle on solid metal and the gurgling gasp of someone who is trying to breathe through their own blood.")
				else
					affecting.take_damage(rand(5,10), 0)
					G.assailant.visible_message("\red [G.assailant] smashes \the [H]'s head on \the [src]!",\
					"\red You smash \the [H]'s head on \the [src]!",\
					"\red You hear the nauseating crunch of bone and gristle on solid metal.")
				H.UpdateDamageIcon()
				H.updatehealth()
				var/mob/living/carbon/human/AS = G.assailant
				AS.adjustStaminaLoss(rand(6,15))
				playsound(src.loc, pick('sound/effects/gore/smash1.ogg','sound/effects/gore/smash2.ogg','sound/effects/gore/smash3.ogg'), 50, 1, -3)
				qdel(W)
			return
		return

	if(isrobot(user))
		return

	if(istype(W, /obj/item/weapon/melee/energy/blade))
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, src.loc)
		spark_system.start()
		playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
		playsound(src.loc, "sparks", 50, 1)
		for(var/mob/O in viewers(user, 4))
			O.show_message("\blue The [src] was sliced apart by [user]!", 1, "\red You hear [src] coming apart.", 2)
		destroy()

	user.drop_item(src)
	return

/obj/structure/rack/lwtable/ex_act()
	new/obj/item/stack/sheet/wood(src.loc)
	new/obj/item/stack/sheet/wood(src.loc)
	qdel(src)

/obj/structure/rack/lwtable/table1
	icon_state = "table1"

/obj/structure/rack/lwtable/tablewitch
	icon_state = "witchtable"

/obj/structure/rack/lwtable/table2
	icon_state = "table2"

/obj/structure/rack/lwtable/tabledreamer
	icon_state = "TABLEDREAMER"

/obj/structure/rack/lwtable/table3
	icon_state = "table3"

/obj/structure/rack/lwtable/table4
	icon_state = "table4"

/obj/structure/rack/lwtable/table5
	icon_state = "table5"

/obj/structure/rack/lwtable/table6
	icon_state = "table6"

/obj/structure/rack/lwtable/table7
	icon_state = "table7"

/obj/structure/rack/lwtable/table8
	icon_state = "table8"

/obj/structure/rack/lwtable/table9_tablemiddle
	icon_state = "wood_middle"

/obj/structure/rack/lwtable/table9_table
	icon_state = "woodentable"

/obj/structure/rack/lwtable/table10thick
	icon_state = "wood_1tilethick"

/obj/structure/rack/lwtable/table10end
	icon_state = "wood_1tileendtable"

/obj/structure/rack/lwtable/reinftable
	icon_state = "reinf_table2"

/obj/structure/rack/lwtable/reinftable3
	icon_state = "reinf_table3"

//NEGRICE START

/obj/structure/rack/lwtable/barontable
	icon = 'icons/obj/baron_table.dmi'

/obj/structure/rack/lwtable/barontable/_1
	icon_state = "mesa1"

/obj/structure/rack/lwtable/barontable/_2
	icon_state = "mesa2"

/obj/structure/rack/lwtable/barontable/_3
	icon_state = "mesa3"

/obj/structure/rack/lwtable/techtable
	icon = 'icons/obj/techtable.dmi'

//NEGRICE END

/obj/structure/rack/lwtable/reinftable/horizontal
	icon_state = "table_horizontal2"

/obj/structure/rack/lwtable/reinftable/middle
	icon_state = "reinf_table4"

/obj/structure/rack/lwtable/reinftable/end
	icon_state = "reinf_table5"

/obj/structure/rack/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			qdel(src)
		if(3.0)
			qdel(src)

/obj/structure/rack/blob_act()
	if(prob(75))
		qdel(src)
		return
	else if(prob(50))
		qdel(src)
		return

/obj/structure/rack/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(src.density == 0) //Because broken racks -Agouri |TODO: SPRITE!|
		return 1
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0

/obj/structure/rack/MouseDrop_T(obj/O as obj, mob/user as mob)
	if ((!( istype(O, /obj/item/weapon) ) || user.get_active_hand() != O))
		return
	if(isrobot(user))
		return
	user.drop_item()
	if (O.loc != src.loc)
		step(O, get_dir(O, src))
	return

/obj/structure/rack/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/weapon/rack_parts( src.loc )
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		qdel(src)
		return
	if(isrobot(user))
		return
	user.drop_item()
	if(W && W.loc)	W.loc = src.loc
	return

/obj/structure/rack/meteorhit(obj/O as obj)
	qdel(src)


/obj/structure/rack/attack_hand(mob/user)
	if(HULK in user.mutations)
		visible_message("<span class='danger'>[user] smashes [src] apart!</span>")
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
		destroy()

/obj/structure/rack/attack_paw(mob/user)
	if(HULK in user.mutations)
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
		visible_message("<span class='danger'>[user] smashes [src] apart!</span>")
		destroy()

/obj/structure/rack/attack_animal(mob/living/simple_animal/user)
	if(user.wall_smash)
		visible_message("<span class='danger'>[user] smashes [src] apart!</span>")
		destroy()

/obj/structure/rack/attack_tk() // no telehulk sorry
	return