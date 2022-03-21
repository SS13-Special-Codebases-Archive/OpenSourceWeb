/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the teleporter
 */
var/list/rings = list()

/obj/item/weapon/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	w_class = 1.0
	var/associated_account_number = 0
	var/gifted = null
	var/gift_in = null
	var/no_showing = FALSE

	var/list/files = list(  )

/obj/item/weapon/card/data
	name = "data disk"
	desc = "A disk of data."
	icon_state = "data"
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "card-id"

/obj/item/weapon/card/data/verb/label(t as text)
	set name = "Label Disk"
	set category = "Object"
	set src in usr

	if (t)
		src.name = text("data disk- '[]'", t)
	else
		src.name = "data disk"
	src.add_fingerprint(usr)
	return

/obj/item/weapon/card/data/clown
	name = "\proper the coordinates to clown planet"
	icon_state = "data"
	item_state = "card-id"
	layer = 3
	level = 2
	desc = "This card contains coordinates to the fabled Clown Planet. Handle with care."
	function = "teleporter"
	data = "Clown Land"

/*
 * ID CARDS
 */

/obj/item/weapon/card/emag_broken
	desc = "It's a card with a magnetic strip attached to some circuitry. It looks too busted to be used for anything but salvage."
	name = "broken cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = "magnets=2;syndicate=2"

/obj/item/weapon/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = "magnets=2;syndicate=2"
	var/uses = 10
	// List of devices that cost a use to emag.
	var/list/devices = list(
		/obj/item/robot_parts,
		/obj/item/weapon/storage/lockbox,
		/obj/item/weapon/storage/secure,
		/obj/item/weapon/circuitboard,
		/obj/item/device/eftpos,
		/obj/item/device/lightreplacer,
		/obj/item/device/taperecorder,
		/obj/item/device/hailer,
		/obj/item/device/megaphone,
		/obj/item/clothing/tie/holobadge,
		/obj/structure/closet/crate/secure,
		/obj/structure/closet/secure_closet,
		/obj/machinery/librarycomp,
		/obj/machinery/computer,
		/obj/machinery/power,


		//obj/machinery/zero_point_emitter,
		/obj/machinery/clonepod,
		/obj/machinery/deployable,
		/obj/machinery/door_control,
		/obj/machinery/porta_turret,
		/obj/machinery/shieldgen,
		/obj/machinery/turretid,
		/obj/machinery/vending,
		/obj/machinery/bot,
		/obj/machinery/door,
		/obj/machinery/telecomms,
		/obj/machinery/mecha_part_fabricator
		)


/obj/item/weapon/card/emag/afterattack(var/obj/item/weapon/O as obj, mob/user as mob)

	for(var/type in devices)
		if(istype(O,type))
			uses--
			break

	if(uses<1)
		user.visible_message("[src] fizzles and sparks - it seems it's been used once too often, and is now broken.")
		user.drop_item()
		var/obj/item/weapon/card/emag_broken/junk = new(user.loc)
		junk.add_fingerprint(user)
		qdel(src)
		return

	..()

/obj/item/weapon/card/id/proc/update_label(var/newname, var/newjob)
	if(newname || newjob)
		name = "[(!newname)	? "ring"	: "[newname]'s ring"][(!newjob) ? "" : " ([newjob])"]"
		return

	name = "[(!registered_name)	? "ring"	: "[registered_name]'s ring"][(!assignment) ? "" : " ([assignment])"]"


/obj/item/weapon/card/id
	name = "ring"
	desc = "A ring used to provide authority and determine access across the Fortress."
	icon_state = "id"
	item_state = "ring"
	var/list/access = list()
	var/mining_points = 0		//For redeeming at mining equipment lockers
	var/registered_name = "Unknown" // The name registered_name on the card
	slot_flags = SLOT_ID
	drop_sound = 'ring_drop.ogg'

	var/blood_type = "\[UNSET\]"
	var/dna_hash = "\[UNSET\]"
	var/fingerprint_hash = "\[UNSET\]"
	var/datum/ring_account/money_account
	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system
	var/assignment = null	//can be alt title or the actual job
	var/rank = null			//actual job
	var/dorm = 0		// determines if this ID has claimed a dorm already

/obj/item/weapon/card/id/New()
	..()
	spawn(30)
	rings.Add(src)
	if(istype(loc, /mob/living/carbon/human))
		blood_type = loc:dna:b_type
		dna_hash = loc:dna:unique_enzymes
		fingerprint_hash = md5(loc:dna:uni_identity)

/obj/item/weapon/card/id/attack_self(mob/user as mob)
	for(var/mob/O in viewers(user, null))
		O.show_message(text("[] shows you: \icon[] []: assignment: []", user, src, src.name, src.assignment), 1)

	src.add_fingerprint(user)
	return

/obj/item/weapon/card/id/GetAccess()
    if(riotreal && !riot_essential.Find(rank))
        return list()
    return access

/obj/item/weapon/card/id/GetID()
	return src

/obj/item/weapon/card/id/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()

