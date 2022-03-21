/area
	luminosity           = TRUE
	var/dynamic_lighting = TRUE

/area/New()
	..()
	if(dynamic_lighting)
		luminosity = FALSE

#define list_find(L, needle, LIMITS...) L.Find(needle, LIMITS)