#define FODIDO -1
#define NENHUM 0
#define MORTIDO 1
#define LIBIDO 2

var/list/pillar = list()
var/stateSuck = NENHUM

/obj/machinery/lifeweb/pillarr
	name = "lifeweb machinery"
	icon = 'LW2.dmi'
	icon_state = "ch0"
	desc = ""
	density = 1
	anchored = 1
	flammable = 0
	var/turnedOn = FALSE

	var/initialState = 1
	var/state = 0

/obj/machinery/lifeweb/pillarr/p2
	initialState = 2

/obj/machinery/lifeweb/pillarr/New()
	..()
	state = initialState
	pillar += src

/obj/machinery/lifeweb/pillarr/Destroy()
	..()
	pillar -= src

/obj/machinery/lifeweb/pillarr/proc/updateStatus()
	if(state == -1)
		icon_state = "ch2"
		return
	if(state && turnedOn)
		icon_state = "ch1"
		return
	icon_state = "ch0"
	return

/obj/machinery/lifeweb/pillarr/attack_hand(mob/living/carbon/human/user as mob)
	if(do_after(user, 20))
		playsound(user, 'sound/LW2/LWS_handle.ogg', 85, 1, -1)
		if(turnedOn)
			for(var/obj/machinery/lifeweb/pillarr/P in pillar)
				if(P != src && P.turnedOn)
					state = 0
					turnedOn = 0
					P.state = initialState

					stateSuck = initialState

					updateStatus()
					P.updateStatus()
					return
			turnedOn = 0
			updateStatus()
			stateSuck = NENHUM
			return

		state = initialState
		turnedOn = 1
		updateStatus()
		stateSuck = initialState

		for(var/obj/machinery/lifeweb/pillarr/P in pillar)
			if(P != src && P.turnedOn)
				state = -1
				P.state = -1

				stateSuck = FODIDO

				updateStatus()
				P.updateStatus()
				return

		return

/obj/machinery/lifeweb/control
	name = "lifeweb control panel"
	icon = 'icons/obj/LW2.dmi'
	icon_state = "lifeweb_control"
	desc = ""
	density = 1
	anchored = 1

/obj/machinery/lifeweb/control/New()
	..()
	var/icon/I = icon(icon = 'LW2.dmi', icon_state = "lifeweb_control_o")

	overlays += I
	set_light(2, 6, 2.8, 1, "#FAA019")

/obj/structure/stool/bed/chair/altar/New()
	..()
	processing_objects += src

/obj/structure/stool/bed/chair/altar/process()
	powerOutput = 0

	if(stateSuck == FODIDO || stateSuck == NENHUM)
		return
	if(Victim && src.status)
		if(ishuman(Victim))
			var/mob/living/carbon/human/H = Victim
			var/bloodVolume = H.vessel.get_reagent_amount("blood")

			if((bloodVolume - 11.2) < 11.2)
				return
			if(H.mortido + 5 >= 98 || H.libido - 5 <= 2 || H.libido + 5 >= 98 || H.mortido - 5 <= 2)
				return

			H.vessel.remove_reagent("blood", 11.2)
			H.bloodlevel = (bloodVolume * 100 / H.vessel.maximum_volume)

			var/amountToRemoveAdd = rand(1.56, 2) / 0.9
			if(stateSuck == MORTIDO && Victim.stat == DEAD)
				H.mortido += amountToRemoveAdd
				storeMort += amountToRemoveAdd
				H.libido -= amountToRemoveAdd
			if(stateSuck == LIBIDO && Victim.stat == UNCONSCIOUS || Victim.stat == UNCONSCIOUS)
				H.libido += amountToRemoveAdd
				storeLib += amountToRemoveAdd
				H.mortido -= amountToRemoveAdd
			var/difference = 10 / abs(abs(storeMort - storeLib) - ((storeMort + storeLib) / 1.5))
			difference = min(difference, 12.5)
			powerOutput = difference
			for(var/datum/disease/A in H.viruses)
				if(istype(A,/datum/disease/aids))
					powerOutput = 0
			if(istype(H,/mob/living/carbon/human/monster))
				powerOutput -= 10

			playsound(src.loc, pick('squirm1.ogg','squirm2.ogg','squirm3.ogg','squirm4.ogg','squirm5.ogg'), 100, 0, 0)

			var/list/batteries = list()
			for(var/obj/machinery/web_recharger/WR in chargers)
				if(WR.powered)
					batteries += WR

			for(var/obj/machinery/web_recharger/WR in chargers)
				if(WR.charging.charge + difference > 100)
					WR.charging.charge = 100
					continue
				WR.charging.charge += difference
			return 1
	return

/obj/machinery/lifeweb/control/attack_hand(mob/living/carbon/human/user as mob)
	var/html = file2text('code/modules/lifeweb/html/lifewebui.html')
	var/obj/structure/stool/bed/chair/altar/A = lifewebChair
	var/mob/living/carbon/human/H = A.Victim
	if(user.client)

		var/client/C = user.client
		C << browse_rsc('code/modules/lifeweb/html/background.png', "background.png")
		C << browse_rsc('code/modules/lifeweb/html/PTSANS.ttf', "PTSANS.ttf")

		sleep(5)
		winshow(usr, "lifeweb_terminal", 1)
		C << browse(html, "window=lifeweb_terminal;display=1; border=0;can_close=0; can_resize=0;")
		if(A.Victim)
			if(H.anchored && istype(H.anchored, /obj/structure/stool/bed/chair/altar))
				if(!A.status)
					C << output(list2params(list(0, H.suitable, H.bloodlevel, H.mortido, H.libido, "[lifewebChair.powerOutput]")), "lifeweb_terminal.browser1:updateLWValues")
				else
					C << output(list2params(list("1", H.suitable, H.bloodlevel, H.mortido, H.libido, "[lifewebChair.powerOutput]")), "lifeweb_terminal.browser1:updateLWValues")
		else
			C << output(list2params(list("1", "ERROR", "ERROR", "ERROR", "ERROR", "[lifewebChair.powerOutput]")), "lifeweb_terminal.browser1:updateLWValues")
		C.lfwbopen = TRUE