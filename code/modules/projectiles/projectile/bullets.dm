/obj/item/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	damage = 70
	damage_type = BRUTE
	nodamage = 0
	flag = "bullet"
	embed = 1
	stutter = 30
	agony = 40
	sharp = 1


	on_hit(var/atom/target, var/blocked = 0)
		if (..(target, blocked))
			var/mob/living/L = target
			shake_camera(L, 3, 2)

/obj/item/projectile/bullet/weakbullet
	damage = 25
	stun = 0
	//weaken = 2
	embed = 0

/obj/item/projectile/bullet/shotgun
	damage = 60
	stun = 0
	//weaken = 0
	agony = 40
	stutter = 20
	embed = 1

/obj/item/projectile/bullet/princess
	damage = 55
	stun = 0
	weaken = 0
	agony = 30
	stutter = 40
	embed = 0

/obj/item/projectile/bullet/midbullet
	damage = 65
	//weaken = 2
	stutter = 20
	agony = 30

/obj/item/projectile/bullet/midbullet2
	damage = 55
	//weaken = 1
	stutter = 20
	agony = 20
	icon_state = "bullet"

/obj/item/projectile/bullet/duelista
	damage = 65
	//weaken = 5
	stutter = 40
	agony = 50

/obj/item/projectile/bullet/suffocationbullet//How does this even work?
	name = "co bullet"
	damage = 20
	damage_type = OXY


/obj/item/projectile/bullet/cyanideround
	name = "poison bullet"
	damage = 40
	damage_type = TOX


/obj/item/projectile/bullet/burstbullet//I think this one needs something for the on hit
	name = "exploding bullet"
	damage = 20
	embed = 0
	edge = 1


/obj/item/projectile/bullet/stunshot
	name = "stunshot"
	damage = 5
	stun = 15
	weaken = 10
	stutter = 10
	embed = 0

/obj/item/projectile/bullet/rubber
	damage = 5
	stun = 0
	weaken = 0
	embed = 0
	lethal = 0

/obj/item/projectile/bullet/SW
	damage = 35
	stun = 15
	weaken = 15

/obj/item/projectile/bullet/a762
	damage = 25

/obj/item/projectile/bullet/fire
	damage = 25

/obj/item/projectile/bullet/a556
	damage = 70
	stun = 0
	weaken = 0
	stutter = 20
	embed = 1
	icon_state = "tracer"

/obj/item/projectile/bullet/beretta
	damage = 27

/obj/item/projectile/bullet/a45
	damage = 40