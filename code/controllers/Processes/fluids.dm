/datum/controller/process/fluids/setup()
	name = "fluid"
	schedule_interval = 12 // every 0.1 seconds
	start_delay = 8

/datum/controller/process/fluids/started()
	..()
	if(!ReagentsToUpdate)
		ReagentsToUpdate = list()

/datum/controller/process/fluids/doWork()
	for(last_object in ReagentsToUpdate)
		var/datum/O = last_object
		if(!QDELETED(O))
			try
				O:update()
				//O:maptext = null
				//O:maptext = "[O:depth]"
			catch(var/exception/e)
				catchException(e, O)
			SCHECK
		else
			catchBadType(O)
			ReagentsToUpdate -= O

/datum/controller/process/fluids/statProcess()
	..()
	stat(null, "[ReagentsToUpdate.len] objects")