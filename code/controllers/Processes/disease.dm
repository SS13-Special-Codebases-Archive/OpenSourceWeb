/datum/controller/process/disease/setup()
	name = "diseases"
	schedule_interval = 20 // every second
	start_delay = 6

/datum/controller/process/disease/doWork()
	process_diseases()

/datum/controller/process/disease/proc/process_diseases()
	var/i = 1
	while(i<=active_diseases.len)
		var/datum/disease/Disease = active_diseases[i]
		if(Disease)
			Disease.process()
			i++
			continue
		active_diseases.Cut(i,i+1)