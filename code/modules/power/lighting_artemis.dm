// Light bult simples
/obj/machinery/light/small/artemis/basic
	name = "Uma lampada amarela."
	icon_state = "bulba1"
	base_state = "bulba"
	fitting = "bulb"
	brightness_range = 5
	brightness_power = 4
	brightness_color = "#dfebf0"
	desc = "A small lighting fixture."
	light_type = /obj/item/weapon/light/bulb

// Nao tem overlay

/obj/machinery/light/small/artemis/basic/New()
	..()
	color = brightness_color

/obj/machinery/light/small/artemis/basic/blue
	brightness_color = "#4169e1"

/obj/machinery/light/small/artemis/basic/green
	brightness_color = "#699c36"

/obj/machinery/light/small/artemis/basic/red
	brightness_color = "#6b3d3d"

/obj/machinery/light/small/artemis/basic/Add_LightOverlay()
	return 0

/obj/machinery/light/small/artemis/basic/Remove_LightOverlay()
	return 0

// Luz de tubo da OS13

/obj/machinery/light/small/artemis/tube/shinebright
	name = "Uma lampada de tubo."
	icon = 'icons/obj/lighting.dmi'
	base_state = "shinebright"// base description and icon_state
	icon_state = "shinebright"
	brightness_color = "#f5f3f2"
	brightness_range = 5
	brightness_power = 5

/obj/machinery/light/small/artemis/tube/shinebrighter
	name = "Uma lampada de tubo."
	icon = 'icons/obj/lighting.dmi'
	base_state = "shinebrighter"// base description and icon_state
	icon_state = "shinebrighter"
	brightness_color = "#f5f3f2"
	brightness_range = 5
	brightness_power = 5

/obj/machinery/light/small/artemis/tube
	name = "Uma lampada de tubo."
	icon = 'icons/obj/lighting.dmi'
	base_state = "artemistube"		// base description and icon_state
	icon_state = "artemistube1"
	brightness_color = "#e9f2f2"
	brightness_range = 5
	brightness_power = 5

/obj/machinery/light/small/artemis/tube/blue
	brightness_color = "#d6eef8"

/obj/machinery/light/small/artemis/tube/artemistubetube_ov
	icon_state = "artemistubetube_ov"
	layer = 5.1

/obj/machinery/light/small/artemis/tube/artemistubetube_ov/New()
	color = brightness_color

/obj/machinery/light/small/artemis/tube/artemistube_light
	icon_state = "artemistube-ov"
	layer = 5.1

/obj/machinery/light/small/artemis/tube/artemistube_light/New()
	color = brightness_color
	icon_state = pick("artemistube-ov", "artemistube_light3", "artemistube_light4", "artemistube_light")


/obj/machinery/light/small/artemis/tube/Add_LightOverlay()
	color = brightness_color
	overlays += /obj/machinery/light/small/artemis/tube/artemistubetube_ov
	overlays += /obj/machinery/light/small/artemis/tube/artemistube_light

/obj/machinery/light/small/artemis/tube/Remove_LightOverlay()
	color = initial(color)
	overlays -= /obj/machinery/light/small/artemis/tube/artemistubetube_ov
	overlays -= /obj/machinery/light/small/artemis/tube/artemistube_light