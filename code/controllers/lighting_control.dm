/var/lighting_overlays_initialised = FALSE

/var/list/lighting_update_lights    = list()    // List of lighting sources  queued for update.
/var/list/lighting_update_corners   = list()    // List of lighting corners  queued for update.
/var/list/lighting_update_overlays  = list()    // List of lighting overlays queued for update.

/var/list/lighting_update_lights_old    = list()    // List of lighting sources  currently being updated.
/var/list/lighting_update_corners_old   = list()    // List of lighting corners  currently being updated.
/var/list/lighting_update_overlays_old  = list()    // List of lighting overlays currently being updated.

/var/global/lighting_ticks = null

var/datum/controller/lighting/lighting_controller = new ()
/datum/controller/lighting
	// Queues of update counts, waiting to be rolled into stats lists
	var/list/stats_queues = list(
		"Source" = list(), "Corner" = list(), "Overlay" = list())
	// Stats lists
	var/list/stats_lists = list(
		"Source" = list(), "Corner" = list(), "Overlay" = list())
	var/update_stats_every = (1 SECONDS)
	var/next_stats_update = 0
	var/stat_updates_to_keep = 5

/datum/controller/lighting/Initialize()

	//world << "LOL"


	create_lighting_overlays()
	lighting_overlays_initialised = TRUE

	// Pre-process lighting once before the round starts. Wait 30 seconds so the away mission has time to load.
	spawn(15)
		Processo(1)

/datum/controller/lighting/proc/Processo()
	//world << "CHUNGUS"
	spawn(0)
		while(1)
			if(lighting_overlays_initialised)
				//world << "TRIPLO CHUNGUS COM QUEIJO"
				var/timer = world.timeofday
				process()
				lighting_ticks = (world.timeofday - timer) / 10
				sleep(1)

/datum/controller/lighting/proc/process(roundstart)
	var/list/lighting_update_lights_old = lighting_update_lights //We use a different list so any additions to the update lists during a delay from scheck() don't cause things to be cut from the list without being updated.
	lighting_update_lights = null //Nulling it first because of http://www.byond.com/forum/?post=1854520
	lighting_update_lights = list()

	for(var/datum/light_source/L in lighting_update_lights_old)
		if(L.destroyed || L.check() || L.force_update)
			L.remove_lum()
			if(!L.destroyed)
				L.apply_lum()

		else if(L.vis_update)	//We smartly update only tiles that became (in) visible to use.
			L.smart_vis_update()

		L.vis_update = 0
		L.force_update = 0
		L.needs_update = 0



	var/list/lighting_update_overlays_old = lighting_update_overlays //Same as above.
	lighting_update_overlays = null //Same as above
	lighting_update_overlays = list()

	for(var/atom/movable/lighting_overlay/O in lighting_update_overlays_old)
		O.update_overlay()
		O.needs_update = 0