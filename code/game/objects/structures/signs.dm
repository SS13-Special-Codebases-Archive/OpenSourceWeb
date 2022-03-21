/obj/structure/sign
	icon = 'icons/obj/decals.dmi'
	anchored = 1
	opacity = 0
	density = 0
	var/portrait_replaceable = 0
	layer = 3.5

/obj/structure/sign/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			qdel(src)
			return
		else
	return

/obj/structure/sign/blob_act()
	qdel(src)
	return

/obj/structure/sign/attackby(obj/item/tool as obj, mob/user as mob)	//deconstruction
	if(istype(tool, /obj/item/weapon/screwdriver) && !istype(src, /obj/structure/sign/double))
		user << "You unfasten the sign with your [tool]."
		var/obj/item/sign/S = new(src.loc)
		S.name = name
		S.desc = desc
		S.icon_state = icon_state
		//var/icon/I = icon('icons/obj/decals.dmi', icon_state)
		//S.icon = I.Scale(24, 24)
		S.sign_state = icon_state
		qdel(src)
	else ..()

/obj/item/sign
	name = "sign"
	desc = ""
	icon = 'icons/obj/decals.dmi'
	w_class = 3		//big
	var/sign_state = ""

/obj/item/sign/attackby(obj/item/tool as obj, mob/user as mob)	//construction
	if(istype(tool, /obj/item/weapon/screwdriver) && isturf(user.loc))
		var/direction = input("In which direction?", "Select direction.") in list("North", "East", "South", "West", "Cancel")
		if(direction == "Cancel") return
		var/obj/structure/sign/S = new(user.loc)
		switch(direction)
			if("North")
				S.pixel_y = 32
			if("East")
				S.pixel_x = 32
			if("South")
				S.pixel_y = -32
			if("West")
				S.pixel_x = -32
			else return
		S.name = name
		S.desc = desc
		S.icon_state = sign_state
		user << "You fasten \the [S] with your [tool]."
		qdel(src)
	else ..()

/obj/structure/sign/double/map
	name = "station map"
	desc = "A framed picture of the station."

/obj/structure/sign/double/map/left
	icon_state = "map-left"

/obj/structure/sign/double/map/right
	icon_state = "map-right"

/obj/structure/sign/securearea
	name = "\improper SECURE AREA"
	desc = "A warning sign which reads 'SECURE AREA'."
	icon_state = "securearea"

/obj/structure/sign/biohazard
	name = "\improper BIOHAZARD"
	desc = "A warning sign which reads 'BIOHAZARD'"
	icon_state = "bio"

/obj/structure/sign/electricshock
	name = "\improper HIGH VOLTAGE"
	desc = "A warning sign which reads 'HIGH VOLTAGE'"
	icon_state = "shock"

/obj/structure/sign/examroom
	name = "\improper EXAM"
	desc = "A guidance sign which reads 'EXAM ROOM'"
	icon_state = "examroom"

/obj/structure/sign/vacuum
	name = "\improper HARD VACUUM AHEAD"
	desc = "A warning sign which reads 'HARD VACUUM AHEAD'"
	icon_state = "space"

/obj/structure/sign/deathsposal
	name = "\improper DISPOSAL LEADS TO SPACE"
	desc = "A warning sign which reads 'DISPOSAL LEADS TO SPACE'"
	icon_state = "deathsposal"

/obj/structure/sign/pods
	name = "\improper ESCAPE PODS"
	desc = "A warning sign which reads 'ESCAPE PODS'"
	icon_state = "pods"

/obj/structure/sign/fire
	name = "\improper DANGER: FIRE"
	desc = "A warning sign which reads 'DANGER: FIRE'"
	icon_state = "fire"

/obj/structure/sign/nosmoking_1
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'"
	icon_state = "nosmoking"

/obj/structure/sign/nosmoking_2
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'"
	icon_state = "nosmoking2"

