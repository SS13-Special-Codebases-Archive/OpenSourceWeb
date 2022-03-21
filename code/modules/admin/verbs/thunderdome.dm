/client/proc/revive_td()
	set category = "Fun"
	set name = "Revive TD teams"
	set desc = "this smallgay don't know how to put this shit in secrets"

	for(var/mob/living/carbon/human/H in world)
		if(H.z == 7)
			H.revive()

/client/proc/tdparty()
	set category = "Fun"
	set name = "TD party"
	set desc = "cause all so lazy"

	var/t = 0
	for(var/mob/living/carbon/human/H in world)
		for(var/obj/item/I in H)
			H.u_equip(I)
			if(I)
				I.loc = H.loc
				I.layer = initial(I.layer)
				I.dropped(H)
		H.update_icons()
		H.Weaken(5)
		if(t)
			H.loc = pick(tdome2)
			H.tdome_team = 1
			t = !t
		else
			H.loc = pick(tdome1)
			H.tdome_team = 2
			t = !t


/client/proc/tp_td()
	set category = "Fun"
	set name = "Teleport TD teams"
	set desc = "just a teleportation without any healing"

	for(var/mob/living/carbon/human/H in world)
		if(H.tdome_team == 1)
			H.loc = pick(tdome2)
		else if(H.tdome_team == 2)
			H.loc = pick(tdome1)


/client/proc/c_op()
	set category = "Fun"
	set name = "Toggle extinguishers podlock"
	var/id = "thunder_lock_ass"

	open_blastdoors_by_id(id)

/client/proc/e_op()
	set category = "Fun"
	set name = "Toggle pro equipment podlock"
	var/id = "thunder_lock_pro"

	open_blastdoors_by_id(id)

/client/proc/t_op()
	set category = "Fun"
	set name = "Toggle arena podlocks"
	var/id = "thunder_lock"

	open_blastdoors_by_id(id)


/proc/open_blastdoors_by_id(var/id)
	for(var/obj/machinery/door/poddoor/M in world)
		if(M.id == id)
			if(M.density)
				M.open()
			else
				M.close()