/obj/item/weapon/card/id/proc/receivePayment(var/amount)
	money_account.add_money(amount)
	if(istype(loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = loc
		to_chat(H, "<span class='passivebold'>[amount]</span><span class='passive'> obols received in </span><span class='passivebold'>[src]</span>")

/obj/item/weapon/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	usr << text("\icon[] []: The current assignment on the card is [].", src, src.name, src.assignment)
	usr << "The blood type on the card is [blood_type]."
	usr << "The DNA hash on the card is [dna_hash]."
	usr << "The fingerprint hash on the card is [fingerprint_hash]."
	return

/obj/item/weapon/card/id/syndicate
	name = "agent card"
	access = list(access_maint_tunnels, access_syndicate, access_external_airlocks)
	origin_tech = "syndicate=3"
	var/registered_user=null

/obj/item/weapon/card/id/syndicate/New(mob/user as mob)
	..()
	if(!isnull(user)) // Runtime prevention on laggy starts or where users log out because of lag at round start.
		registered_name = ishuman(user) ? user.real_name : user.name
	else
		registered_name = "Agent Card"
	assignment = "Agent"
	name = "[registered_name]'s ID Card ([assignment])"

/obj/item/weapon/card/id/syndicate/afterattack(var/obj/item/weapon/O as obj, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(O, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/I = O
		src.access |= I.access
		if(istype(user, /mob/living) && user.mind)
			if(user.mind.special_role)
				usr << "\blue The card's microscanners activate as you pass it over the ID, copying its access."

/obj/item/weapon/card/id/syndicate/attack_self(mob/user as mob)
	if(!src.registered_name)
		//Stop giving the players unsanitized unputs! You are giving ways for players to intentionally crash clients! -Nodrak
		var t = reject_bad_name(input(user, "What name would you like to put on this card?", "Agent card name", ishuman(user) ? user.real_name : user.name))
		if(!t) //Same as mob/new_player/prefrences.dm
			alert("Invalid name.")
			return
		src.registered_name = t

		var u = copytext(sanitize(input(user, "What occupation would you like to put on this card?\nNote: This will not grant any access levels other than Maintenance.", "Agent card job assignment", "Agent")),1,MAX_MESSAGE_LEN)
		if(!u)
			alert("Invalid assignment.")
			src.registered_name = ""
			return
		src.assignment = u
		src.name = "[src.registered_name]'s ID Card ([src.assignment])"
		user << "\blue You successfully forge the ID card."
		registered_user = user
	else if(!registered_user || registered_user == user)

		if(!registered_user) registered_user = user  //

		switch(alert("Would you like to display the ID, or retitle it?","Choose.","Rename","Show"))
			if("Rename")
				var t = copytext(sanitize(input(user, "What name would you like to put on this card?", "Agent card name", ishuman(user) ? user.real_name : user.name)),1,26)
				if(!t || t == "Unknown" || t == "floor" || t == "wall" || t == "r-wall") //Same as mob/new_player/prefrences.dm
					alert("Invalid name.")
					return
				src.registered_name = t

				var u = copytext(sanitize(input(user, "What occupation would you like to put on this card?\nNote: This will not grant any access levels other than Maintenance.", "Agent card job assignment", "Unassigned")),1,MAX_MESSAGE_LEN)
				if(!u)
					alert("Invalid assignment.")
					return
				src.assignment = u
				src.name = "[src.registered_name]'s ID Card ([src.assignment])"
				user << "\blue You successfully forge the ID card."
				return
			if("Show")
				..()
	else
		..()



/obj/item/weapon/card/id/syndicate_command
	name = "syndicate ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	assignment = "Syndicate Overlord"
	access = list(access_syndicate, access_external_airlocks)

/obj/item/weapon/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Cent. Com."
	icon_state = "centcom"
	registered_name = "Central Command"
	assignment = "General"
	New()
		access = get_all_centcom_access()
		..()

/obj/item/weapon/card/id/gold
	name = "golden ring"
	icon_state = "gold"
	item_state = "gold_id"

/obj/item/weapon/card/id/sci
	name = "ring"
	icon_state = "id_sci"
	item_state = "card-id"

/obj/item/weapon/card/id/gene
	name = "ring"
	icon_state = "id_gene"
	item_state = "card-id"

/obj/item/weapon/card/id/chem
	name = "ring"
	icon_state = "id_chem"
	item_state = "card-id"

/obj/item/weapon/card/id/med
	name = "ring"
	icon_state = "id_med"
	item_state = "card-id"

/obj/item/weapon/card/id/sci
	name = "ring"
	icon_state = "id_sci"
	item_state = "card-id"

/obj/item/weapon/card/id/viro
	name = "ring"
	icon_state = "id_viro"
	item_state = "card-id"

/obj/item/weapon/card/id/heatlab
	name = "ring"
	icon_state = "id_heatlab"
	item_state = "card-id"

/obj/item/weapon/card/id/rd
	name = "ring"
	icon_state = "id_rd"
	item_state = "card-id"

/obj/item/weapon/card/id/cmo
	name = "ring"
	icon_state = "id_cmo"
	item_state = "card-id"

/obj/item/weapon/card/id/det
	name = "ring"
	icon_state = "id_det"
	item_state = "card-id"

/obj/item/weapon/card/id/sec
	name = "tiamat's ring"
	icon_state = "id_sec"
	item_state = "card-id"

/obj/item/weapon/card/id/hos
	name = "Marduk's ring"
	icon_state = "id_hos"
	item_state = "card-id"

/obj/item/weapon/card/id/hop
	name = "golden ring"
	icon_state = "id_hop"
	item_state = "card-id"

/obj/item/weapon/card/id/heir
	name = "heir's ring"
	icon_state = "id_heir"
	item_state = "card-id"

/obj/item/weapon/card/id/baroness
	name = "baroness's ring"
	icon_state = "id_baroness"
	item_state = "card-id"

/obj/item/weapon/card/id/migrant
	name = "ring"
	icon_state = "id_ce"
	item_state = "card-id"

/obj/item/weapon/card/id/jester
	name = "jester's ring"
	icon_state = "id_jester"
	item_state = "card-id"

/obj/item/weapon/card/id/church
	name = "church's ring"
	icon_state = "id_church"
	item_state = "card-id"

/obj/item/weapon/card/id/successor
	name = "successor's ring"
	icon_state = "id_successor"
	item_state = "card-id"

/obj/item/weapon/card/id/ce
	name = "ring"
	icon_state = "id_ce"
	item_state = "card-id"

/obj/item/weapon/card/id/engie
	name = "ring"
	icon_state = "id_engie"
	item_state = "card-id"

/obj/item/weapon/card/id/mortician
	name = "ring"
	icon_state = "id_engie"
	item_state = "card-id"
	color = "gray"

/obj/item/weapon/card/id/other
	name = "common ring"
	icon_state = "id_other"
	item_state = "card-id"

/obj/item/weapon/card/id/atmos
	name = "ring"
	icon_state = "id_atmos"
	item_state = "card-id"

/obj/item/weapon/card/id/qm
	name = "ring"
	icon_state = "id_qm"
	item_state = "card-id"

/obj/item/weapon/card/id/hydro
	name = "ring"
	icon_state = "id_hydro"
	item_state = "card-id"

/obj/item/weapon/card/id/chaplain
	name = "bishop's ring"
	icon_state = "id_chaplain"
	item_state = "card-id"

/obj/item/weapon/card/id/churchkeeper
	name = "ring"
	icon_state = "id_church"
	item_state = "card-id"

/obj/item/weapon/card/id/black
	name = "ring"
	icon_state = "id_black"
	item_state = "card-id"

/obj/item/weapon/card/id/dkgrey
	name = "ring"
	icon_state = "id_dkgrey"
	item_state = "card-id"

/obj/item/weapon/card/id/ltgrey
	name = "ring"
	icon_state = "id_ltgrey"
	item_state = "card-id"

/obj/item/weapon/card/id/white
	name = "ring"
	icon_state = "id_white"
	item_state = "card-id"

/obj/item/weapon/card/id/blankwhite
	name = "ring"
	icon_state = "id_blankwhite"
	item_state = "card-id"

/obj/item/weapon/card/id/meister_spare
	name = "Captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	icon_state = "gold"
	item_state = "gold_id"
	registered_name = "Captain"
	assignment = "Captain"
	New()
		var/datum/job/captain/J = new/datum/job/captain
		access = J.get_access()
		..()

/obj/item/weapon/card/id/lord
	name = "Lord ring"
	desc = "The ring of the High Lord himself."
	icon_state = "gold"
	item_state = "gold_id"
	registered_name = "Lord"
	assignment = "Lord"
	New()
		var/datum/job/captain/J = new/datum/job/captain
		access = J.get_access()
		..()


/obj/item/weapon/card/id/lordcave
	name = "Lord ring"
	desc = "The ring of the High Lord himself."
	icon_state = "count"
	item_state = "gold_id"
	registered_name = "Lord"
	assignment = "Lord"
	no_showing = TRUE

/obj/item/weapon/card/id/family
	name = "ring"
	icon_state = "family"

/obj/item/weapon/card/id/family/tribunal
	New()
		access = list()
		var/datum/job/captain/J = new/datum/job/captain
		access = J.get_access()
		..()

/obj/item/weapon/card/id/count
	name = "count ring"
	icon_state = "count"
	item_state = "gold_id"
	registered_name = "Count"
	assignment = "Count"
	no_showing = TRUE

/obj/item/weapon/card/id/count/hand
	registered_name = "Count Hand"
	assignment = "Count Hand"

/obj/item/weapon/card/id/count/heir
	icon_state = "id_heir"
	registered_name = "Count Heir"
	assignment = "Count Heir"

/obj/item/weapon/card/id/count/sieger
	icon_state = "id"
	item_state = "card-id"
	registered_name = "Sieger"
	assignment = "Sieger"

/obj/item/weapon/card/id/count/countess
	name = "countess ring"
	registered_name = "Countess"
	assignment = "Countess"