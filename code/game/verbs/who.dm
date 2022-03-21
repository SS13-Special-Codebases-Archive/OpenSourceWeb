var/showlads
/client/var/relevancy_color = "#454343"

var/list/datum/showlads_holder/showlads_list = list()
/datum/showlads_holder //for when people's bodies get destroyed.
	var/name = ""
	var/job = ""
	var/key = ""
	var/thanati = FALSE

/datum/showlads_holder/New()
	..()
	showlads_list |= src

/client/verb/who()
	set name = "Who"
	set category = "OOC"
	var/dat = "<META http-equiv='X-UA-Compatible' content='IE=edge' charset='UTF-8'><META charset='UTF-8'><Title>WHO+</title><style type='text/css'>html {overflow: auto;};body {font-family: Times;cursor: url('pointer.cur'), auto;}.D3{background-color: #000;color: #fff;padding: 3px;}.D2{background-color: #eee;}img {padding-bottom:0px;}table, th, td {   border: 1px solid #bbb;}table{border-collapse: collapse;}</style>"
	var/n = 0
	var/mills = world.time // 1/10 of a second, not real milliseconds but whatever
	//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence.. or something
	var/mins = (mills % 36000) / 600
	var/hours = mills / 36000
	for(var/client/C in clients)
		n++
	dat += "<body><table width=800 border = 1>"
	dat += "<tr class = 'D3'>"
	dat += "<th><B>Addict</B> </th>"
	dat += "<th><B>Registered</B></th>"
	dat += "<th><B>BYOND Version</B></th>"
	dat += "<th><B>Achievements</B></th>"
	dat += "<th><B>Rounds Played</B></th>"
	dat += "</tr>"
	for(var/client/C in clients)
		if(guardianlist.Find(ckey(C.key)))
			C.relevancy_color = "#0a041f"
		else if(comradelist.Find(ckey(C.key)))
			C.relevancy_color = "#107710"
		else if(villainlist.Find(ckey(C.key)))
			C.relevancy_color = "#107710"
		else if(pigpluslist.Find(ckey(C.key)))
			C.relevancy_color = "#bbbbbb"
		else
			C.relevancy_color = "#bbbbbb"
		dat += "<tr class = 'D2'>"
		if(anonists_deb.Find(C.ckey))
			dat += "<td><b>\t<font color='[C.relevancy_color]'><img src='https://cdn.discordapp.com/attachments/781574628229382144/817382958809743370/pigforrandy32x.png' width='20' height='20'>[C.key]</font></b></td>"
		else
			var/countrycoderson = C.Country_Code
			switch(C.ckey)
				if("wer6")
					countrycoderson = "nk"
			if(guardianlist.Find(ckey(C.key)))
				if(!C.prefs.toggle_nat)
					dat += "<td>\t<font color='[C.relevancy_color]'><img src='https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/lg/57/sleuth-or-spy_1f575.png' width='20' height='20'><b>[C.key]</b></font></td>"
				else
					dat += "<td>\t<font color='[C.relevancy_color]'><img src='https://www.countryflags.io/[countrycoderson]/shiny/32.png' width='20' height='20'><b>[C.key]</b></font></td>"
			else
				if(!comradelist.Find(ckey(C.key)) && !villainlist.Find(ckey(C.key)))
					if(pigpluslist.Find(ckey(C.key)))
						if(!C.prefs.toggle_nat)
							dat += "<td><b>\t<font color='[C.relevancy_color]'><img src='https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/lg/57/sleuth-or-spy_1f575.png' width='20' height='20'>[C.key]</font></b></td>"
						else
							dat += "<td><b>\t<font color='[C.relevancy_color]'><img src='https://www.countryflags.io/[countrycoderson]/shiny/32.png' width='20' height='20'>[C.key]</font></b></td>"
					else
						if(!C.prefs.toggle_nat)
							dat += "<td>\t<font color='[C.relevancy_color]'><img src='https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/lg/57/sleuth-or-spy_1f575.png' width='20' height='20'><small>[C.key]</small></font></td>"
						else
							dat += "<td>\t<font color='[C.relevancy_color]'><img src='https://www.countryflags.io/[countrycoderson]/shiny/32.png' width='20' height='20'><small>[C.key]</small></font></td>"
				else
					if(!C.prefs.toggle_nat)
						dat += "<td>\t<font color='[C.relevancy_color]'><img src='https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/lg/57/sleuth-or-spy_1f575.png' width='20' height='20'>[C.key]</font></td>"
					else
						dat += "<td>\t<font color='[C.relevancy_color]'><img src='https://www.countryflags.io/[countrycoderson]/shiny/32.png' width='20' height='20'>[C.key]</font></td>"
		if(C.InvitedBy)
			dat += "<td>\t[C.InvitedBy]</td>"
		else
			dat += "<td>\t[C.JoinDate]</td>"
		dat += "<td>\t[C.byond_version]/[C.byond_build]</td>"
		dat += "<td>\t<a href='?src=\ref[src];achievements=\ref[C]'>Check</a></td>"
		dat += "<td>\t[C?.prefs?.roundsplayed]</td>"
		dat += "</tr>"
	dat += "</table>"
	dat += "<BR><b>[n] players online.</b>"
	dat += "<BR><b>Round Duration: [round(hours)]h [round(mins)]m</b>"
	src << browse(dat, "window=whoscreen;size=850x520;can_close=1")

