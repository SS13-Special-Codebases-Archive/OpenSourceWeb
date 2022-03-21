/mob/living/carbon/human/proc/zoomMap(var/size = 1.5)
    winset(src, "mapwindow.map", "zoom=[size]")

/mob/living/carbon/human/monster/loge
	desc = "Whats that? Moving foreskin?!"
	maxHealth = 1000
	health = 1000
	item_worth = 300
	var/rangeFire = 4

	process()
		set background = 1

		if (stat == 2)
			return 0
		if(weakened || paralysis || handcuffed || !canmove)
			return 1


		if (!target)
			for (var/mob/living/carbon/human/C in orange(5, src.loc))
				var/dist = get_dist(src, C)

				if(!(C in view(src, viewrange)))
					dist += 3

				if (C.stat == 2 || istype(C, /mob/living/carbon/human/monster) || !can_see(src,C,viewrange) || C.consyte)
					continue
				if(C.stunned || C.paralysis || C.weakened)
					target = C
					break
				if(!prob(30))
					target = C

		// if we have found a target
		if(target)
			// change the target if there is another human that is closer

			if(target.y == y)
				var/dist = target.x - x

				if(dist < 0)
					dist = dist * -1

				if(dist <= 5)
					dir = get_dir(src, target)
					spitFire(rangeFire)
			if(target.x == x)
				var/dist = target.y - y

				if(dist < 0)
					dist = dist * -1

				if(dist <= 5)
					dir = get_dir(src, target)
					spitFire(rangeFire)

			for (var/mob/living/carbon/C in orange(2,src.loc))
				if (C.stat == 2 || istype(C, /mob/living/carbon/human/monster) || !can_see(src,C,viewrange))
					continue
				if(get_dist(src, target) >= get_dist(src, C) && prob(30))
					target = C
					break

			var/turf/infront = get_step(src, dir)
			if(target in infront.contents)
				var/turf/newPlace = get_step(src, target.dir)

				if(!newPlace.density && !istype(newPlace, /turf/simulated/floor/open))
					if(prob(71))
						step_to(src, newPlace)
			if(target in orange(5, loc))
				if(ishuman(target))
					var/mob/living/carbon/human/H = target

					if(H.stat == 2)
						target = null
				if(get_dist(src, target) > 3 && target.x != x && target.y != y)
					if(step_towards_3d(src,target))
						return 1
			else
				target = null
				return 1
		// if there is no target in range, roam randomly
		else
			if(stat == 2)
				return 0

			var/prev_loc = loc
			// make sure they don't walk into space
			if(!(locate(/turf/space) in get_step(src,dir)))
				step(src,dir)
			// if we couldn't move, pick a different direction
			// also change the direction at random sometimes
			if(loc == prev_loc || prob(20))
				sleep(5)
				dir = pick(NORTH,SOUTH,EAST,WEST)

			return 1

		// if we couldn't do anything, take a random step
		step_rand(src)
		dir = get_dir(src,target) // still face to the target

		return 1

/atom/proc/spitFire(var/range = 4)
	var/turf/turfFire = get_step(loc, dir)
	var/fireIntensity = 3

	for(var/x = 0; x < range; x++)
		new /obj/structure/fire(turfFire)
		turfFire = get_step(turfFire, dir)
		for(var/mob/living/carbon/human/H in turfFire.contents)
			if(ismonster(H))
				continue
			H.on_fire = 1
			H.bodytemperature = 1000
			H.update_fire()
			spawn(rand(4, 8))
				var/list/sound = list()

				sound = list('sound/voice/firescream_female1.ogg', 'sound/voice/firescream_female2.ogg')
				if(H.gender == "male")
					sound = list('sound/voice/firescream1.ogg', 'sound/voice/firescream2.ogg', 'sound/voice/firescream3.ogg')

				playsound(loc, pick(sound), 200, 1)

		sleep(1)
		if(fireIntensity - 1 == 1)
			continue

		fireIntensity--

/datum/species/loge
	name = "Loge"
	icobase = 'icons/monsters/loge.dmi'
	primitive = /mob/living/carbon/human/monster/loge
	minheightm = 200
	maxheightm = 240
	minheightf = 200
	maxheightf = 240

/mob/living/carbon/human/monster/loge/New()
	..()
	set_species("Loge")
	my_stats.st = rand(10, 12)
	my_stats.ht = rand(14, 15)
	my_stats.dx = rand(10, 12)

	src.zone_sel = new /obj/screen/zone_sel( null )
	potenzia = rand(12, 15)

	if(!mind)
		mind = new /datum/mind(src)

	spawn while(stat != 2 && bot)
		sleep(cycle_pause)
		src.process()