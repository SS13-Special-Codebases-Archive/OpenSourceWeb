//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/*
Space dust
Commonish random event that causes small clumps of "space dust" to hit the station at high speeds.
No command report on the common version of this event.
The "dust" will damage the hull of the station causin minor hull breaches.
*/

/proc/dust_swarm(var/strength = "weak")
	switch(strength)
		if("weak")
			spawn_meteors(number = rand(1,4), meteortypes = meteorsC)
		if("norm")
			spawn_meteors(number = rand(5,9), meteortypes = meteorsC)
		if("strong")
			spawn_meteors(number = rand(10,14), meteortypes = meteorsC)
		if("super")
			spawn_meteors(number = rand(15,25), meteortypes = meteorsC)
	return