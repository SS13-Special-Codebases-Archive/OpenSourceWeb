var/church_name = null
/proc/church_name()
	if (church_name)
		return church_name

	var/name = ""

	name += pick("Holy", "United", "First", "Second", "Last")

	if (prob(20))
		name += " Space"

	name += " " + pick("Church", "Cathedral", "Body", "Worshippers", "Movement", "Witnesses")
	name += " of [religion_name()]"

	return name

var/command_name = null
/proc/command_name()
	if (command_name)
		return command_name

	var/name = "Central Command"

	command_name = name
	return name

/proc/change_command_name(var/name)

	command_name = name

	return name

var/religion_name = null
/proc/religion_name()
	if (religion_name)
		return religion_name

	var/name = ""

	name += pick("bee", "science", "edu", "captain", "assistant", "monkey", "alien", "space", "unit", "sprocket", "gadget", "bomb", "revolution", "beyond", "station", "goon", "robot", "ivor", "hobnob")
	name += pick("ism", "ia", "ology", "istism", "ites", "ick", "ian", "ity")

	return capitalize(name)

/proc/vessel_name()
	var/name = ""

	//Rare: Pre-Prefix

	// Prefix

	name = "Farweb†: "
	name += pick("Murder", "Love", "Kill the", "Love the","Kidnap the","Castrate the","Save","Deadly", "Paranoid", "Unidentified", "Skeleton", "Communist", "Dead","Sleeping","Thirsty","Hungry","Dangerous","Overdosed","Depressed","Butchered","Chuck","Feed","Seed","Foolish","False","Ominous")
	name += " "
	name += pick("Baron","Dreamer","Child","Bum","Amuser","Randy","Terrorist","Enoch","Consyte","Mortician","Whore","Witch","Lodge","Graga","Rat","Beast","Demon","Chimera","God","Inquisitor","Soup","Bees","Prophet","Bishop","Sheriff")

	world.name = name

	return name

/proc/world_name(var/name)

	vessel_name = name

	if (config && config.server_name)
		world.name = "[config.server_name]: [name]"
	else
		world.name = name

	return name