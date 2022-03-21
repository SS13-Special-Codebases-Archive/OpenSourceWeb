//trees
/obj/structure/flora/tree
	name = "tree"
	anchored = 1
	density = 1
	pixel_x = -16
	layer = 9

/obj/structure/flora/tree/pine
	name = "pine tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"

/obj/structure/flora/tree/pine/New()
	..()
	icon_state = "pine_[rand(1, 3)]"

/obj/structure/flora/tree/pine/xmas
	name = "xmas tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_c"

/obj/structure/flora/tree/pine/xmas/New()
	..()
	icon_state = "pine_c"

/obj/structure/flora/tree/dead
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_1"

/obj/structure/flora/tree/dead/New()
	..()
	icon_state = "tree_[rand(1, 6)]"


//grass
/obj/structure/flora/grass
	name = "grass"
	icon = 'icons/obj/flora/snowflora.dmi'
	anchored = 1

/obj/structure/flora/grass/brown
	icon_state = "snowgrass1bb"

/obj/structure/flora/grass/brown/New()
	..()
	icon_state = "snowgrass[rand(1, 3)]bb"


/obj/structure/flora/grass/green
	icon_state = "snowgrass1gb"

/obj/structure/flora/grass/green/New()
	..()
	icon_state = "snowgrass[rand(1, 3)]gb"

/obj/structure/flora/grass/both
	icon_state = "snowgrassall1"

/obj/structure/flora/grass/both/New()
	..()
	icon_state = "snowgrassall[rand(1, 3)]"


//bushes
/obj/structure/flora/bush
	name = "bush"
	icon = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowbush1"
	anchored = 1

/obj/structure/flora/bush/New()
	..()
	icon_state = "snowbush[rand(1, 6)]"

/obj/structure/flora/pottedplant
	name = "potted plant"
	icon = 'icons/obj/plants.dmi'
	icon_state = "plant-26"

/obj/structure/flora/pottedplant/goon
	name = "potted plant"
	icon_state = "gplant_1"
	anchored = 1
	layer = MOB_LAYER+0.1

/obj/structure/flora/pottedplant/goon/plant1
	icon_state = "gplant_1"

/obj/structure/flora/pottedplant/goon/plant2
	icon_state = "gplant_2"

/obj/structure/flora/pottedplant/goon/plant3
	icon_state = "gplant_3"

/obj/structure/flora/pottedplant/goon/plant4
	icon_state = "gplant_4"

/obj/structure/flora/pottedplant/goon/plant5
	icon_state = "gplant_5"

//newbushes

/obj/structure/flora/ausbushes
	name = "bush"
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"
	anchored = 1

/obj/structure/flora/ausbushes/New()
	..()
	icon_state = "firstbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/reedbush
	icon_state = "reedbush_1"

/obj/structure/flora/ausbushes/reedbush/New()
	..()
	icon_state = "reedbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/leafybush
	icon_state = "leafybush_1"

/obj/structure/flora/ausbushes/leafybush/New()
	..()
	icon_state = "leafybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/palebush
	icon_state = "palebush_1"

/obj/structure/flora/ausbushes/palebush/New()
	..()
	icon_state = "palebush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/stalkybush
	icon_state = "stalkybush_1"

/obj/structure/flora/ausbushes/stalkybush/New()
	..()
	icon_state = "stalkybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/grassybush
	icon_state = "grassybush_1"

/obj/structure/flora/ausbushes/grassybush/New()
	..()
	icon_state = "grassybush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/fernybush
	icon_state = "fernybush_1"

/obj/structure/flora/ausbushes/fernybush/New()
	..()
	icon_state = "fernybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/sunnybush
	icon_state = "sunnybush_1"

/obj/structure/flora/ausbushes/sunnybush/New()
	..()
	icon_state = "sunnybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/genericbush
	icon_state = "genericbush_1"

/obj/structure/flora/ausbushes/genericbush/New()
	..()
	icon_state = "genericbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/pointybush
	icon_state = "pointybush_1"

/obj/structure/flora/ausbushes/pointybush/New()
	..()
	icon_state = "pointybush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/lavendergrass
	icon_state = "lavendergrass_1"

/obj/structure/flora/ausbushes/lavendergrass/New()
	..()
	icon_state = "lavendergrass_[rand(1, 4)]"

/obj/structure/flora/ausbushes/ywflowers
	icon_state = "ywflowers_1"

