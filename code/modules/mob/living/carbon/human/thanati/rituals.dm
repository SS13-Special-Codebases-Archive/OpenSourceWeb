
/obj/effect/decal/cleanable/thanati
	name = "sigils"
	desc = "Strange runics, symbols draw with unknown materials."
	icon = 'icons/obj/sigils.dmi'
	layer = 2.1
	anchored = 1

/obj/effect/decal/cleanable/thanati/N
	icon_state = "sideN"

/obj/effect/decal/cleanable/thanati/NE
	icon_state = "sideNE"

/obj/effect/decal/cleanable/thanati/E
	icon_state = "sideE"

/obj/effect/decal/cleanable/thanati/SE
	icon_state = "sideSE"

/obj/effect/decal/cleanable/thanati/S
	icon_state = "sideS"

/obj/effect/decal/cleanable/thanati/SW
	icon_state = "sideSW"

/obj/effect/decal/cleanable/thanati/W
	icon_state = "sideW"

/obj/effect/decal/cleanable/thanati/NW
	icon_state = "sideNW"

/obj/effect/decal/cleanable/thanati/C
	icon_state = "center"

proc/isRitualPlace(var/turf/place)
	for(var/obj/effect/decal/cleanable/thanati/T in place.contents)
		var/turf/reference = place
		switch(T.type)
			if(/obj/effect/decal/cleanable/thanati/C)
				reference = place
			if(/obj/effect/decal/cleanable/thanati/N)
				reference = get_step(reference, SOUTH)
			if(/obj/effect/decal/cleanable/thanati/NE)
				reference = get_step(reference, SOUTHWEST)
			if(/obj/effect/decal/cleanable/thanati/E)
				reference = get_step(reference, WEST)
			if(/obj/effect/decal/cleanable/thanati/S)
				reference = get_step(reference, NORTH)
			if(/obj/effect/decal/cleanable/thanati/SW)
				reference = get_step(reference, NORTHEAST)
			if(/obj/effect/decal/cleanable/thanati/SE)
				reference = get_step(reference, NORTHWEST)
			if(/obj/effect/decal/cleanable/thanati/W)
				reference = get_step(reference, EAST)
			if(/obj/effect/decal/cleanable/thanati/NW)
				reference = get_step(reference, SOUTHEAST)

		var/list/sigils = list()
		for(var/direction in alldirs)
			for(var/obj/effect/decal/cleanable/thanati/T1 in reference.contents)
				sigils += T1
				break

		if(alldirs.len == sigils.len)
			return reference
	return

proc/debug(var/text, var/mob/living/carbon/human/H,)
	H.my_stats.st += 2
	H.updatePig()

//N = NORTH
//NE = NORTHEAST
//E = EAST
//SE = SOUTHEAST
//S = SOUTH
//SW = SOUTHWEST
//W = WEST
//NW = NORTHWEST
//C = CENTER

