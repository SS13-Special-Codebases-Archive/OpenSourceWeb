/obj/item/watch
	name = "watch"
	desc = "A watch. It tells time"
	icon = 'icons/obj/personal.dmi'
	icon_state = "wristwatch"
	wrist_use = TRUE
	item_state = "watch"

/obj/item/watch/examine()
	..()
	to_chat(usr, "It's time to go.")