/obj/structure/flora/ausbushes/ywflowers/New()
	..()
	icon_state = "ywflowers_[rand(1, 3)]"

/obj/structure/flora/ausbushes/brflowers
	icon_state = "brflowers_1"

/obj/structure/flora/ausbushes/brflowers/New()
	..()
	icon_state = "brflowers_[rand(1, 3)]"

/obj/structure/flora/ausbushes/ppflowers
	icon_state = "ppflowers_1"

/obj/structure/flora/ausbushes/ppflowers/New()
	..()
	icon_state = "ppflowers_[rand(1, 4)]"

/obj/structure/flora/ausbushes/sparsegrass
	icon_state = "sparsegrass_1"

/obj/structure/flora/ausbushes/sparsegrass/New()
	..()
	icon_state = "sparsegrass_[rand(1, 3)]"

/obj/structure/flora/ausbushes/fullgrass
	icon_state = "fullgrass_1"

/obj/structure/flora/ausbushes/fullgrass/New()
	..()
	icon_state = "fullgrass_[rand(1, 3)]"

/obj/structure/flora/kirbyplants
	name = "potted plant"
	icon = 'icons/obj/plants.dmi'
	icon_state = "plant-01"

/obj/structure/flora/kirbyplants/dead
	name = "RD's potted plant"
	desc = "A gift from the botanical staff, presented after the RD's reassignment. There's a tag on it that says \"Y'all come back now, y'hear?\"\nIt doesn't look very healthy..."
	icon_state = "plant-25"

/obj/structure/lifeweb/statue/flora
	name = "potted plant"
	desc = "I feel that this plant doesn't belong here."
	icon = 'icons/obj/miscobjs.dmi'
	layer = 5
	flammable = 1

/obj/structure/lifeweb/statue/flora/plant1
	icon_state = "plant"

/obj/structure/lifeweb/statue/flora/plant2
	icon_state = "plant3"

/obj/structure/lifeweb/mushroom
	name = "mushroom"
	desc = "Ah, a mushroom. Classic."
	icon = 'icons/mining.dmi'
	var/lm_max_bright = 2
	var/lm_inner_range = 1
	var/lm_outer_range = 2
	var/hitstaken = 0
	var/hitlimit = 20
	var/hascap = FALSE

/obj/structure/lifeweb/mushroom/attackby(obj/item/weapon/W as obj, mob/living/carbon/human/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(W, /obj/item/weapon/hatchet))
		if(hitstaken <= hitlimit)
			hitstaken += rand(2,6)
			user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
			src.sound2()
			W.damageSharp("SOFT")
			playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 25, 1, -1)
			return
		else
			new /obj/item/stack/sheet/wood(loc, rand(1,4))
			src.sound2()
			W.damageSharp("SOFT")
			user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
			playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 34, 1, -1)
			qdel(src)
			return
	else if(istype(W, /obj/item/weapon/shovel))
		if(hitstaken <= hitlimit)
			hitstaken += rand(2,6)
			user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
			src.sound2()
			W.damageSharp("SOFT")
			playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 25, 1, -1)
		else
			new /obj/item/stack/sheet/wood(loc, rand(1,4))
			src.sound2()
			W.damageSharp("SOFT")
			user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
			playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 34, 1, -1)
			qdel(src)
	else if(istype(W, /obj/item/weapon))
		if(W.sharp)
			if(hitstaken <= hitlimit)
				hitstaken += rand(1,3)
				src.sound2()
				W.damageSharp("MEDIUM")
				user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
				playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 25, 1, -1)
			else
				new /obj/item/stack/sheet/wood(loc, rand(1,3))
				src.sound2()
				W.damageSharp("MEDIUM")
				user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
				playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 34, 1, -1)
				qdel(src)
		else
			W.damageItem("SOFT")
			user.show_message("<span class='notice'>You innefectively hit the [src]!</span>", 1)
			playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 5, 1, -1)

/obj/structure/lifeweb/mushroom/surface/New()
	icon_state = pick("icicles","lazurellus","sadshroom","sadshroom2","sadshroom3")
	..()
/obj/structure/lifeweb/mushroom/meatshroom1
	name = "meatshroom"
	icon_state = "meatshroom1"
	hascap = TRUE

/obj/structure/lifeweb/mushroom/meatshroom2
	name = "meatshroom"
	icon_state = "meatshroom2"
	hascap = TRUE