/obj/structure/sign/redcross
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here.'"
	icon_state = "redcross"

/obj/structure/sign/greencross
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here.'"
	icon_state = "greencross"

/obj/structure/sign/goldenplaque
	name = "The Most Robust Men Award for Robustness"
	desc = "To be Robust is not an action or a way of life, but a mental state. Only those with the force of Will strong enough to act during a crisis, saving friend from foe, are truly Robust. Stay Robust my friends."
	icon_state = "goldenplaque"

/obj/structure/sign/kiddieplaque
	name = "AI developers plaque"
	desc = "Next to the extremely long list of names and job titles, there is a drawing of a little child. The child appears to be retarded. Beneath the image, someone has scratched the word \"PACKETS\""
	icon_state = "kiddieplaque"

/obj/structure/sign/atmosplaque
	name = "\improper FEA Atmospherics Division plaque"
	desc = "This plaque commemorates the fall of the Atmos FEA division. For all the charred, dizzy, and brittle men who have died in its hands."
	icon_state = "atmosplaque"

/obj/structure/sign/double/maltesefalcon	//The sign is 64x32, so it needs two tiles. ;3
	name = "The Maltese Falcon"
	desc = "The Maltese Falcon, Space Bar and Grill."

/obj/structure/sign/double/maltesefalcon/left
	icon_state = "maltesefalcon-left"

/obj/structure/sign/double/maltesefalcon/right
	icon_state = "maltesefalcon-right"

/obj/structure/sign/science			//These 3 have multiple types, just var-edit the icon_state to whatever one you want on the map
	name = "\improper SCIENCE!"
	desc = "A warning sign which reads 'SCIENCE!'"
	icon_state = "science1"

/obj/structure/sign/chemistry
	name = "\improper CHEMISTRY"
	desc = "A warning sign which reads 'CHEMISTRY'"
	icon_state = "chemistry1"

/obj/structure/sign/botany
	name = "\improper HYDROPONICS"
	desc = "A warning sign which reads 'HYDROPONICS'"
	icon_state = "hydro1"

/obj/structure/sign/directions/science
	name = "\improper Science department"
	desc = "A direction sign, pointing out which way Science department is."
	icon_state = "direction_sci"

/obj/structure/sign/directions/engineering
	name = "\improper Engineering department"
	desc = "A direction sign, pointing out which way Engineering department is."
	icon_state = "direction_eng"

/obj/structure/sign/directions/security
	name = "\improper Security department"
	desc = "A direction sign, pointing out which way Security department is."
	icon_state = "direction_sec"

/obj/structure/sign/directions/medical
	name = "\improper Medical Bay"
	desc = "A direction sign, pointing out which way Meducal Bay is."
	icon_state = "direction_med"

/obj/structure/sign/directions/evac
	name = "\improper Escape Arm"
	desc = "A direction sign, pointing out which way escape pods are."
	icon_state = "direction_evac"


//New Signs

/obj/structure/sign/deck1
	desc = "A silver sign which reads 'DECK I'."
	name = "DECK I"
	icon_state = "deck1"

/obj/structure/sign/deck2
	desc = "A silver sign which reads 'DECK II'."
	name = "DECK II"
	icon_state = "deck2"

/obj/structure/sign/deck3
	desc = "A silver sign which reads 'DECK III'."
	name = "DECK III"
	icon_state = "deck3"

/obj/structure/sign/deck4
	desc = "A silver sign which reads 'DECK IV'."
	name = "DECK IV"
	icon_state = "deck4"

/obj/structure/sign/nanotrasen
	name = "\improper NanoTrasen"
	desc = "An old metal sign which reads 'NanoTrasen'."
	icon_state = "NT"

/obj/structure/sign/signnew/biohazard
	name = "BIOLOGICAL HAZARD"
	desc = "Warning: Biological and-or toxic hazards present in this area!"
	icon_state = "biohazard"

