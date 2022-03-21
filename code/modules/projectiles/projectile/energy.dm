/obj/item/projectile/energy
	name = "energy"
	icon_state = "spark"
	damage = 0
	damage_type = BURN
	flag = "energy"


/obj/item/projectile/energy/electrode
	name = "electrode"
	icon_state = "spark"
	nodamage = 0
	damage = 0
	damage_type = BURN
	pass_flags = PASSTABLE | PASSGRILLE
	lethal = 0
	agony = 46
	stutter = 10
	weaken = 0

/obj/item/projectile/energy/electrode2
	name = "stunshot"
	icon_state = "spark"
	nodamage = 0
	damage = 0
	damage_type = BURN
	stutter = 10
	weaken = 0
	agony = 0
	pass_flags = PASSTABLE | PASSGRILLE
	lethal = 0

	on_hit(var/atom/target, var/blocked = 0)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.electrocute_act(20, src, 1, 0, 1)
			H.emote("agonyscream",1, null, 0)
			H.Stun(3)
			H.Weaken(3)

/obj/item/projectile/energy/electrode3
	name = "stunshot"
	icon_state = "spark"
	nodamage = 0
	damage = 0
	damage_type = BURN
	stutter = 10
	weaken = 0
	agony = 0
	pass_flags = PASSTABLE | PASSGRILLE
	lethal = 0

	on_hit(var/atom/target, var/blocked = 0)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.electrocute_act(20, src, 1, 0, 1)
			H.emote("agonyscream",1, null, 0)
			H.Stun(2)
			H.Weaken(2)

/obj/item/projectile/energy/legax
	name = "heavy gravpulse"
	icon_state = "mag"
	nodamage = 0
	damage = 40
	damage_type = BRUTE
	stutter = 4

	on_hit(var/atom/target, var/blocked = 0, var/def_zone)
		if (..(target, blocked))
			var/mob/living/carbon/human/H = target
			var/datum/organ/external/E = H.organs_by_name[def_zone]
			E.fracture()

/obj/item/projectile/energy/legax/weak
	name = "weak gravpulse"
	icon_state = "mag"
	nodamage = 0
	damage = 20
	damage_type = BRUTE
	stutter = 4

/obj/item/projectile/energy/sparq
	name = "sparq"
	icon_state = "toybeam_red"
	nodamage = 0
	damage_type = BURN
	pass_flags = PASSTABLE | PASSGRILLE
	damage = 0
	stutter = 20
	agony = 100
	lethal = 0


/obj/item/projectile/energy/stunner
	name = "stunner"
	icon_state = "cbbolt"
	nodamage = 0
	damage_type = HALLOSS
	pass_flags = PASSTABLE | PASSGRILLE
	damage = 0
	stutter = 8
	agony = 0
	lethal = 0

	on_hit(var/atom/target, var/blocked = 0, var/def_zone)
		if(..(target,blocked))
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				var/datum/organ/external/E = H.organs_by_name[def_zone]
				E.cripple_ize(10)

// ���� ��� ��� �������� "���������" ����� �� ����� ����� ������ ���� �� ����� � ������� ������.

//	agony = 65
//	damage_type = HALLOSS
	//Damage will be handled on the MOB side, to prevent window shattering.

/obj/item/projectile/energy/laser
	name = "laser bolt"
	icon_state =  "laser2"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 60
	damage_type = BURN

	on_hit(var/atom/target, var/blocked = 0, var/def_zone)
		if(..(target,blocked))
			var/mob/living/carbon/human/H = target
			if(ishuman(target) && !isVampire(target))
				H.vessel.remove_reagent("blood",50)
			if(isVampire(target))
				H.vessel.remove_reagent("blood",150)
				H.Weaken(2)
				H.apply_damage(damage*2, BURN)
				H.flash_pain()
				H.rotate_plane(1)
				if(prob(50))
					H.emote("SCREECHES in pain!")
					playsound(H.loc, pick('sound/effects/vamphit1.ogg', 'sound/effects/vamphit2.ogg', 'sound/effects/vamphit3.ogg'), 75, 0, -1)
					if(!H.ExposedFang)
						playsound(H.loc, ('sound/effects/fangs1.ogg'), 50, 0, -1)
						H.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>exposes fangs!</span>")
						H.ExposedFang = TRUE
						H.update_body()
	process()

		..()



/obj/item/projectile/energy/declone
	name = "declone"
	icon_state = "declone"
	nodamage = 1
	damage_type = CLONE
	irradiate = 40


/obj/item/projectile/energy/dart
	name = "dart"
	icon_state = "toxin"
	damage = 15
	damage_type = TOX
	weaken = 7


/obj/item/projectile/energy/bolt
	name = "bolt"
	icon_state = "cbbolt"
	damage = 20
	damage_type = TOX
	nodamage = 0
	weaken = 10
	stutter = 10


/obj/item/projectile/energy/bolt/large
	name = "largebolt"
	damage = 40


/obj/item/projectile/energy/neurotoxin
	name = "neuro"
	icon_state = "neurotoxin"
	damage = 10
	damage_type = TOX
	weaken = 5



