/obj/structure/pit
	name = "pit"
	desc = "I Better stay away from that thing."
	icon = 'icons/obj/pit.dmi'
	icon_state = "pit1"
	density = 0
	anchored = 1
	var/open = 1

/obj/structure/pit/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/shovel))
		var/obj/item/weapon/shovel/S = W
		if(S.contents.len) //has dirt
			if(src.open)
				user.visible_message("[user] starts filling the pit.")
				if(do_after(user, 10))
					playsound(src, 'sound/effects/empty_shovel.ogg', 50, 1)
					close(user)
					S.contents.Cut()
					W.update_icon()
					src.update_icon()
					return
		if(!S.contents.len && !src.open)
			user.visible_message("[user] starts opening the pit.")
			if(do_after(user, 10))
				playsound(src, 'sound/effects/dig_shovel.ogg', 50, 1)
				open()
				var/obj/item/weapon/ore/dirt/D = new(user.loc)
				S.contents += D
				D.loc = S
				W.update_icon()
				src.update_icon()
				return

	if(istype(W, /obj/item/weapon/kitchen/utensil/knife/dagger/wood_stake))
		var/obj/item/weapon/kitchen/utensil/knife/dagger/wood_stake/stake = W
		if(open)
			user.drop_from_inventory(stake)
			src.contents += stake
			src.update_icon()

	if (istype(W,/obj/item/stack/sheet/wood))
		if(locate(/obj/structure/gravemarker) in src.loc)
			to_chat(user, "<span class='notice'>There's already a grave marker here.</span>")
			return
		if(open)
			to_chat(user, "<span class='notice'>I can't put a gravemarker on a open pit.</span>")
			return
		if(do_after(user, 25))
			visible_message("<span class='notice'>[user] finishes the grave marker.</span>")
			var/obj/item/stack/sheet/wood/plank = W
			plank.use(1)
			new/obj/structure/gravemarker(src.loc)

	if(istype(W,/obj/item/weapon/pickaxe) && open)
		to_chat(user, "<span class='combatbold'>You hit [src]!</span>")
		playsound(user.loc, pick('npc_human_pickaxe_01.ogg','npc_human_pickaxe_02.ogg','npc_human_pickaxe_03.ogg','npc_human_pickaxe_05.ogg'), 25, 1, -1)
		if(src.z <= 1)
			to_chat(user, "<span class='bname'>TOO HARD!!!</span>")
			return
		var/below = locate(src.x, src.y, src.z-1)
		if(below)
			if(istype(below, /turf/simulated/wall) && !istype(below, /turf/simulated/wall/r_wall/cave))
				return
			if(istype(below, /turf/simulated/wall/r_wall/cave))
				new /turf/simulated/floor/lifeweb/stone/handmade(below)
				qdel(below)
				below = locate(src.x, src.y, src.z-1)
			var/obj/structure/lifeweb/stairs/cave/down/S1 = new(below)
			var/obj/structure/lifeweb/stairs/cave/S2 = new(src.loc)
			S1.dir = user.dir
			S1.find_stairs_where()
			S2.dir = user.dir
			S2.find_stairs_where()
			qdel(src)

/obj/structure/pit/three
	icon_state = "hole3"
	New()
		..()
		contents += new/obj/item/weapon/kitchen/utensil/knife/dagger/wood_stake
		contents += new/obj/item/weapon/kitchen/utensil/knife/dagger/wood_stake
		contents += new/obj/item/weapon/kitchen/utensil/knife/dagger/wood_stake
		update_icon()

/obj/structure/pit/attack_hand(mob/user as mob)
	if(src.contents.len)
		var/has_stakes = 0
		var/list/toPick = list()
		for(var/obj/item/weapon/kitchen/utensil/knife/dagger/wood_stake/W in src)
			has_stakes = 1
			toPick.Add(W)
		if(has_stakes)
			var/obj/item/weapon/kitchen/utensil/knife/dagger/wood_stake/stake = pick(toPick)
			contents -= stake
			stake.loc = src.loc
			user.put_in_active_hand(stake)
			update_icon()

/obj/structure/pit/Crossed(mob/living/carbon/human/M as mob|obj)
	if(isliving(M) && src.contents.len && !M.throwing && src.open)
		var/has_stakes = 0
		for(var/obj/item/weapon/kitchen/utensil/knife/dagger/wood_stake/W in src)
			has_stakes += 1
		if(has_stakes)
			M.emote("agonydeath")
			var/chosenOrgan = "l_leg"
			var/chosenOrgan2 = "r_leg"
			M.apply_damage(24*has_stakes	, BRUTE, chosenOrgan)
			M.apply_damage(24*has_stakes	, BRUTE, chosenOrgan2)
			playsound(src.loc, "stab", 100, 1)
			src:loc:add_blood(M)
			M.Weaken(2)