/obj/structure/sign/signnew/corrosives
	name = "CORROSIVE SUBSTANCES"
	desc = "Warning: Corrosive substances prezent in this area!"
	icon_state = "corrosives"

/obj/structure/sign/signnew/explosives
	name = "EXPLOSIVE SUBSTANCES"
	desc = "Warning: Explosive substances present in this area!"
	icon_state = "explosives"

/obj/structure/sign/signnew/flammables
	name = "FLAMMABLE SUBSTANCES"
	desc = "Warning: Flammable substances present in this area!"
	icon_state = "flammable"

/obj/structure/sign/signnew/laserhazard
	name = "LASER HAZARD"
	desc = "Warning: High powered laser emitters operating in this area!"
	icon_state = "laser"

/obj/structure/sign/signnew/danger
	name = "DANGEROUS AREA"
	desc = "Warning: Generally hazardous area! Exercise caution."
	icon_state = "danger"

/obj/structure/sign/signnew/magnetics
	name = "MAGNETIC FIELD HAZARD"
	desc = "Warning: Extremely powerful magnetic fields present in this area!"
	icon_state = "magnetics"

/obj/structure/sign/signnew/opticals
	name = "OPTICAL HAZARD"
	desc = "Warning: Optical hazards present in this area!"
	icon_state = "optical"

/obj/structure/sign/signnew/radiation
	name = "RADIATION HAZARD"
	desc = "Warning: Significant levels of radiation present in this area!"
	icon_state = "radiation"

/obj/structure/sign/signnew/secure
	name = "SECURE AREA"
	desc = "Warning: Secure Area! Do not enter without authorization!"
	icon_state = "secure"

/obj/structure/sign/signnew/electrical
	name = "ELECTRICAL HAZARD"
	desc = "Warning: Electrical hazards! Wear protective equipment."
	icon_state = "electrical"

/obj/structure/sign/signnew/cryogenics
	name = "CRYOGENIC TEMPERATURES"
	desc = "Warning: Extremely low temperatures in this area."
	icon_state = "cryogenics"

/obj/structure/sign/signnew/canisters
	name = "PRESSURIZED CANISTERS"
	desc = "Warning: Highly pressurized canister storage."
	icon_state = "canisters"

/obj/structure/sign/signnew/oxidants
	name = "OXIDIZING AGENTS"
	desc = "Warning: Oxidizing agents in this area, do not start fires!"
	icon_state = "oxidants"

/obj/structure/sign/signnew/memetic
	name = "MEMETIC HAZARD"
	desc = "Warning: Memetic hazard, wear meson goggles!"
	icon_state = "memetic"

/obj/structure/sign/signnew/web
	plane = 21

/obj/structure/sign/signnew/web/cctv
	name = "CCTV"
	desc = "Smile : You are being watched."
	icon_state = "cctv"

/obj/structure/sign/signnew/web/meister
	name = "meistery"
	icon_state = "meister"

/obj/structure/sign/signnew/web/church
	name = "church"
	icon_state = "church"

/obj/structure/sign/signnew/web/chem
	name = "chemistry"
	icon_state = "chem"

/obj/structure/sign/signnew/web/toilet
	name = "toilet"
	icon_state = "toilet"

/obj/structure/sign/signnew/web/harbor
	name = "harbor"
	icon_state = "harbor"

/obj/structure/sign/signnew/web/post
	name = "post"
	icon_state = "post"

/obj/structure/sign/signnew/web/mine
	name = "mine"
	icon_state = "mine"

/obj/structure/sign/signnew/web/bed
	name = "bedroom"
	icon_state = "bed"

/obj/structure/sign/signnew/web/oldcock
	name = "Old Cock Inn"
	icon_state = "oldcock"

/obj/structure/sign/signnew/web/pcross
	name = "Post Christian Cross"
	icon_state = "pcross"

/obj/structure/sign/signnew/web/flag_raven
	name = "Ravenheart Flag"
	icon_state = "flag_raven"

