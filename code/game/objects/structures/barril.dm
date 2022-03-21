particles/fire
	width = 100
	height = 100
	count = 1000
	spawning = 1
	lifespan = 7
	fade = 0
	grow = -0.01
	velocity = list(0, 0)
	position = generator("circle", 0, 8, NORMAL_RAND)
	drift = generator("vector", list(0, -0.2), list(0, 0.2))
	gravity = list(0, 0.95)
	icon = 'icons/obj/particles.dmi'
	scale       =   generator("vector", list(0.3, 0.3), list(1,1), NORMAL_RAND)
	rotation    =   30
	spin        =   generator("num", -20, 20)
	color = "yellow"

/obj/structure/barril
	icon = 'icons/obj/structures.dmi'
	icon_state = "barril"
	density = 1
	anchored = 1

/obj/structure/barril/New()
	..()
	new/obj/fireeffects(src.loc)

/obj/fireeffects/New()
	..()
	mouse_opacity = 0
	var/particles/fire/F = new
	src.pixel_y = 12
	src.plane = 22
	src.filters += list(filter(type = "outline", size = 1, color = "#FF3300"), filter(type = "bloom", threshold = rgb(255, 128, 255), size = 6, offset = 4, alpha = 255))
	particles += F
	src.set_light(7, 5, "#FF3300")