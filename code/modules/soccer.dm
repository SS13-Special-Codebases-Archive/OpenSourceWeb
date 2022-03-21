/obj/structure/goal
	icon = 'icons/soccer.dmi'
	icon_state = "goal1"
	name = "Soccer Goal"
	desc = "GOOOL DE FIRETHORN!"
	density = 1
	anchored = 1
	var/goals = 0

/obj/structure/goal/one
	icon_state = "goal1"

/obj/structure/goal/two
	icon_state = "goal2"

/obj/structure/goal/three
	icon_state = "goal3"

/obj/structure/goal/New()
	if(dir == SOUTH)
		layer = MOB_LAYER+0.1

/obj/structure/goal/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	if(get_dir(loc, target) == dir) //Make sure looking at appropriate border
		if(air_group) return 0
		return !density
	else
		return 1

/obj/structure/goal/CheckExit(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	if(get_dir(loc, target) == dir) //Make sure looking at appropriate border
		if(air_group) return 0
		return !density
	else
		return 1

/mob/living/carbon/human/var/obj/item/weapon/soccerball/football = null

/obj/item/weapon/soccerball
	icon = 'icons/soccer.dmi'
	icon_state = "football0"
	name = "soccer ball"
	item_state = "football0"
	var/normalstate = "football0"
	var/bodystate = "football1"
	density = 0
	anchored = 0
	w_class = 1.0
	force = 0.0
	throwforce = 0.0
	throw_speed = 1
	layer = MOB_LAYER+0.1
	throw_range = 4
	flags = FPRINT | TABLEPASS | CONDUCT
	var/mob/living/carbon/human/owner = null
	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)

		owner = null
		user.drop_item()
		update_movement() //reset icon
		src.throw_at(target, throw_range, throw_speed, user)

/obj/item/weapon/soccerball/proc/update_movement()
	if (owner)
		src.dir = owner.dir
		src.forceMove(owner.loc)
		icon_state = bodystate
	else
		icon_state = normalstate
	return

/obj/item/weapon/soccerball/Crossed(mob/living/carbon/human/user)
	if(!ishuman(user))
		return ..()
	if (!owner && !user?.football)
		owner = user
		user?.football = src
		return
	else
		..()

/obj/item/weapon/soccerball/Bumped(mob/M)
	. = ..()
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if (!owner && !H.football)
		owner = H
		H.football = src
		src.update_movement()