/obj/structure/sign/signnew/web/flag_firethorn
	name = "Firethorn Flag"
	icon_state = "flag_firethorn"


/obj/structure/sign/signnew/web/wallsmall
	name = "Firethorn Flag"
	icon_state = "wallsmall"

/obj/structure/sign/signnew/web/wallmedium
	name = "Firethorn Flag"
	icon_state = "wallmedium"

/obj/structure/sign/signnew/web/walllarge
	name = "Firethorn Banner"
	icon_state = "walllarge"

/obj/structure/sign/signnew/web/stand
	name = "Firethorn Banner"
	icon_state = "stand"

/obj/structure/sign/signnew/web/firethorn
	name = "Firethorn Banner"
	icon_state = "firethorn"

/obj/structure/stand
	name = "bookcase"
	icon = 'icons/obj/decalsbig.dmi'
	icon_state = "stand"
	anchored = 0
	density = 0
	plane = 21

/obj/structure/sign/signnew/web/flag_raven/attack_hand(mob/user as mob)
	var/mob/living/carbon/human/M = user
	if(M.siegesoldier)
		user << "<span class='notice'>Take this shit down!</span>"
		if(do_after(user, 30))
			src.icon_state = "flag_count"
			name = "Count Flag"
			M.visible_message( \
				"[M] replaces \the flag with a new flag!", \
				"\blue You have replaced \the flag.")
			return
	else
		return 0

/obj/structure/sign/signnew/web/flag_count
	name = "Count Flag"
	icon_state = "flag_count"


/obj/structure/sign/signnew/web/quiet_world
	name = "Quiet World"
	icon = 'raventhrone.dmi'
	icon_state = "qw1"

/obj/structure/sign/signnew/web/quiet_world/_2
	icon_state = "qw2"

/obj/structure/sign/signnew/web/quiet_world/_3
	icon_state = "qw3"

/obj/structure/sign/signnew/web/quiet_world/_4
	icon_state = "qw4"

/obj/structure/sign/signnew/web/quiet_world/_5
	icon_state = "qw5"

/obj/structure/sign/signnew/web/evergreen
	name = "Evergreen"
	icon_state = "evergreen"

/obj/structure/sign/signnew/web/getulio
	name = "Imperador Vargis I : Casa Vargis"
	desc = "O nosso grande e poderoso lider."
	icon_state = "getulio"
	portrait_replaceable = TRUE

/obj/structure/sign/signnew/web/antonio
	name = "Arque-Bispo Antônio III"
	desc = "Existe esperança na escuridão."
	icon_state = "antonio"
	portrait_replaceable = TRUE

/obj/structure/sign/signnew/web/fish
	name = "fish"
	desc = ""
	icon_state = "fish"

/obj/structure/sign/signnew/web/irineu
	name = "Engenheiro Oenri"
	desc = "O grande homem por trás de onde estamos hoje."
	icon_state = "irineu"
	portrait_replaceable = TRUE

/obj/structure/sign/signnew/web/plineosalgado
	name = "Revolucionário Plínio Salgado"
	desc = "Um líder integralista conhecido pela lema: Deus, Pátria, Família."
	icon_state = "plinio"


/obj/structure/sign/signnew/web/attack_hand(mob/user as mob)
	if(portrait_replaceable)
		var/mob/living/carbon/human/M = user
		if(user.mind && user.mind in ticker.mode.head_revolutionaries)
			to_chat(user, "<span class='passive'>Take this shit down!</span>")
			if(do_after(user, 30))
				src.icon_state = "plinio"
				name = "Lider Plinean Salgaka"
				portrait_replaceable = FALSE
				plinioposters += 1
				to_chat(user, "<span class='passive'>([plinioposters]/8) portraits replaced!</span>")
				desc = "Um rebelde integralista, o que isso está fazendo aqui?!"
				M.visible_message( \
					"[M] replaces \the portrait with a new portrait!", \
					"\blue You have replaced \the portrait.")
				return
		else
			..()
	else
		..()