/*
/client/verb/who()
	set name = "Who"
	set category = "OOC"
	var/dat = "<html><head><style>table, th, td {  border: 1px solid black; border-collapse: collapse;} th, td {padding: 15px;}</style></head><body><center>"
	var/n = 0
	var/mills = world.time // 1/10 of a second, not real milliseconds but whatever
	//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence.. or something
	var/mins = (mills % 36000) / 600
	var/hours = mills / 36000
	for(var/client/C in clients)
		n++
	dat += "Viciados ativos: [n]<br>"
	dat += "Round Duration: [round(hours)]h [round(mins)]m<br>"
	dat += "<table style='width:90%'>"
	dat += "<tr>"
	dat += "<th>Ckey</th>"
	dat += "<th>BYOND</th>"
	dat += "<th>CHR</th>"
	dat += "</tr>"
	for(var/client/C in clients)
		if(comradelist.Find(ckey(C.key)))
			C.relevancy_color = "#2a2b4f"
		else if(villainlist.Find(ckey(C.key)))
			C.relevancy_color = "#5c0202"
		else
			C.relevancy_color = "#454343"
		dat += "<tr>"
		dat += "<td><b>\t<font color='[C.relevancy_color]'>[C.key]</font></b></td>"
		dat += "<td><b>\t[C.byond_version]/[C.byond_build]</b></td>"
		dat += "<td><b>\t[C.prefs.chromossomes]</b></td>"
		dat += "</tr>"
	dat += "</table>"
	dat += "</center>"
	src << browse(dat, "window=whoscreen;size=450x500;can_close=1")
*/

proc/sendShowlads()
	var/botList
	botList += "\n STORY [story_id]\n"
	if(master_mode == "holywar" || master_mode == "minimig")
		botList += "POST CHRISTIANS"

		for(var/mob/living/carbon/human/C in mob_list)
			if(C.old_key)
				botList += "\n &#8226; [C.real_name] ([C.old_job]) : [C.old_key]\n"

		for(var/datum/showlads_holder/S in showlads_list)
			if(S.job && S.name && S.key)
				botList += "\n &#8226; [S.name] ([S.job]) : [S.key]\n"

		botList += "\n THANATI"
		for(var/mob/living/carbon/human/C in mob_list)
			if(C.old_key && C.religion == "Thanati")
				botList += "\n &#8226; [C.real_name] ([C.old_job]) : [C.old_key]"
		for(var/datum/showlads_holder/S in showlads_list)
			if(S.job && S.name && S.key && S.thanati)
				botList += "\n &#8226; [S.name] ([S.job]) : [S.key]"
		if(world.port == IZ1_PORT)
			world.Export("http://nopm.xyz:1234/showlads?content=[botList]?port=1234")
		return 1

	else
		botList += "FIRETHORN VICTIMS"

		for(var/mob/living/carbon/human/C in mob_list)
			if(C.old_key)
				botList += "\n &#8226; [C.real_name] ([C.old_job]) : [C.old_key]\n"
		for(var/datum/showlads_holder/S in showlads_list)
			if(S.job && S.name && S.key)
				botList += "\n &#8226; [S.name] ([S.job]) : [S.key]\n"

		botList += "\n THANATI"
		for(var/mob/living/carbon/human/C in mob_list)
			if(C.old_key && C.religion == "Thanati")
				botList += "\n &#8226; [C.real_name] ([C.old_job]) : [C.old_key]\n"

		for(var/datum/showlads_holder/S in showlads_list)
			if(S.job && S.name && S.key && S.thanati)
				botList += "\n &#8226; [S.name] ([S.job]) : [S.key]\n"
		
		if(world.port == IZ1_PORT)
			world.Export("http://nopm.xyz:1234/showlads?content=[botList]?port=1234")
		return 1
	return
	botList += "FIRETHORN VICTIMS"
	for(var/mob/living/C in world)
		if(C.old_key)
			botList += "\n &#8226; [C.real_name] ([C.old_job]) : [C.old_key]\n"

		botList += "\n THANATI"
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.old_key && H.religion == "Thanati")
			botList += "\n &#8226; [H.real_name] ([H.old_job]) : [H.old_key]"
	
	if(world.port == IZ1_PORT)
		world.Export("http://nopm.xyz:1234/showlads?content=[botList]?port=1234")
	return 1