/obj/structure/lifeweb/mushroom/meatshroom3
	name = "meatshroom"
	icon_state = "meatshroom3"
	hascap = TRUE

/obj/structure/lifeweb/mushroom/poisonous1
	name = "poisonous mushroom"
	icon_state = "poisonous1"

/obj/structure/lifeweb/mushroom/poisonous2
	name = "poisonous mushroom"
	icon_state = "poisonous2"

/obj/structure/lifeweb/mushroom/dlolont2
	name = "dlolont"
	icon_state = "dlolont2"

/obj/structure/lifeweb/mushroom/redcap
	name = "redcap"
	icon_state = "redcap"

/obj/structure/lifeweb/mushroom/sadshroom1
	name = "shroom"
	icon_state = "shroomblink0"



/obj/structure/lifeweb/tallshroom_fallen
	name = "tallshroom"
	desc = "Ah, a mushroom. Classic."
	icon = 'icons/bigshroomnewflora.dmi'
	icon_state = "tall1"
	var/hitstaken = 0
	var/hitlimit = 40


/obj/structure/lifeweb/tallshroom_fallen/proc/Tallkify()
	var/matrix/M = matrix()
	M.Turn(90)
	M.Translate(5, -28)
	src.transform = M

/obj/structure/lifeweb/tallshroom_fallen/attackby(obj/item/weapon/W as obj, mob/living/carbon/human/user as mob)
	if(istype(W, /obj/item/weapon/hatchet))
		if(hitstaken <= hitlimit)
			hitstaken += rand(2,6)
			user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
			src.sound2()
			W.damageSharp("SOFT")
			playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 25, 1, -1)
			return
		else
			new /obj/item/stack/sheet/wood(loc, 6)
			new /obj/item/stack/sheet/wood(loc, rand(3,6))
			src.sound2()
			W.damageSharp("SOFT")
			user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
			playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 34, 1, -1)
			for(var/obj/structure/lifeweb/tallshroom_barrier/T in range(1,src))
				qdel(T)
			qdel(src)
			return
	else if(istype(W, /obj/item/weapon/shovel))
		if(hitstaken <= hitlimit)
			hitstaken += rand(2,6)
			user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
			src.sound2()
			W.damageSharp("SOFT")
			playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 25, 1, -1)
		else
			new /obj/item/stack/sheet/wood(loc, rand(1,4))
			src.sound2()
			W.damageSharp("SOFT")
			user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
			playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 34, 1, -1)
			qdel(src)
	else if(istype(W, /obj/item/weapon))
		if(W.sharp)
			if(hitstaken <= hitlimit)
				hitstaken += rand(1,3)
				src.sound2()
				W.damageSharp("MEDIUM")
				user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
				playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 25, 1, -1)
			else
				new /obj/item/stack/sheet/wood(loc, rand(1,3))
				src.sound2()
				W.damageSharp("MEDIUM")
				user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
				playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 34, 1, -1)
				qdel(src)
		else
			W.damageItem("SOFT")
			user.show_message("<span class='notice'>You innefectively hit the [src]!</span>", 1)
			playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 5, 1, -1)

/obj/structure/lifeweb/tallshroom
	name = "tallshroom"
	desc = "Ah, a mushroom. Classic."
	icon = 'icons/bigshroomnewflora.dmi'
	icon_state = "tall1"
	display_hiding = TRUE
	var/fall_state = "tall1"
	var/falling = FALSE
	var/hitstaken = 0
	var/hitlimit = 14

/obj/structure/lifeweb/tallshroom/New()
	..()
	icon_state = pick("tall1","tall2","tall3","tall4", "tall5", "tall6", "tall7")
	fall_state = icon_state

