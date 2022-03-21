var/obj/structure/stool/bed/chair/altar/lifewebChair

/obj/structure/stool/bed/chair/altar
	name = "lifeweb altar"
	icon = 'icons/obj/LW2.dmi'
	icon_state = "altar"
	desc = ""
	density = 0
	anchored = 1
	flammable = 0
	var/powerlevel = 0
	var/storeLib = 1
	var/storeMort = 1
	var/powerOutput = 0
	var/status = FALSE

	var/mob/living/carbon/human/Victim = null

/obj/structure/stool/bed/chair/altar/New()
	..()
	lifewebChair = src

/obj/structure/stool/bed/chair/altar/proc/LifewebChecks(mob/living/carbon/human/M as mob, mob/user as mob)
	if (!ticker)
		return

	if(M.species.name == "Skeleton")
		return

	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || M.buckled || istype(user, /mob/living/silicon/pai) )
		return

	if(istype(M.species, /datum/species/human/alien))
		return

	for(var/obj/O in M.contents)
		if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/organ))
			continue
		else if(istype(O, /obj/item/weapon/storage/touchable/organ))
			continue
		else
			to_chat(user, "The victim needs to be fully naked.")
			return

	if (M.isChild())
		to_chat(user, "How dumb am i?")
		return

	if (M == usr)
		to_chat(user, "I feel stupid.")
		return

	return 1

/obj/structure/stool/bed/chair/altar/manual_unbuckle(mob/user as mob)
	return

/obj/structure/stool/bed/chair/altar/buckle_mob(mob/living/carbon/human/M as mob, mob/user as mob)
	if(LifewebChecks(M, user))
		M.visible_message("<B>[M.name]</B> is locked on the [src]!")
		playsound(src.loc, pick('lw_sacrificed1.ogg','lw_sacrificed2.ogg','lw_sacrificed3.ogg','lw_sacrificed4.ogg'), 60, 0, -1)
	else
		return

	M.buckled = src
	M.loc = src.loc
	M.dir = src.dir
	buckled_mob = M
	M.update_canmove()

	src.add_fingerprint(user)

	if(M.special == "deathweb")
		visible_message("<span class='combatbold'><B>[M.name]</B> shakes uncontrollably as they are strapped to \the [src]!</span>")
		M.rotate_plane()
		M.emote("torturescream",1, null, 0)
		M.vessel.add_reagent("dob",50)

	M.lifeweb_locked = TRUE
	Victim = M

	M.add_lifewebchain()

	M.update_icons()
	M.update_body()