/mob/living/carbon/human/proc/pathfinder_track()
	set hidden = 0
	set name = "TrackSomeonePathfinder"

	if(!check_perk(/datum/perk/pathfinder))
		return

	var/list/keys = list()
	for(var/mob/living/carbon/human/M in mob_list)
		keys += M
	var/selection = input("Track someone!", "Tracker", null, null) as null|anything in sortKey(keys)
	if(!selection)
		return
	if(istype(selection, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = selection
		var/area/area = H.loc
		to_chat(src, "[H] is at [area.name], at X [H.x] Y [H.y] of Evergreen.")

/mob/living/carbon/human/proc/pathfinder_trackself()
	set hidden = 0
	set name = "TrackselfPathfinder"
	if(!check_perk(/datum/perk/pathfinder))
		return
	var/area/area = loc
	to_chat(src, "I am at [area.name], at X [src.x] Y [src.y] of Evergreen.")