/obj/item
	var/wrist_use = FALSE

/obj/item/device/radio/headset/bracelet
	icon = 'icons/obj/radio.dmi'
	name = "bracelet"
	suffix = "\[3\]"
	icon_state = "bracelet"
	item_state = "bracelet"
	wrist_use = TRUE
	item_state = "watch"

/obj/item/device/radio/headset/bracelet/attack_self(mob/user as mob)
	var/dat = {"<HTML><META http-equiv="X-UA-Compatible" content="IE=edge" charset="UTF-8"><style type="text/css"> body {font-family: Times; cursor: url('http://lfwb.ru/Icons/pointer.cur'), auto;} a {text-decoration:none;outline: none;border: none;margin:-1px;} a:focus{outline:none;} a:hover {color:#0d0d0d;background:#505055;outline: none;border: none;} a.active { text-decoration:none; color:#533333;} a.inactive:hover {color:#0d0d0d;background:#bb0000} a.active:hover {color:#bb0000;background:#0f0f0f} a.inactive:hover { text-decoration:none; color:#0d0d0d; background:#bb0000}</style> <body background bgColor=#0d0d0d text=#862525 alink=#777777 vlink=#777777 link=#777777><HEAD><TITLE>[name]</TITLE></HEAD><BODY>"}
	for(var/obj/item/weapon/card/id/ID in rings)
		if(ID.no_showing) continue
		if(ID.registered_name == "Unknown")	continue
		dat += "<b>[ID.registered_name]</b> <i>([ID.assignment])</i><br>"
	dat += "</BODY></HTML>"
	user << browse(dat, "window=bracelet;size=250x350;")

/obj/item/device/radio/headset/bracelet/RightClick(mob/living/user as mob)
	attack_self(user)

/obj/item/device/radio/headset/bracelet/talk_into(mob/living/M as mob)
	if(M.paralysis || M.stunned)
		to_chat(M, "<span class = 'combatbold'[pick(nao_consigoen)]</span><span class='combat'> I can't move my arm!</span>")
		return
	..()

/obj/item/device/radio/headset/bracelet/cheap
	icon = 'icons/obj/radio.dmi'
	name = "cheap bracelet"
	icon_state = "cheapbracelet"
	item_state = "watch"
	var/nofrenq = TRUE

/obj/item/device/radio/headset/bracelet/cheap/talk_into(mob/living/M as mob)
	if(nofrenq)
		to_chat(M, "This bracelet doesn't have a microphone!")
		return
	else
		..()

/obj/item/device/radio/headset/bracelet/captain
	keyslot2 = new /obj/item/device/encryptionkey/heads/captain

/obj/item/device/radio/headset/bracelet/cargo
	keyslot2 = new /obj/item/device/encryptionkey/headset_cargo

/obj/item/device/radio/headset/bracelet/eng
	keyslot2 = new /obj/item/device/encryptionkey/headset_eng

/obj/item/device/radio/headset/bracelet/esculap
	keyslot2 = new /obj/item/device/encryptionkey/heads/cmo

/obj/item/device/radio/headset/bracelet/med
	keyslot2 = new /obj/item/device/encryptionkey/headset_med

/obj/item/device/radio/headset/bracelet/security/censor
	keyslot2 = new /obj/item/device/encryptionkey/heads/hos

/obj/item/device/radio/headset/bracelet/security
	keyslot2 = new /obj/item/device/encryptionkey/headset_sec

/obj/item/device/radio/headset/bracelet/cheap/sec
	keyslot2 = new /obj/item/device/encryptionkey/headset_sec

/obj/item/device/radio/headset/bracelet/soulbreaker
	icon_state = "bracelet3"

/obj/item/device/radio/headset/bracelet/soulbreaker/New()
	..()
	qdel(keyslot1)
	var/radio_freq = SYND_FREQ
	keyslot1 = new /obj/item/device/encryptionkey/syndicate
	syndie = 1
	recalculateChannels()
	src.set_frequency(radio_freq)