/obj/structure/lifeweb/tallshroom/attackby(obj/item/weapon/W as obj, mob/living/carbon/human/user as mob)
	if(falling)
		return
	if(istype(W, /obj/item/weapon/hatchet))
		if(hitstaken <= hitlimit)
			hitstaken += rand(2,6)
			user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
			src.sound2()
			W.damageSharp("SOFT")
			playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 25, 1, -1)
			animate(src, transform = turn(matrix(), rand(1,3)), time = 2, loop = 0)
			return
		else
			src.sound2()
			W.damageSharp("SOFT")
			user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
			playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 34, 1, -1)
			visible_message("<span class='bname'>[src]</span> begins to slowly [pick("detach","snap off")] from its roots and fall!")
			animate(src, transform = turn(matrix(), 2), time = 2, loop = 0)
			playsound(src.loc, 'shroomfall.ogg', 125, 0, 3)
			falling = TRUE
			spawn(30)
				animate(src, transform = turn(matrix(), 10), time = 18, loop = 0)
			spawn(50)
				for(var/mob/living/M in view(world.view, src))
					shake_camera(M, 2, 2)
				var/obj/structure/lifeweb/tallshroom_fallen/NG = new (src.loc)
				NG.name = src.name
				NG.desc = src.desc
				NG.icon = src.icon
				NG.icon_state = src.icon_state
				NG.Tallkify()
				var/newloc = get_step(src,EAST)
				new /obj/structure/lifeweb/tallshroom_barrier(newloc)
				for(var/mob/living/carbon/L in newloc)
					L.apply_damage(rand(45, 65), BRUTE, pick("head", "l_arm", "r_arm", "l_leg", "r_leg", "chest", "groin"))
					L.apply_damage(rand(50, 75), BRUTE, pick("l_foot", "l_leg"))
					L.apply_damage(rand(50, 75), BRUTE, pick("r_foot", "r_leg"))
					visible_message("<span class='combatbold'>[src]</span><span class='combat'>crushes [L]!</span>")
				qdel(src)
			return
	else if(istype(W, /obj/item/weapon))
		W.damageItem("SOFT")
		user.show_message("<span class='notice'>You innefectively hit the [src]!</span>", 1)
		to_chat(user, "<span class='combatbold'>[pick(nao_consigoen)]<span><span class='combat'> I can't cut this with \the [W],<i> only an sharp axe can do it!</i></span>")
		playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 5, 1, -1)
		return

/obj/structure/lifeweb/mushroom/sadshroom2
	name = "shroom"
	icon_state = "shroomblink1"

/obj/structure/lifeweb/mushroom/sadshroom3
	name = "shroom"
	icon_state = "shroomblink2"

/obj/structure/lifeweb/grass
	name = "grass"
	icon_state = "grass1"
	icon = 'icons/mining.dmi'
	flammable = 1
	density = 0
	layer = TURF_LAYER

/obj/structure/lifeweb/grass/attackby(obj/item/weapon/W as obj, mob/living/carbon/human/user as mob)
	if(W.sharp)
		if(prob(90))
			var/obj/item/weapon/handcuffs/fiber/NG = new (src.loc)
			NG.name = "fibers"
		if(prob(85))
			var/obj/item/weapon/handcuffs/fiber/GB = new (src.loc)
			GB.name = "fibers"
		if(prob(50))
			var/obj/item/weapon/handcuffs/fiber/GC = new (src.loc)
			GC.name = "fibers"
		src.sound2()
		visible_message("<span class='bname'>[user]</span> cuts [src].")
		playsound(src.loc, pick('PlantRustle_01.ogg','PlantRustle_02.ogg','PlantRustle_03.ogg','PlantRustle_04.ogg'),50, 1, -1)
		qdel(src)

/obj/structure/lifeweb/grass/New()
	..()
	icon_state = "grass[rand(1,15)]"

/obj/structure/lifeweb/grass/jungle
	name = "jungle grass"
	icon_state = "jungle"
	icon = 'icons/mining.dmi'
	flammable = 1
	density = 0
	layer = TURF_LAYER

/obj/structure/lifeweb/grass/jungle/New()
	..()
	icon_state = "jungle[rand(1,17)]"

/obj/structure/lifeweb/grass/glow
	name = "jungle grass"
	icon_state = "glow"
	icon = 'icons/mining.dmi'
	flammable = 1
	density = 0
	layer = TURF_LAYER

/obj/structure/lifeweb/grass/glow/New()
	..()
	lumosoviks_list += src
	icon_state = "glow[rand(1,5)]"

/obj/structure/lifeweb/grass/Crossed(mob/living/M as mob)
	if(isliving(M))
		playsound(src.loc, pick('PlantRustle_01.ogg','PlantRustle_02.ogg','PlantRustle_03.ogg','PlantRustle_04.ogg'),50, 1, -1)
		pixel_x += rand(-0.2,0.2)
		pixel_y += rand(-0.2,0.2)



/obj/structure/lifeweb/mushroom/glorbmushroom
	name = "lumosovik"
	icon = 'icons/mining.dmi'
	icon_state = "glorb"
	var/inicializado = 0
	density = 1
	cantpass = TRUE
	anchored = 1

