/*
 * Job related
 */

//Botonist
/obj/item/clothing/suit/apron
	name = "apron"
	desc = "A basic blue apron."
	icon_state = "apron"
	item_state = "apron"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	allowed = list (/obj/item/weapon/reagent_containers/spray/plantbgone,/obj/item/device/analyzer/plant_analyzer,/obj/item/seeds,/obj/item/weapon/reagent_containers/glass/fertilizer,/obj/item/weapon/minihoe)

//Captain

/obj/item/clothing/suit/minerapron
	name = "apron"
	desc = "A basic apron."
	icon_state = "miner"
	item_state = "miner"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/suit/armitage
	name = "armitage"
	icon_state = "armitage"
	item_state = "armitage"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/suit/inspector
	name = "inspector"
	icon_state = "inspector"
	item_state = "inspector"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/suit/baronessdress
	name = "Baroness Dress"
	desc = "A beautiful red dress."
	icon_state = "baroness"
	item_state = "baroness"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	fatmaywear = 1

/obj/item/clothing/suit/donor/slojanko/dress
	name = "Revealing Dress"
	desc = "A beautiful  dress."
	icon_state = "donor_slojanko_revealingdress"
	item_state = "donor_slojanko_revealingdress"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/suit/ladydress
	name = "Lady Vandenberg Dress"
	desc = "A beautiful green dress."
	icon_state = "ladyballat"
	item_state = "ladyballat"

/obj/item/clothing/suit/nundress
	name = "Nun Dress"
	desc = "A beautiful dress."
	icon_state = "nun"
	item_state = "nun"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/suit/maiddress
	name = "Maid Dress"
	desc = "A old maid dress."
	icon_state = "maid"
	item_state = "maid"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	fatmaywear = 1

/obj/item/clothing/suit/succdress
	name = "Successor Dress"
	desc = "A beautiful bright red dress."
	icon_state = "dress"
	item_state = "dress"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	fatmaywear = 1

/obj/item/clothing/suit/succdress/child
	name = "Successor Dress"
	desc = "A beautiful bright red dress."
	icon_state = "successordress"
	item_state = "successordress"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	child_exclusive = 1

/obj/item/clothing/suit/child_coldsuit
	name = "cold suit"
	icon_state = "yminer"
	item_state = "yminer"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	child_exclusive = 1


/obj/item/clothing/suit/captunic
	name = "captain's parade tunic"
	desc = "Worn by a Captain to show their class."
	icon_state = "captunic"
	item_state = "bio_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/meistercloak
	name = "duke's cloak"
	desc = "Worn by a Duke to show their class."
	icon_state = "meiscloak"
	item_state = "bio_suit"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/pusher
	name = "pusher's jacket"
	desc = "Smells like blood."
	icon_state = "pusher_closed"
	var/closed_icon = "pusher_closed"
	var/open_icon = "pusher_open"
	item_state = "bio_suit"
	body_parts_covered = UPPER_TORSO|ARMS
	var/closed = TRUE

/obj/item/clothing/suit/storage/fjacket
	name = "odd jacket"
	desc = "Smells like blood."
	icon_state = "fjacket"
	item_state = "fjacket"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/esculap
	name = "esculap garment"
	desc = ""
	icon_state = "esculap"
	item_state = "esculap"
	flags = FPRINT | TABLEPASS
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/storage/pusher/attackhand_right(mob/living/carbon/human/H)
	if(closed)
		closed = FALSE
		icon_state = open_icon
	else
		closed = TRUE
		icon_state = closed_icon
	playsound(src, 'zip.ogg', 50, 1)
	H.visible_message("<span class='notice'>[H] [closed ? "zips up" : "unzips"] \the [src].</span>")
	H.update_inv_wear_suit()
	update_icon()



/obj/item/clothing/suit/storage/vest/tribunal
	name = "ordinator's winter jacket"
	icon_state = "ordjacket"
	item_state = "bio_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	armor = list(melee = 20, bullet = 20, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	weight = 5
	storage_slots = 2

