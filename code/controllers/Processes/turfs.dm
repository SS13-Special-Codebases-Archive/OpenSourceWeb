/datum/controller/process/turf/setup()
	name = "turf"
	schedule_interval = 20 // every 2 seconds

/datum/controller/process/turf/doWork()
	for(var/turf/simulated/T in processing_turfs)
		T.process_turf()