/obj/structure/lifeweb/mushroom/glorbmushroom/New()
	..()
	lumosoviks_list += src


/obj/structure/lifeweb/mushroom/glorbmushroom/process()
	if(ticker.current_state == GAME_STATE_PLAYING && src.inicializado != TRUE)
		set_light(3, 3, 2.8, 1, "#9fede0")
		inicializado = TRUE
		processing_objects.Remove(src)


/obj/structure/lifeweb/mushroom/glorbmushroom/Bumped(AM)
	if(ishuman(AM))
		var/mob/living/carbon/H = AM
		src.sound2()
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		playsound(src.loc, pick('electr.ogg','electr1.ogg','electr2.ogg','electr3.ogg'), 100, 1)
		if(iszombie(H)) return
		if(H.species && H.species.flags & NO_PAIN) return
		H.electrocute_act(12, src, 1)
		step(H, pick(alldirs - get_dir(H, src)))
	..()

/obj/structure/lifeweb/mushroom/glorbmushroom/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/H = user
		src.sound2()
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		if(iszombie(src)) return
		if(H.species && H.species.flags & NO_PAIN) return
		H.electrocute_act(12, src, 1)
		step(H, pick(alldirs - get_dir(H, src)))
	..()

/obj/structure/lifeweb/mushroom/glorbmushroom/attackby(obj/item/weapon/W as obj, mob/living/carbon/human/user as mob)
	if(istype(W, /obj/item/weapon/hatchet))
		if(hitstaken <= hitlimit)
			hitstaken += rand(2,6)
			user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
			src.sound2()
			playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 25, 1, -1)
		else
			var/obj/structure/aibots/NG = new (src.loc)
			NG.name = "flying orb"
			src.sound2()
			user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
			playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 34, 1, -1)
			qdel(src)
	else if(istype(W, /obj/item/weapon/shovel))
		if(hitstaken <= hitlimit)
			hitstaken += rand(2,6)
			user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
			src.sound2()
			playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 25, 1, -1)
		else
			var/obj/structure/aibots/NG = new (src.loc)
			NG.name = "flying orb"
			src.sound2()
			user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
			playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 34, 1, -1)
			set_light(0)
			qdel(src)
	else if(istype(W, /obj/item/weapon))
		if(W.sharp)
			if(hitstaken <= hitlimit)
				hitstaken += rand(1,3)
				src.sound2()
				user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
				playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 25, 1, -1)
			else
				var/obj/structure/aibots/NG = new (src.loc)
				NG.name = "flying orb"
				src.sound2()
				user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
				playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 34, 1, -1)
				set_light(0)
				qdel(src)
		else
			user.show_message("<span class='notice'>You innefectively hit the [src]!</span>", 1)
			playsound(W.loc, pick('wood_chop_01.ogg','wood_chop_02.ogg','wood_chop_03.ogg','wood_chop_04.ogg'), 5, 1, -1)

/obj/structure/lifeweb/mushroom/sandshroom
	name = "sandshroom"
	icon = 'icons/mining.dmi'
	icon_state = "shroom1"
	density = 1
	anchored = 1
	cantpass = TRUE

/obj/structure/lifeweb/mushroom/sandshroom/New()
	//..()
	icon_state = "shroom[rand(1,2)]"

/obj/structure/lifeweb/mushroom/sandshroom/Bumped(AM)
	if(ishuman(AM))
		var/mob/living/carbon/H = AM
		H.emote("yawn")
		H.emote("hugs [src].")
		H.adjustStaminaLoss(rand(20,25))
		if(prob(70))
			H.adjustStaminaLoss(rand(8,15))
		else
			H.AdjustSleeping(10)
	..()

/obj/structure/lifeweb/mushroom/stinkshroom
	name = "stinkshroom"
	icon = 'icons/mining.dmi'
	icon_state = "stinkshroom2"
	desc = "A poisonous shroom, this one is already dead."
	density = 1
	anchored = 1
	var/stink = FALSE
	cantpass = TRUE

/obj/structure/lifeweb/mushroom/stinkshroom/examine()
	..()
	if(!stink)
		to_chat(usr, "<span class='passive'>it's dead.</span>")
	else
		to_chat(usr, "<span class='combat'>it's alive!</span>")

