//porque isso tava no arquivo de bodypart
/obj/item/stack/teeth
	name = "teeth"
	singular_name = "tooth"
	w_class = 1
	force = 0
	throwforce = 0
	max_amount = 32
	gender = PLURAL
	desc = "Welp. Someone had their teeth knocked out."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "tooth1"
	maybecomeflesh = 1
	var/transform_after = TRUE

/obj/item/stack/teeth/New()
	..()
	icon_state = "tooth[rand(1, 4)]"
	pixel_x = rand(1,13)
	pixel_y = rand(1,13)
	if(transform_after)
		spawn(15)
			icon_state = "teeth[rand(1,3)]"

/obj/item/stack/teeth/human
	name = "human teeth"
	singular_name = "human tooth"

/obj/item/stack/teeth/generic //Used for species without unique teeth defined yet
	name = "teeth"

/obj/item/stack/teeth/human/golden
	name = "golden human teeth"
	singular_name = "golden human tooth"
	icon_state = "gold_teeth1"
	transform_after = FALSE

/obj/item/stack/teeth/human/golden/New()
	..()
	icon_state = "gold_teeth[rand(1, 2)]"
	update_icon()

/obj/item/stack/proc/zero_amount()//Teeth shit
	if(amount < 1)
		qdel(src)
		return 1
	return 0