var/global/list/thanatiRitual = list(
list(
list(
/obj/item/weapon/flame/candle, //NE
/obj/item/weapon/flame/candle, //E
/obj/item/weapon/flame/candle, //SE
0, //S
/obj/item/weapon/flame/candle, //SW
/obj/item/weapon/flame/candle, //W
0, //N
/obj/item/weapon/flame/candle, //NW
/obj/item/weapon/spacecash/c1), //C
cultistType = "Malice",
function = /proc/blackJudgment,
arguments = ""
),
list(
list(
/obj/item/weapon/organ/head, //NE
/mob/living/carbon/human, //E
/obj/item/weapon/organ/head, //SE
0, //S
/obj/item/weapon/organ/head, //SW
/mob/living/carbon/human, //W
/obj/item/weapon/reagent_containers/food/snacks/organ/liver, //N
/obj/item/weapon/organ/head, //NW
/mob/living/carbon/human), //C
cultistType = "Malice",
function = /proc/rage,
arguments = ""
),/* TODO: UNCOMMENT THIS WHEN JINXED IS READDED AND FIXED
list(
list(
0, //NE
0, //E
0, //SE
/obj/item/weapon/organ/, //S
0, //SW
0, //W
/obj/item/weapon/flame/candle, //N
0, //NW
0), //C
cultistType = "Malice",
function = /proc/jinxed,
arguments = ""
),*/
list(
list(
0, //NE
0, //E
0, //SE
0, //S
0, //SW
0, //W
0, //N
0, //NW
/mob/living/carbon/human), //C
cultistType = null,
function = /proc/convert,
arguments = ""
),
list(
list(
0, //NE
/obj/item/weapon/bone, //E
0, //SE
/obj/item/weapon/flame/candle, //S
0, //SW
/obj/item/weapon/bone, //W
/obj/item/weapon/bone, //N
0, //NW
/obj/item/weapon/reagent_containers/food/snacks/meat), //C
cultistType = null,
function = /proc/livingDead,
arguments = ""
),
list(
list(
/obj/item/weapon/shard, //NE
/obj/item/weapon/shard, //E
/obj/item/weapon/shard, //SE
/obj/item/weapon/shard, //S
/obj/item/weapon/shard, //SW
/obj/item/weapon/shard, //W
/obj/item/weapon/shard, //N
/obj/item/weapon/shard, //NW
/obj/item/weapon/photo), //C
cultistType = null,
function = /proc/loneliness,
arguments = ""
),
list(
list(
0, //NE
0, //E
0, //SE
0, //S
0, //SW
0, //W
0, //N
0, //NW
/obj/item/weapon/paper), //C
cultistType = null,
function = /proc/propaganda,
arguments = ""
),
list(
list(
0, //NE
0, //E
0, //SE
/obj/item/weapon/organ/l_foot, //S
0, //SW
0, //W
/obj/item/weapon/organ/r_foot, //N
0, //NW
/obj/item/weapon/photo), //C
cultistType = null,
function = /proc/thecall,
arguments = ""
),
list(
list(
0, //NE
/obj/item/weapon/reagent_containers/food/snacks/organ/brain, //E
0, //SE
/obj/item/weapon/reagent_containers/food/snacks/organ/brain, //S
0, //SW
/obj/item/weapon/reagent_containers/food/snacks/organ/brain, //W
/obj/item/weapon/reagent_containers/food/snacks/organ/brain, //N
0, //NW
/mob/living/carbon/human/monster), //C
cultistType = null,
function = /proc/becomeMonster,
arguments = ""
),
list(
list(
0, //NE
0, //E
0, //SE
/obj/item/weapon/flame/candle, //S
0, //SW
0, //W
/obj/item/weapon/flame/candle, //N
0, //NW
/obj/item/weapon/stone), //C
cultistType = null, // speech
function = /proc/grandGathering, // Grand Gathering
arguments = ""
),
list(
list(
/obj/item/tzchernobog, //NE
0, //E
/obj/item/tzchernobog, //SE
0, //S
/obj/item/tzchernobog, //SW
0, //W
0, //N
/obj/item/tzchernobog, //NW
/obj/item/clothing/suit/storage/thanati/thanati), //C
cultistType = null, // alteration
function = /proc/armorOfFaith, // Armor of Faith
arguments = ""
),
list(
list(
0, //NE
0, //E
0, //SE
0, //S
0, //SW
0, //W
/obj/item/tzchernobog, //N
0, //NW
/obj/item/weapon/photo), //C
cultistType = null, // traps
function = /proc/falseTarget, // False Target
arguments = ""
),

list(
list(
0, //NE
/obj/item/weapon/flame/candle, //E
0, //SE
/obj/item/weapon/flame/candle, //S
0, //SW
/obj/item/weapon/flame/candle, //W
/obj/item/weapon/flame/candle, //N
0, //NW
/mob/living/carbon/human), //C
cultistType = null, // traps
function = /proc/malignant, // False Target
arguments = ""
),

)
// /obj/item/weapon/shard
proc/ritual(var/turf/locc)
	var/list/L = list(
	get_step(locc, NORTHEAST),
	get_step(locc, EAST),
	get_step(locc, SOUTHEAST),
	get_step(locc, SOUTH),
	get_step(locc, SOUTHWEST),
	get_step(locc, WEST),
	get_step(locc, NORTH),
	get_step(locc, NORTHWEST),
	locc,
	)

	var/needed = 0
	var/resources = 0
	for(var/y = 1, y <= thanatiRitual.len, y++)
		needed = 0
		resources = 0
		for(var/x = 1, x <= L.len, x++)
			if(thanatiRitual[y][1][x] != 0)
				needed++
			for(var/atom/A in L[x].contents)
				if(thanatiRitual[y][1][x])
					if(istype(A, thanatiRitual[y][1][x]))
						resources++

		if(resources >= needed)
			call(thanatiRitual[y]["function"])(thanatiRitual[y]["arguments"], usr, locc)

/mob/living/carbon/human/say(var/message)
	if(replacetext(message, ".", "") in thanatiWords)
		get_corrupt()

		var/result = isRitualPlace(loc)
		if(result)
			ritual(result)
	..()

/mob/proc/addThanatiWord(var/text)
	thanatiWords += text
	for(var/x in thanatiWords)
		to_chat(world, "[x]")