/obj/item/clothing/suit/storage/redjacket
	name = "red jacket"
	desc = "Smells like blood."
	icon_state = "redjacket"
	item_state = "bio_suit"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/baron
	name = "baron's garments"
	desc = "Worn by a Baron to show their class."
	icon_state = "baron"
	item_state = "bio_suit"
	body_parts_covered = UPPER_TORSO|ARMS
	fatmaywear = 1

/obj/item/clothing/suit/new_cut
	name = "mafiaman suit"
	desc = "Worn by a New Cut gang to show their class."
	icon_state = "new_cut"
	item_state = "bio_suit"
	body_parts_covered = UPPER_TORSO|ARMS
	fatmaywear = 1

/obj/item/clothing/suit/new_cut_alt
	name = "mafiaman suit"
	desc = "Worn by a New Cut gang to show their class."
	icon_state = "new_cut_alt"
	item_state = "bio_suit"
	body_parts_covered = UPPER_TORSO|ARMS
	fatmaywear = 1

/obj/item/clothing/suit/new_cut_alt2
	name = "mafiaman suit"
	desc = "Worn by a New Cut gang to show their class."
	icon_state = "new_cut_alt2"
	item_state = "bio_suit"
	body_parts_covered = UPPER_TORSO|ARMS
	fatmaywear = 1

/obj/item/clothing/suit/lordking
	name = "baron's garments"
	desc = "Worn by a Baron to show their class."
	icon_state = "lord"
	item_state = "bio_suit"
	body_parts_covered = UPPER_TORSO|ARMS
	fatmaywear = 1

/obj/item/clothing/suit/furcoat
	name = "fur coat"
	desc = "The casual traveller outfit."
	icon_state = "furcoat"
	item_state = "bio_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/military_jackey
	name = "ravencoat"
	desc = "The casual traveller outfit."
	icon_state = "military_jacket"
	item_state = "bio_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/meister
	name = "meister's garment"
	desc = "Worn by a meister."
	icon_state = "meister"
	item_state = "bio_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	fatmaywear = 1

/obj/item/clothing/suit/misero
	name = "misero's coat"
	desc = "Dirty rags worn by miseros."
	icon_state = "misero"
	item_state = "bio_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/captunic/capjacket
	name = "captain's uniform jacket"
	desc = "A less formal jacket for everyday captain use."
	icon_state = "capjacket"
	item_state = "bio_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/trader
	name = "trader garment"
	desc = "An old, tattered coat and dirty pants from a traveller."
	icon_state = "trader"
	item_state = "trader"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

//Chaplain
/obj/item/clothing/suit/chaplain_hoodie
	name = "priest garments"
	desc = "This suit says to you 'hush'!"
	icon_state = "chaplain_hoodie"
	item_state = "chaplain_hoodie"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/vampirehunter
	name = "Vampire hunter garments"
	desc = "This suit says to you 'hush'!"
	icon_state = "arbiter"
	item_state = "arbiter"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

//Chaplain
/obj/item/clothing/suit/nun
	name = "nun robe"
	icon_state = "nun"
	item_state = "nun"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS
	flags_inv = HIDEJUMPSUIT

//Chef
/obj/item/clothing/suit/chef
	name = "Innkeeper's garment"
	desc = "An apron used by a high class chef."
	icon_state = "chef"
	item_state = "chef"
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list (/obj/item/weapon/kitchenknife,/obj/item/weapon/butch)

/obj/item/clothing/suit/chef/wife
	name = "Innkeeper's wife garment"
	desc = "An apron used by a high class chef."
	icon_state = "inndress"
	item_state = "inndress"
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50