/obj/structure/pit/update_icon()
	icon_state = "pit[open]"
	if(locate(/obj/item/weapon/kitchen/utensil/knife/dagger/wood_stake/) in src)
		var/amount = 0
		for(var/obj/item/weapon/kitchen/utensil/knife/dagger/wood_stake/W in contents)
			amount++
		icon_state = "hole[min(3, amount)]"



/obj/structure/pit/proc/open()
	name = "pit"
	desc = "Watch your step, partner."
	open = 1
	for(var/atom/movable/A in src)
		A.forceMove(src.loc)
		if(ishuman(A))
			var/mob/living/carbon/human/H = A
			H.buried = FALSE
			manyburied -= 1
	update_icon()

/obj/structure/pit/proc/close(var/user)
	name = "mound"
	desc = "Some things are better left buried."
	open = 0
	for(var/atom/movable/A in src.loc)
		if(!A.anchored && A != user)
			A.forceMove(src)
			if(iscarbon(A))
				var/mob/living/carbon/H = A
				H.buried = TRUE
				manyburied += 1
				for(var/mob/dead/observer/O in player_list)
					if(O.key == H.old_key)
						O.abandon_mob()
	update_icon()

/obj/structure/pit/return_air()
	return open

/obj/structure/pit/proc/digout(mob/escapee)
	var/breakout_time = 1 //2 minutes by default

	if(open)
		return

	if(escapee.stat || escapee.restrained())
		return

	escapee.setClickCooldown(100)
	to_chat(escapee, "<span class='warning'>You start digging your way out of \the [src] (this will take about [breakout_time] minute\s)</span>")
	visible_message("<span class='danger'>Something is scratching its way out of \the [src]!</span>")

	for(var/i in 1 to (6*breakout_time * 2)) //minutes * 6 * 5seconds * 2
		playsound(src.loc, 'sound/weapons/bite.ogg', 100, 1)

		if(!do_after(escapee, 50))
			to_chat(escapee, "<span class='warning'>You have stopped digging.</span>")
			return
		if(open)
			return

		if(i == 6*breakout_time)
			to_chat(escapee, "<span class='warning'>Halfway there...</span>")

	to_chat(escapee, "<span class='warning'>You successfuly dig yourself out!</span>")
	visible_message("<span class='danger'>\the [escapee] emerges from \the [src]!</span>")
	playsound(src.loc, 'sound/effects/squelch1.ogg', 100, 1)
	open()

/obj/structure/pit/closed
	name = "mound"
	desc = "Some things are better left buried."
	open = 0

/obj/structure/pit/closed/New()
	. = ..()
	close()

//invisible until unearthed first
/obj/structure/pit/closed/hidden
	invisibility = INVISIBILITY_OBSERVER

/obj/structure/pit/closed/hidden/open()
	..()

//spoooky
/obj/structure/pit/closed/grave
	name = "grave"
	icon_state = "pit0"

/obj/structure/pit/closed/grave/New()
	var/obj/structure/gravemarker/random/R = new(src.loc)
	R.generate()
	. = ..()

/obj/structure/gravemarker
	name = "grave marker"
	desc = "You're not the first."
	icon = 'icons/obj/gravestone.dmi'
	icon_state = "wood"
	pixel_x = 15
	pixel_y = 8
	anchored = 1
	var/message = "Unknown."

/obj/structure/gravemarker/cross
	icon_state = "cross"

/obj/structure/gravemarker/examine()
	..()
	to_chat(usr,"It says: '[message]'")

/obj/structure/gravemarker/random/New()
	generate()
	. = ..()

/obj/structure/gravemarker/random/proc/generate()
	icon_state = pick("wood","cross")

	var/cur_year = text2num(time2text(world.timeofday, "YYYY"))+544
	var/born = cur_year - rand(5,150)
	var/died = max(cur_year - rand(0,70),born)

	message = "[born] - [died]."

/obj/structure/gravemarker/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/weapon/hatchet))
		visible_message("<span class = 'warning'>\The [user] starts hacking away at \the [src] with \the [W].</span>")
		if(!do_after(user, 30))
			visible_message("<span class = 'warning'>\The [user] hacks \the [src] apart.</span>")
			new /obj/item/stack/sheet/wood(src)
			qdel(src)
	if(istype(W,/obj/item/weapon/pen))
		var/msg = sanitize(input(user, "What should it say?", "Grave marker", message) as text|null)
		if(msg)
			message = msg
	if(istype(W,/obj/item/weapon/chisel))
		var/msg = sanitize(input(user, "What should it say?", "Grave marker", message) as text|null)
		if(msg)
			message = msg