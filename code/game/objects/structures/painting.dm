/obj/structure/easel
	name = "easel"
	desc = "an easel used on painting."
	icon = 'icons/obj/painting.dmi'
	icon_state = "easel"
	density = 1
	anchored = 0

/obj/item/sketch
	name = "sketch"
	desc = "a sketch"
	icon = 'icons/obj/painting.dmi'
	icon_state = "sketch"
	w_class = 1.0
	var/somethingDone = 0

/obj/item/sketch/New()
	..()
	overlays += image(icon=src.icon, icon_state="shade")

/obj/item/sketch/RightClick(mob/user as mob)
	if(somethingDone)
		switch(alert("Do you wish to complete the painting?", "Painting", "Yes", "No"))
			if("Yes")
				var/inputo = sanitize(input(user, "What will be its name?", "Name") as text)
				src.name = inputo
				user.visible_message("<span class='passivebold'>[user]</span><span class='passive'> finishes off the [src]!</span>")
				src.item_worth = rand(1, 20)
				if(user?:special == "mayartist")
					if(prob(60))
						src.item_worth = rand(70, 320)
			if("No")
				return

/obj/item/brush
	name = "brush"
	desc = "a brush"
	icon = 'icons/obj/painting.dmi'
	icon_state = "brush1"
	item_state = "brush"
	w_class = 1.0
	var/cor = "#000000"
	var/brush_size = 1

/obj/item/brush/medium
	icon_state = "brush2"
	brush_size = 2

/obj/item/brush/big
	icon_state = "brush3"
	brush_size = 4

/obj/item/brush/update_icon()
	var/image/I = image(icon=src.icon, icon_state="o[src.icon_state]")
	I.color = cor
	overlays.Cut()
	overlays.Add(I)

/obj/item/palette
	name = "palette"
	desc = "a palette"
	icon = 'icons/obj/painting.dmi'
	icon_state = "palette"
	w_class = 1.0

/obj/item/palette/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/brush))
		var/obj/item/brush/B = W
		B.cor = input(user, "Please select a main color.", "Brush") as color|null
		B.update_icon()

/obj/structure/easel/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/sketch))
		user.drop_from_inventory(W)
		W.pixel_x = 0
		W.pixel_y = 0
		W.loc = src.loc

/obj/item/sketch/Click(location, control, params)
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		if(istype(H.get_active_hand(), /obj/item/brush))
			var/list/P = params2list(params)
			var/icon_x = text2num(P["icon-x"])
			var/icon_y = text2num(P["icon-y"])
			if(icon_y > 24) return
			if(icon_y < 7) return
			if(icon_x > 29) return
			if(icon_x < 4) return
			var/obj/item/brush/B = H.get_active_hand()
			somethingDone = 1
			if(B.brush_size == 1)
				var/image/pixel = image('icons/obj/painting.dmi', icon_state="white", layer=5)
				pixel.pixel_x = icon_x
				pixel.pixel_y = icon_y
				pixel.color = B.cor
				overlays += pixel
			if(B.brush_size == 2)
				var/image/pixel = image('icons/obj/painting.dmi', icon_state="white", layer=5)
				pixel.pixel_x = icon_x
				pixel.pixel_y = icon_y
				pixel.color = B.cor
				overlays += pixel
				var/image/pixel2 = image('icons/obj/painting.dmi', icon_state="white", layer=5)
				pixel2.pixel_x = icon_x+1
				pixel2.pixel_y = icon_y
				pixel2.color = B.cor
				overlays += pixel2
			if(B.brush_size == 4)
				var/image/pixel = image('icons/obj/painting.dmi', icon_state="white", layer=5)
				pixel.pixel_x = icon_x
				pixel.pixel_y = icon_y
				pixel.color = B.cor
				overlays += pixel
				var/image/pixel2 = image('icons/obj/painting.dmi', icon_state="white", layer=5)
				pixel2.pixel_x = icon_x+1
				pixel2.pixel_y = icon_y
				pixel2.color = B.cor
				overlays += pixel2
				var/image/pixel3 = image('icons/obj/painting.dmi', icon_state="white", layer=5)
				pixel3.pixel_x = icon_x
				pixel3.pixel_y = icon_y-1
				pixel3.color = B.cor
				overlays += pixel3
				var/image/pixel4 = image('icons/obj/painting.dmi', icon_state="white", layer=5)
				pixel4.pixel_x = icon_x+1
				pixel4.pixel_y = icon_y-1
				pixel4.color = B.cor
				overlays += pixel4
		else
			..()