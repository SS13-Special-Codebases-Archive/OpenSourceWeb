/proc/command_alert(var/text, var/title = "")
	var/command
	command += "<h1 class='alert'>[command_name()] Update</h1>"
	if (title && length(title) > 0)
		command += "<br><h2 class='alert'>[title]</h2>"

	command += "<br><span class='alert'>[sanitize_uni(text)]</span><br>"
	command += "<br>"
	for(var/mob/M in player_list)
		if(!istype(M,/mob/new_player))
			M << command

/proc/captain_announce(var/text)
	world << "<h1 class='alert'>Priority Announcement</h1>"
	world << "<span class='alert'>[sanitize(text)]</span>"
	world << "<br>"