/obj/item/weapon/fragment
	name = "fragment"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "frag1"
	force = 1
	embed = 1
	sharp = 1
	throwforce = 35
	w_class = 1

/obj/item/weapon/fragment/New()
	icon_state = pick("frag1","frag2","frag3")
	..()

/obj/item/weapon/grenade/syndieminibomb
	desc = "A syndicate manufactured explosive used to sow destruction and chaos"
	name = "syndicate minibomb"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "syndicate"
	item_state = "flashbang"
	origin_tech = "materials=3;magnets=4;syndicate=4"
	var/deliveryamt = 1 // amount of type to deliver
	var/spawner_type = null

/obj/item/weapon/grenade/syndieminibomb/prime()
	explosion(src.loc,1,2,4)
	qdel(src)

/obj/item/weapon/grenade/syndieminibomb/frag
	desc = ""
	name = "Fragmentation grenade"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "frag"
	item_state = "flashbang"
	origin_tech = "materials=3;magnets=4;syndicate=4"
	deliveryamt = 30 // amount of type to deliver
	spawner_type = /obj/item/weapon/fragment

	prime()													// Prime now just handles the two loops that query for people in lockers and people who can see it.
		explosion(src.loc,0,0,3,0)
		if(spawner_type && deliveryamt)
			var/turf/T = get_turf(src)
			var/list/turfs = circleview(T, 4)
			for(var/i=1, i<=deliveryamt, i++)
				var/atom/movable/x = new spawner_type
				x.loc = T
				for(var/j = 1, j <= rand(3, 6), j++)
					var/atom/TARGET
					var/turf/TUR = pick(turfs)
					TARGET = TUR
					for(var/mob/living/carbon/human/H in oview(4,T))
						if(prob(75))
							TARGET = H
					x.throw_at(TARGET, 4,10)
		qdel(src)
		return

/obj/item/weapon/grenade/syndieminibomb/frag/fake
	prime()
		if(prob(10))
			playsound(src.loc, 'sound/effects/UEPA.ogg', 100, 1)
			explosion(src.loc,0,0,3,0)
			if(spawner_type && deliveryamt)
				var/turf/T = get_turf(src)
				var/list/turfs = circleview(T, 3)
				for(var/i=1, i<=deliveryamt, i++)
					var/atom/movable/x = new spawner_type
					x.loc = T
					for(var/j = 1, j <= rand(1, 3), j++)
						var/atom/TARGET
						var/turf/TUR = pick(turfs)
						TARGET = TUR
						for(var/mob/living/carbon/human/H in oview(3,T))
							if(prob(75))
								TARGET = H
						x.throw_at(TARGET, 3,10)
			qdel(src)
		else
			playsound(src.loc, 'sound/effects/ha_grenade.ogg', 90, 1)
			sleep(10)
			playsound(src.loc, 'sound/effects/party_horn.ogg', 60, 1)
			var/turf/T = get_turf(src)
			var/list/turfs = circleview(T, 3)
			for(var/turf/TT in turfs)
				if(TT.density) continue
				var/obj/effect/decal/cleanable/confetti/C = new
				C.loc = TT
			for(var/mob/living/carbon/human/M in hearers(9, src))
				if(M.job == "Jester") continue
				if(prob(20))
					M.add_event("gmyza",/datum/happiness_event/misc/jestbad)
				else
					M.add_event("jestercool",/datum/happiness_event/misc/jestgood)

/obj/item/weapon/grenade/syndieminibomb/frag/suicide
	desc = ""
	name = "Modified Fragmentation grenade"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "improvised"
	item_state = "flashbang"
	origin_tech = "materials=3;magnets=4;syndicate=4"

/obj/item/weapon/grenade/syndieminibomb/frag/suicide/prime()
	explosion(src.loc,0,0,6,6)
	qdel(src)