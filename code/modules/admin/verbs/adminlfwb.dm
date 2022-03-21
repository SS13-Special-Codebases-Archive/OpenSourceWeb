/*
/datum/admins/proc/skip_baron()
	set category = "Server"
	set name = "Skip Baron Check"
	if(!ticker)
		alert("Unable to start the game as it is not set up.")
		return
	if(ticker.jobbypass == FALSE)
		ticker.jobbypass = TRUE
		src << "<b>JOB BYPASS TOGGLED :</b> [ticker.jobbypass]"
	else
		ticker.jobbypass = FALSE
		src << "<b>JOB BYPASS TOGGLED :</b> [ticker.jobbypass]"
*/