/obj/structure/lifeweb/mushroom/stinkshroom/New()
	//..()
	stink = pick(FALSE,TRUE)
	if(stink)
		icon_state = "stinkshroom2"
		desc = "A poisonous shroom, this one is still alive."
		cantpass = TRUE
	else
		icon_state = "stinkshroom1"
		desc = "A poisonous shroom, this one is already dead."
		cantpass = FALSE

/obj/structure/lifeweb/mushroom/stinkshroom/update_icon()
	//..()
	if(stink)
		icon_state = "stinkshroom2"
		desc = "A poisonous shroom, this one is still alive."
		cantpass = TRUE
	else
		icon_state = "stinkshroom1"
		desc = "A poisonous shroom, this one is already dead."
		cantpass = FALSE

/obj/structure/lifeweb/mushroom/stinkshroom/Bumped(AM)
	if(ishuman(AM) && stink)
		var/mob/living/carbon/H = AM
		src.stink = FALSE
		src.cantpass = FALSE
		src.update_icon()
		src.visible_message("<B>[src]</B> releases a strange gas!")
		for(var/mob/living/carbon/HH in range(src,2))
			if(prob(90))
				var/datum/reagents/reagents = new/datum/reagents(2)
				reagents.add_reagent(/datum/reagent/venom, 2)
				reagents.reaction(HH, INGEST)
				reagents.trans_to(HH, 2)
				if(prob(90))
					HH.emote("vomit")
		H.emote("hugs [src].")
		H.adjustStaminaLoss(rand(5,10))
		if(prob(90))
			H.emote("vomit")
	..()


/obj/structure/rack/lwtable/stone
	name = "stone"
	desc = ""
	icon = 'icons/mining.dmi'
	icon_state = "rock1"
	density = 1
	anchored = 1
	var/hitstaken = 0
	var/hitlimit = 15

/obj/structure/rack/lwtable/stone/attackby(obj/item/weapon/W as obj, mob/living/carbon/human/user as mob)
	if(user.a_intent != "hurt")
		return ..()

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(W, /obj/item/weapon/pickaxe))
		if(hitstaken <= hitlimit)
			hitstaken += rand(2,6)
			src.sound2()
			user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
			playsound(W.loc, pick('npc_human_pickaxe_01.ogg','npc_human_pickaxe_02.ogg','npc_human_pickaxe_03.ogg','npc_human_pickaxe_05.ogg'), 25, 1, -1)
		else
			var/amount = rand(1, 2)
			for(var/a = 0, a <= amount, a++)
				new /obj/item/weapon/stone(user.loc)
			src.sound2()
			user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
			playsound(W.loc, pick('npc_human_pickaxe_01.ogg','npc_human_pickaxe_02.ogg','npc_human_pickaxe_03.ogg','npc_human_pickaxe_05.ogg'), 25, 1, -1)
			qdel(src)
	else
		if(hitstaken <= hitlimit)
			hitstaken += rand(1,3)
			src.sound2()
			W.damageItem("SOFT")
			if(W.sharp)
				W.damageSharp("HARD")
			user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
			playsound(W.loc, pick('npc_human_pickaxe_01.ogg','npc_human_pickaxe_02.ogg','npc_human_pickaxe_03.ogg','npc_human_pickaxe_05.ogg'), 25, 1, -1)
		else
			var/amount = rand(1, 2)
			for(var/a = 0, a <= amount, a++)
				new /obj/item/weapon/stone(user.loc)
			src.sound2()
			W.damageItem("SOFT")
			if(W.sharp)
				W.damageSharp("HARD")
			user.show_message("<span class='notice'>You hit the [src]!</span>", 1)
			playsound(W.loc, pick('npc_human_pickaxe_01.ogg','npc_human_pickaxe_02.ogg','npc_human_pickaxe_03.ogg','npc_human_pickaxe_05.ogg'), 25, 1, -1)
			qdel(src)

/obj/structure/rack/lwtable/stone/s1
	icon_state = "rock1"

/obj/structure/rack/lwtable/stone/s2
	icon_state = "rock2"

/obj/structure/rack/lwtable/stone/s3
	icon_state = "rock3"

/obj/structure/rack/lwtable/stone/s4
	icon_state = "rock4"

/obj/structure/rack/lwtable/stone/s5
	icon_state = "rock5"

/obj/structure/rack/lwtable/stone/s6
	icon_state = "rock6"

/obj/structure/rack/lwtable/stone/s7
	icon_state = "rock7"

/obj/structure/rack/lwtable/stone/cavein
	icon_state = "boulder1"