//Chef
/obj/item/clothing/suit/chef/classic
	name = "A classic chef's apron."
	desc = "A basic, dull, white chef's apron."
	icon_state = "apronchef"
	item_state = "apronchef"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/suit/hunter
	name = "Hunter coat"
	desc = "A coat donned by some of the most elusive fanatics."
	icon_state = "huntercoat"
	item_state = "huntercoat"
	armor = list(melee = 20, bullet = 30, laser = 0, energy = 10, bomb = 15, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS

/obj/item/clothing/suit/chef/butler
	name = "butler jacket"
	desc = "A basic, dull, gery butler's jacket."
	icon_state = "butler"
	item_state = "butler"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

//Detective
/obj/item/clothing/suit/storage/det_suit
	name = "coat"
	desc = "An 18th-century multi-purpose trenchcoat. Someone who wears this means serious business."
	icon_state = "detective"
	item_state = "det_suit"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/weapon/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/weapon/gun/energy,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter,/obj/item/device/detective_scanner,/obj/item/device/taperecorder)
	armor = list(melee = 50, bullet = 10, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/det_suit/black
	icon_state = "detective2"

//Forensics
/obj/item/clothing/suit/storage/forensics
	name = "jacket"
	desc = "A forensics technician jacket."
	item_state = "det_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list(/obj/item/weapon/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/weapon/gun/energy,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/device/detective_scanner,/obj/item/device/taperecorder)
	armor = list(melee = 10, bullet = 10, laser = 15, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/forensics/red
	name = "red jacket"
	desc = "A red forensics technician jacket."
	icon_state = "forensics_red"

/obj/item/clothing/suit/storage/forensics/blue
	name = "blue jacket"
	desc = "A blue forensics technician jacket."
	icon_state = "forensics_blue"

//Engineering
/obj/item/clothing/suit/storage/hazardvest
	name = "hazard vest"
	desc = "A high-visibility vest used in work zones."
	icon_state = "hazard"
	item_state = "hazard"
	blood_overlay_type = "armor"
	allowed = list (/obj/item/device/analyzer, /obj/item/device/flashlight, /obj/item/device/multitool, /obj/item/device/pipe_painter, /obj/item/device/radio, /obj/item/device/t_scanner, \
	/obj/item/weapon/crowbar, /obj/item/weapon/screwdriver, /obj/item/weapon/weldingtool, /obj/item/weapon/wirecutters, /obj/item/weapon/wrench, /obj/item/weapon/tank/emergency_oxygen)

//Lawyer
/obj/item/clothing/suit/storage/lawyer/bluejacket
	name = "Blue Suit Jacket"
	desc = "A snappy dress jacket."
	icon_state = "suitjacket_blue_open"
	item_state = "suitjacket_blue_open"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/lawyer/purpjacket
	name = "Purple Suit Jacket"
	desc = "A snappy dress jacket."
	icon_state = "suitjacket_purp"
	item_state = "suitjacket_purp"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS

//Internal Affairs
/obj/item/clothing/suit/storage/internalaffairs
	name = "Patriarch's coat"
	desc = "A smooth and long jacket."
	icon_state = "patriarch"
	item_state = "patriarch"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS

//Medical
/obj/item/clothing/suit/storage/fr_jacket
	name = "first responder jacket"
	desc = "A high-visibility jacket worn by medical first responders."
	icon_state = "fr_jacket_open"
	item_state = "fr_jacket"
	blood_overlay_type = "armor"
	allowed = list(/obj/item/stack/medical, /obj/item/weapon/reagent_containers/dropper, /obj/item/weapon/reagent_containers/hypospray, /obj/item/weapon/reagent_containers/syringe, \
	/obj/item/device/healthanalyzer, /obj/item/device/flashlight, /obj/item/device/radio, /obj/item/weapon/tank/emergency_oxygen)

	verb/toggle()
		set name = "Toggle Jacket Buttons"
		set category = "Object"
		set src in usr

		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		switch(icon_state)
			if("fr_jacket_open")
				src.icon_state = "fr_jacket"
				usr << "You button up the jacket."
			if("fr_jacket")
				src.icon_state = "fr_jacket_open"
				usr << "You unbutton the jacket."
		usr.update_inv_wear_suit()	//so our overlays update

//Mime
/obj/item/clothing/suit/suspenders
	name = "suspenders"
	desc = "They suspend the illusion of the mime's play."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "suspenders"
	blood_overlay_type = "armor" //it's the less thing that I can put here