//LOOK G-MA, I'VE JOINED CARBON PROCS THAT ARE IDENTICAL IN ALL CASES INTO ONE PROC, I'M BETTER THAN LIFE()
//I thought about mob/living but silicons and simple_animals don't want this just yet.
//Right now just handles lying down, but could handle other cases later.
//IMPORTANT: Multiple animate() calls do not stack well, so try to do them all at once if you can.
/mob/living/carbon/update_transform()
	var/matrix/M = matrix()
	if(lying && !species?.prone_icon) //Only rotate them if we're not drawing a specific icon for being prone.
		M.Turn(90)
		M.Scale(size_multiplier)
		M.Translate(1,-6)
		src.dir = SOUTH
	else
		M.Scale(size_multiplier)
		M.Translate(0, 16*(size_multiplier-1))
	transform = M