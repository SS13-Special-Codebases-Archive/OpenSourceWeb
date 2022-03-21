//TODO: rewrite and standardise all controller datums to the datum/controller type
//TODO: allow all controllers to be deleted for clean restarts (see WIP master controller stuff) - MC done - lighting done

/client/proc/restart_controller(controller in list("Master","Failsafe","Lighting","Supply Shuttle"))
	set category = "Debug"
	set name = "Restart Controller"
	set desc = "Restart one of the various periodic loop controllers for the game (be careful!)"

	if(!holder)	return
	usr = null
	src = null
	switch(controller)
		if("Supply Shuttle")
			supply_shuttle.process()
	message_admins("Admin [key_name_admin(usr)] has restarted the [controller] controller.")
	return


/client/proc/debug_controller(controller in list("Master","Failsafe","Ticker","Lighting","Air","Jobs","Sun","Radio","Supply Shuttle","Emergency Shuttle","Configuration","pAI", "Cameras", "Transfer Controller", "Train Shuttle"))
	set category = "Debug"
	set name = "Debug Controller"
	set desc = "Debug the various periodic loop controllers for the game (be careful!)"

	if(!holder)	return
	switch(controller)
		if("Master")
			debug_variables(master_controller)
		if("Ticker")
			debug_variables(ticker)
//		if("Lighting")
//			debug_variables(lighting_controller)
		if("Air")
			debug_variables(air_master)
		if("Jobs")
			debug_variables(job_master)
		if("Sun")
			debug_variables(sun)
		if("Radio")
			debug_variables(radio_controller)
		if("Supply Shuttle")
			debug_variables(supply_shuttle)
		if("Emergency Shuttle")
			debug_variables(emergency_shuttle)
		if("Configuration")
			debug_variables(config)
		if("pAI")
			debug_variables(paiController)
		if("Train Shuttle")
			debug_variables(train_shuttle)
		if("Cameras")
			debug_variables(cameranet)
		if("Transfer Controller")
			debug_variables(transfer_controller)
	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
	return