/client/verb/showlads()
	set name = "Show Lads"
	set category = "OOC"
	var/dat = "<html><head><style>table, th, td {  border: 1px solid black; border-collapse: collapse;} th, td {padding: 15px;}</style></head><body>"

	if(!showlads && !holder)
		return
	if(master_mode == "holywar" || master_mode == "minimig")
		dat += "<center><h2>POST CHRISTIANS</h2></center>"
		for(var/mob/living/C in world)
			if(C.old_key)
				dat += "&#8226;<b>\t[C.real_name]</b>([C.old_job]) : [C.old_key]<br>"
		for(var/datum/showlads_holder/S in showlads_list)
			if(S.job && S.name && S.key)
				dat += "&#8226;<b>\t[S.name]</b>([S.job]) : [S.key]<br>"
		dat += "<br><center><h2><font color='red'>THANATI</font></h2></center>"

		for(var/mob/living/carbon/human/C in mob_list)
			if(C.old_key && C.religion == "Thanati")
				dat += "&#8226;<b>\t[C.real_name]</b>([C.old_job]) : [C.old_key]<br>"
			for(var/datum/showlads_holder/S in showlads_list)
				if(!S.thanati)
					continue
				if(S.job && S.name && S.key)
					dat += "&#8226;<b>\t[S.name]</b>([S.job]) : [S.key]<br>"

	else
		dat += "<center><h2>FIRETHORN VICTIMS</h2></center>"
		for(var/mob/living/carbon/human/H in world)
			if(H.old_key)
				dat += "&#8226;<b>\t[H.real_name]</b>([H.old_job]) : [H.old_key]<br>"
		for(var/datum/showlads_holder/S in showlads_list)
			if(S.name && S.key)
				dat += "&#8226;<b>\t[S.name]</b>([S.job]) : [S.key]<br>"
		dat += "<br><center><h2><font color='red'>THANATI</font></h2></center>"

		for(var/mob/living/carbon/human/C in mob_list)
			if(C.old_key && C.religion == "Thanati")
				dat += "&#8226;<b>\t[C.real_name]</b>([C.old_job]) : [C.old_key]<br>"
		for(var/datum/showlads_holder/S in showlads_list)
			if(!S.thanati)
				continue
			if(S.job && S.name && S.key)
				dat += "&#8226;<b>\t[S.name]</b>([S.job]) : [S.key]<br>"

	src << browse(dat, "window=showlads;size=450x500;can_close=1")

/*
	if(holder)
		for(var/client/C in clients)
			var/entry = "\t[C.key]"
			if(C.holder && C.holder.fakekey)
				entry += " <i>(as [C.holder.fakekey])</i>"
			entry += " - Playing as [C.mob.real_name]"
			switch(C.mob.stat)
				if(UNCONSCIOUS)
					entry += " - <font color='darkgray'><b>Unconscious</b></font>"
				if(DEAD)
					if(isobserver(C.mob))
						var/mob/dead/observer/O = C.mob
						if(O.started_as_observer)
							entry += " - <font color='gray'>Observing</font>"
						else
							entry += " - <font color='black'><b>DEAD</b></font>"
					else
						entry += " - <font color='black'><b>DEAD</b></font>"
			if(is_special_character(C.mob))
				entry += " - <b><font color='red'>Antagonist</font></b>"
			entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
			Lines += entry
	else
		for(var/client/C in clients)
			if(C.holder && C.holder.fakekey)
				Lines += C.holder.fakekey
			else
				Lines += C.key

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	msg += "<b>Total Players: [length(Lines)]</b>"
	src << msg
*/
/*
/client/verb/adminwho()
	set category = "Admin"
	set name = "Adminwho"

	var/msg = ""
	var/num_admins_online = 0
	if(holder)
		for(var/client/C in admins)
			msg += "\t[C] is a [C.holder.rank]"

			if(C.holder.fakekey)
				msg += " <i>(as [C.holder.fakekey])</i>"

			if(isobserver(C.mob))
				msg += " - Observing"
			else if(istype(C.mob,/mob/new_player))
				msg += " - Lobby"
			else
				msg += " - Playing"

			if(C.is_afk())
				msg += " (AFK)"
			msg += "\n"

			num_admins_online++
	else
		for(var/client/C in admins)
			if(!C.holder.fakekey)
				msg += "\t[C] is a [C.holder.rank]\n"
				num_admins_online++

	msg = "<b>Current Admins ([num_admins_online]):</b>\n" + msg
	to_chat(src, msg)
*/