/obj/structure/sign/signnew/web/lib
	name = "library"
	icon_state = "lib"

/obj/structure/sign/signnew/web/kitchen
	name = "kitchen"
	icon_state = "kitchen"

/obj/structure/sign/signnew/web/det
	name = "detective office"
	icon_state = "det"

/obj/structure/sign/signnew/web/wall_detail
	name = "bars"
	icon_state = "detail1"

/obj/structure/sign/signnew/web/church_glass
	name = "P.C Glass"
	icon = 'icons/life/LFWB_USEFUL.dmi'
	icon_state = "stglass1"
	New()
		..()
		src.icon_state = "stglass[rand(1,5)]"

/obj/structure/sign/signnew/web/mae_gostosa_do_borg//GOZEI NA MAE DO COMICAO KKKKKKKKKKKKKK
	name = "Pray Union Follow"//GOZEI NA MAE DO COMICAO KKKKKKKKKKKKKK
	desc = ""//GOZEI NA MAE DO COMICAO KKKKKKKKKKKKKK
	icon = 'icons/life/LFWB_USEFUL_BIG.dmi'//GOZEI NA MAE DO COMICAO KKKKKKKKKKKKKK
	icon_state = "church"//GOZEI NA MAE DO COMICAO KKKKKKKKKKKKKK

/obj/structure/sign/signnew/web/friendly_face
	name = "friendly face"
	icon_state = "R2"
	New()
		..()
		src.icon_state = pick("R2","R3")

/obj/structure/sign/signnew/web/status_display
	name = "telescreen"
	icon_state = "picture"
	New()
		..()
		src.icon_state = pick("picture","picture2","picture3")

/obj/structure/sign/signnew/web/poster/porn
	name = "Obscene Poster"
	icon_state = "obscene1"
	New()
		..()
		src.icon_state = pick("obscene1","obscene2","obscene3","obscene4","obscene5","obscene6","obscene7","obscene8")

/obj/structure/sign/signnew/web/poster/graffiti
	name = "graffiti"
	icon = 'icons/obj/walldecals.dmi'
	icon_state = "graffiti"
	New()
		..()
		src.icon_state = pick("BLOOD","graffiti","graffiti2","graffiti3","graffiti4","graffiti6","graffiti5","graffiti7","graffiti8","graffiti9")

/obj/structure/sign/signnew/web/poster/sewerpipe
	name = "sewer pipe"
	icon = 'icons/obj/walldecals.dmi'
	icon_state = "pipe"
	New()
		..()
		src.icon_state = pick("pipe","pipe_fucked","pipe_small")

/obj/structure/sign/signnew/web/poster/sewerpipeflow
	name = "flowing sewer pipe"
	icon = 'icons/obj/walldecals.dmi'
	icon_state = "pipe_flow"
	New()
		..()
		src.icon_state = pick("pipe_flow","pipe_flow2","pipe_flow3")

/obj/structure/sign/signnew/web/poster/wallhole
	name = "sewer pipe"
	icon = 'icons/obj/walldecals.dmi'
	icon_state = "wall_hole2"
	New()
		..()
		src.icon_state = pick("wall_hole3","wall_hole2")

/obj/structure/sign/signnew/web/poster/lana
	name = "Lana Del Rey Poster"
	icon_state = "lana"

/obj/structure/sign/signnew/web/poster/lana
	name = "Lana Del Rey Poster"
	icon_state = "lana"

/obj/structure/sign/signnew/web/poster/pray
	name = "Pray Harder!"
	icon_state = "poster_pray"

/obj/structure/sign/signnew/web/poster/death
	name = "Death is inevitable."
	icon_state = "death"

/obj/structure/sign/signnew/web/poster/sad
	name = "Sad poster"
	icon_state = "sad"

