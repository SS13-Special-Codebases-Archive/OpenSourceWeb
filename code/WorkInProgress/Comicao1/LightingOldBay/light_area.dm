/area
	luminosity           = TRUE
	var/lighting_use_dynamic = TRUE
/turf
	var/dynamic_lighting = TRUE

/area/New()
	..()
	if(lighting_use_dynamic)
		luminosity = FALSE