/obj/item/var
	maybecomeflesh = 0

/obj/item/tzchernobog
	name = "tzchernobog's flesh"
	desc = "a flesh of tzchernobog"
	icon = 'icons/life/cult.dmi'
	icon_state = "corrupt"
	w_class = 1.0

/mob/living/carbon/human/proc/get_corrupt()
	if(istype(src.get_active_hand(), /obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/I = get_active_hand()

		qdel(I)
		src.put_in_active_hand(new/obj/item/tzchernobog)

/turf/simulated/floor/proc/generateSigils(var/mob/M)
	var/obj/effect/decal/cleanable/thanati/C/C = new(src)
	C.add_fingerprint(M)
	playsound(C, 'sigil_draw.ogg', 100)
	var/list/sigilsPath = list(
	/obj/effect/decal/cleanable/thanati/N,
	/obj/effect/decal/cleanable/thanati/S,
	/obj/effect/decal/cleanable/thanati/E,
	/obj/effect/decal/cleanable/thanati/W,
	/obj/effect/decal/cleanable/thanati/NE,
	/obj/effect/decal/cleanable/thanati/NW,
	/obj/effect/decal/cleanable/thanati/SE,
	/obj/effect/decal/cleanable/thanati/SW
	)

	for(var/i = 1; i <= alldirs.len; i++)
		var/turf/floor = get_step(src, alldirs[i])
		var/thanati = sigilsPath[i]

		if(do_after(M, 5))
			new thanati(floor)
			continue
		break

/turf/simulated/floor/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/tzchernobog))
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			var/obj/heart = H.get_active_hand()
			qdel(heart)
			generateSigils(H)
			playsound(src, 'sigil_draw.ogg', 100)