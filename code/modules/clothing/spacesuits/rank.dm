/obj/item/clothing/head/helmet/space/engie
	name = "Engineering space helmet"
	icon_state = "spaceengie"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. This one is of orange color."
	item_state = "syndicate-helm-orange"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 5, bomb = 5, bio = 100, rad = 50)
	siemens_coefficient = 1

/obj/item/clothing/suit/space/engie
	name = "Engineering space suit"
	desc = "A suit that protects against low pressure environments. It is designed to be harder than a normal one."
	icon_state = "spaceengie"
	item_state = "syndicate-orange"
	siemens_coefficient = 1
	breach_threshold = 7
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 5, bomb = 0, bio = 100, rad = 50)

/obj/item/clothing/head/helmet/space/security
	name = "Security space helmet"
	icon_state = "ntsco"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. This one is of black color."
	item_state = "syndicate-helm-orange"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 5, bomb = 5, bio = 100, rad = 50)
	siemens_coefficient = 1

/obj/item/clothing/suit/space/security
	name = "Security space suit"
	desc = "A suit that protects against low pressure environments. It is designed to be harder than a normal one. This one is of black color, with letters \"NT Security\" on it's back."
	icon_state = "ntsco"
	item_state = "syndicate-helm-black"
	siemens_coefficient = 1
	breach_threshold = 7
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 5, bomb = 0, bio = 100, rad = 50)