/obj/structure/sign/signnew/web/poster/thoushall
	name = "Thou shall not kill"
	icon = 'big.dmi'
	icon_state = "thou"

/obj/structure/sign/signnew/web/poster/comatic
	name = "Comatic Poster"
	icon_state = "ikon1"
	New()
		..()
		src.icon_state = pick("ikon1","ikon2","ikon3")

/obj/structure/sign/signnew/web/poster/calendary
	name = "Calendary"
	icon_state = "kalendar1"
	New()
		..()
		src.icon_state = pick("kalendar1","kalendar2")

/obj/structure/sign/signnew/web/poster/inquisitor
	name = "Inquisitor Poster"
	icon_state = "inq"
	New()
		..()
		src.icon_state = pick("inq1","inq")

/obj/structure/sign/signnew/web/cargo
	name = "exports office"
	icon_state = "exports"

/obj/structure/sign/signnew/web/train
	name = "train"
	desc = "I dont think this was supposed to be in a mining station..."
	icon_state = "train"

/obj/structure/sign/signnew/web/wide/medbaywide
	name = "medbay"
	icon_state = "medbaywide"

/obj/structure/sign/signnew/web/wide/cerbwide
	name = "cerberon"
	icon_state = "cerbwide"

/obj/structure/sign/signnew/web/wide/signs
	icon = 'icons/obj/stationsigns.dmi'

/obj/structure/sign/signnew/web/wide/signs/ravenheart
	name = "ravenheart"
	icon_state = "ravenheart"

/obj/structure/sign/signnew/web/wide/signs/firethorn
	name = "firethorn"
	icon_state = "firethorn"

/obj/structure/sign/signnew/web/wide/signs/firethorn2
	name = "firethorn"
	icon_state = "firethorn2"

/obj/structure/sign/signnew/web/wide/signs/sanctuary
	name = "sanctuary"
	icon_state = "sanctuary"

/obj/structure/sign/signnew/web/wide/signs/oldcock
	name = "Old Cock Inn"
	icon_state = "oldcock"

/obj/structure/sign/signnew/web/wide/bridgewide
	name = "bridge"
	icon_state = "bridgewide"


/obj/structure/sign/signnew/web/wide/archives
	name = "archives"
	icon_state = "archive"

/obj/structure/sign/signnew/web/wide/armory
	name = "Armory"
	icon_state = "armory"

/obj/structure/sign/signnew/web/wide/bar
	name = "The Trauma"
	icon_state = "bar1"

/obj/structure/sign/signnew/web/wide/field
	name = "the field"
	icon_state = "honor"

/obj/structure/sign/signnew/web/wide/heavensnight
	name = "Heaven's Night"
	icon = 'icons/obj/heavensnight.dmi'
	icon_state = "Heavensnight"


/obj/structure/sign/signnew/web/wide/evawide
	name = "E.V.A"
	icon_state = "evawide"

/obj/structure/sign/signnew/web/wide/cargowide
	name = "exports office"
	icon_state = "cargowide"

/obj/structure/sign/signnew/web/church/sunofeternalnight
	name = "sun of eternal night"
	icon = 'sun_of_eternal_night.dmi'
	icon_state = "sun"
	layer = 2.1
	plane = 0

////////////////////
////////HIVE////////
////////////////////

/obj/structure/sign/signnew/soulbreaker
	icon = 'sb_decor.dmi'
	name = "The Hive"


/obj/structure/sign/signnew/soulbreaker/allah
	icon_state = "a"


/obj/structure/sign/signnew/soulbreaker/allah/New()
	filters = filter(type="drop_shadow","x"=0,"y"=0,"size"=2,"color"="#F4DF82")


/obj/structure/sign/signnew/soulbreaker/flash
	icon_state = "b"

/obj/structure/sign/signnew/soulbreaker/flag
	icon_state = "c"

/obj/structure/sign/signnew/soulbreaker/panel
	icon_state = "p"
	icon = 'icons/obj/pillars.dmi'