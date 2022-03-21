/datum/controller/process/shuttle/setup()
	name = "shuttle"
	schedule_interval = 10 // every 1 second
	start_delay = 18

/datum/controller/process/shuttle/started()
	..()
	if(!shuttleMain)
		var/datum/shuttle/E = new
		shuttleMain = E

/datum/controller/process/shuttle/doWork()
	var/datum/shuttle/shuttle = shuttleMain
	shuttle.process()