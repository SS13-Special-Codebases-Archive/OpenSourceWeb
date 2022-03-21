/obj/machinery/redlamp
	name = "red lamp"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "cryolight1"
	desc = ""
	var/brightness_on = 3
	density = 1
	anchored = 1
	var/on = TRUE

/obj/machinery/redlamp/proc/update()
	if(on)
		set_light(4, 2,"#d48379")
		icon_state = "cryolight1"
	else
		set_light(0, 0, null)
		icon_state = "cryolight0"

/obj/machinery/redlamp/New()
	if(on)
		set_light(4, 2,"#d48379")
		icon_state = "cryolight1"
	else
		set_light(0, 0,null)
		icon_state = "cryolight0"
	..()

/obj/machinery/redlamp/nightlight
	name = "blue lamp"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "nightlight1"

/obj/machinery/redlamp/nightlight/update()
	if(on)
		set_light(4, 2, "#4df9e2")
		icon_state = "nightlight1"
	else
		set_light(0, 0, null)
		icon_state = "nightlight0"

/obj/machinery/redlamp/nightlight/New()
	..()
	if(on)
		set_light(4, 2, "#4df9e2")
		icon_state = "nightlight1"
	else
		set_light(0, 0,null)
		icon_state = "nightlight0"



/obj/machinery/floodbutton
	name = "flood button"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "blight0"
	var/on = FALSE
	var/obj/machinery/floodlights/LIGHTS
	anchored = 1

/obj/machinery/floodbutton/New()
	..()
	if(!LIGHTS)
		for(var/obj/machinery/floodlights/F in range(2,src))
			LIGHTS = F


/obj/machinery/floodbutton/attack_hand(mob/user as mob)
	if(LIGHTS.on)
		playsound(src.loc, 'sound/effects/lightsoff.ogg', 75, 1)
		icon_state = "blight0"
		update()
	else
		playsound(src.loc, 'sound/effects/lightson.ogg', 75, 1)
		icon_state = "blight1"
		update()

/obj/machinery/floodbutton/proc/update()
	if(LIGHTS.on)
		LIGHTS.on = FALSE
		LIGHTS.update()
	else
		LIGHTS.on = TRUE
		LIGHTS.update()

/obj/machinery/floodlights
	name = "flood lights"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "proj0"
	desc = ""
	var/brightness_on = 3
	density = 0
	anchored = 1
	pixel_y = 32
	var/on = FALSE
	var/obj/effect/projlight/LIGHTO

/obj/machinery/floodlights/on
	on = TRUE

/obj/machinery/floodlights/on/New()
	icon_state = "blight1"
	update()

/obj/machinery/floodlights/New()
	..()
	var/obj/effect/projlight/NG = new (src.loc)
	LIGHTO = NG
	if(!on)
		LIGHTO.alpha = 0

/obj/effect/projlight
	name = "projlight"
	icon = 'icons/obj/lighting3.dmi'
	icon_state = ""
	layer = 21
	plane = 3
	pixel_x = -32
	pixel_y = 16
	density = FALSE
	anchored = TRUE
	mouse_opacity = FALSE

/obj/machinery/floodlights/proc/update()
	if(on)
		set_light(8, 6,"#d7faca")
		icon_state = "proj1"
		LIGHTO.alpha = 255
	else
		set_light(0, 0, null)
		icon_state = "proj0"
		LIGHTO.alpha = 0


/obj/machinery/wall_light
	name = "wall light"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "detail2"
	desc = ""
	density = 0
	anchored = 1

/obj/machinery/wall_light/New()
	set_light(3, 5,"#636363")
	..()


/obj/machinery/glowshroom
	name = "glowshroom"
	icon = 'icons/obj/glows.dmi'
	icon_state = "1"
	desc = ""
	var/brightness_on = 3
	density = 1
	anchored = 1

/obj/machinery/glowshroom/New()
	lumosoviks_list += src

/obj/machinery/lamppost
	name = "lamp post"
	icon = 'icons/obj/lighting2.dmi'
	icon_state = "stolb1"
	desc = ""
	density = 0
	anchored = 1
	var/on = TRUE
	pixel_y = 8

/obj/machinery/lamppost/proc/update()
	if(on)
		set_light(5, 7,"#fcf573")
		icon_state = "stolb1"
	else
		set_light(0, 0, null)
		icon_state = "stolb0"

/obj/machinery/lamppost/New()
	if(on)
		set_light(5, 7,"#fcf573")
		icon_state = "stolb1"
	else
		set_light(0, 0, null)
		icon_state = "stolb0"
	..()

/obj/machinery/lamppost/Crossed(AM)
	if(!istype(AM, /mob/living/carbon/human))
		return

	if(prob(3))
		var/mob/living/carbon/human/H = AM
		for(var/limbcheck in list(BP_L_FOOT,BP_R_FOOT))//But we need to see if we have legs.
			var/datum/organ/external/affecting = H.get_organ(limbcheck)
			if(affecting.status & ORGAN_DESTROYED)//Oh shit, we don't have have any legs, we can't jump.
				return
		var/chosenOrgan = pick("l_foot","r_foot")
		H.apply_damage(15	, BRUTE, chosenOrgan)
		to_chat(H, "<span class='combat'>You kick the lamp post!</span>")

/obj/machinery/soulbreaker_light
	name = "lamp"
	icon = 'sb_decor.dmi'
	icon_state = "lamp"
	desc = ""
	density = 1
	anchored = 1
	var/on = 1

/obj/machinery/soulbreaker_light/proc/update()
	if(on)
		set_light(4, 3,"#ff8629")
		icon_state = "lamp"
		new /obj/effect/soulbreaker_beam(src.loc)
	else
		set_light(0, 0, null)
		icon_state = "lamp"

/obj/machinery/soulbreaker_light/New()
	if(on)
		set_light(4, 3,"#ff8629")
		icon_state = "lamp"
		new /obj/effect/soulbreaker_beam(src.loc)
	else
		set_light(0, 0,null)
		icon_state = "lamp"
	..()

/obj/effect/soulbreaker_beam
	name = "soulbreaker light overlay"
	icon = 'sb_decor.dmi'
	icon_state = "lampo"
	plane = 0
	layer = 3
	density = FALSE
	anchored = TRUE
	alpha = 180
	mouse_opacity = FALSE

/obj/effect/soulbreaker_beam/New()
	filters = filter(type="drop_shadow","x"=0,"y"=0,"size"=15,"offset"=5,"color"="#F4DF82")
