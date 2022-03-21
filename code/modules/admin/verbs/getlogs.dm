//Shows today's server log
/datum/admins/proc/view_txt_log()
	set category = "Admin"
	set name = "Show Server Log"
	set desc = "Shows today's server log."

	var/path = "data/logs/[time2text(world.realtime,"YYYY/MM-Month/DD-Day")].log"
	if( fexists(path) )
		src << run( file(path) )
	else
		src << "<font color='red'>Error: view_txt_log(): File not found/Invalid path([path]).</font>"
		return
	return

//Shows today's attack log
/datum/admins/proc/view_atk_log()
	set category = "Admin"
	set name = "Show Server Attack Log"
	set desc = "Shows today's server attack log."

	var/path = "data/logs/[time2text(world.realtime,"YYYY/MM-Month/DD-Day")] Attack.log"
	if( fexists(path) )
		src << run( file(path) )
	else
		src << "<font color='red'>Error: view_atk_log(): File not found/Invalid path([path]).</font>"
		return
	usr << run( file(path) )
	return
