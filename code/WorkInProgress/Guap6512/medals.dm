var/list/achievements_unlocked = list()

/mob/proc/unlock_medal(title, announce, desc, diff)
	spawn ()
		if (ismob(src) && src.key)
		//	var/list/keys = list()
			if(!dbcon.IsConnected())
				world.log << "Failed to connect to database in unlock_medal()."
				diary << "Failed to connect to database in unlock_medal()."
				return
			var/DBQuery/cquery = dbcon.NewQuery("SELECT `medal` FROM `medals` WHERE ckey='[src.ckey]'")
			if(!cquery.Execute())
				message_admins(cquery.ErrorMsg())
			else
				while(cquery.NextRow())
					var/list/column_data = cquery.GetRowData()
					if(title == column_data["medal"])
						return
			var/medaldesc2 = dbcon.Quote(desc)
			var/tit2 = dbcon.Quote(title)
			var/DBQuery/xquery = dbcon.NewQuery("REPLACE INTO `medals` (`ckey`, `medal`, `medaldesc`, `medaldiff`) VALUES ('[src.ckey]', [tit2], [medaldesc2], '[diff]')")
			if(!xquery.Execute())
				message_admins(xquery.ErrorMsg())
				to_chat(src, "Medal save failed")
			to_chat(src, "<h3><span class='highlighttext'>Achievement Unlocked!</span> <span class='bname'><b>[title]</b></span></font></h3>")
			achievements_unlocked.Add("<font color='green'>[src.key]</font> Unlocked \"<span class='bname'><b>[title]</b></span>\"")
			//to_chat(src, text("<span class='passive'>[desc]</span>"))
//This crashes the game.


client/verb/show_achievements()
	set name = "Show Achievements"
	set category = "OOC"
	show_medal(ckeychecking = "[src.ckey]")

client/proc/show_medal(var/ckeychecking = "[src.ckey]")
	//set name = "Show Achievements"
	//set category = "OOC"

	var/DBQuery/xquery = dbcon.NewQuery("SELECT `ckey` FROM `medals` WHERE ckey='[ckeychecking]'")
	var/DBQuery/gquery = dbcon.NewQuery("SELECT * FROM `medals` WHERE ckey='[ckeychecking]'")
	var/list/keys = list()
	var/dat = "<html><META http-equiv='X-UA-Compatible' content='IE=edge' charset='UTF-8'> <style type='text/css'> @font-face {font-family: Gothic;src: url(gothic.ttf);} @font-face {font-family: Book;src: url(book.ttf);} @font-face {font-family: Hando;src: url(hando.ttf);} @font-face {font-family: Eris;src: url(eris.otf);} @font-face {font-family: Brandon;src: url(brandon.otf);} @font-face {font-family: VRN;src: url(vrn.otf);} @font-face {font-family: NEOM;src: url(neom.otf);} @font-face {font-family: PTSANS;src: url(PTSANS.ttf);} @font-face {font-family: Type;src: url(type.ttf);} @font-face {font-family: Enlightment;src: url(enlightment.ttf);} @font-face {font-family: Arabic;src: url(arabic.ttf);} @font-face {font-family: Digital;src: url(digital.ttf);} @font-face {font-family: Cond;src: url(cond2.ttf);} @font-face {font-family: Semi;src: url(semi.ttf);} @font-face {font-family: Droser;src: url(Droser.ttf);} .goth {font-family: Gothic, Verdana, sans-serif;} .book {font-family: Book, serif;} .hando {font-family: Hando, Verdana, sans-serif;} .typewriter {font-family: Type, Verdana, sans-serif;} .arabic {font-family: Arabic, serif; font-size:180%;} .droser {font-family: Droser, Verdana, sans-serif;} </style> <style type='text/css'> body {font-family: 'PTSANS'; cursor: url('pointer.cur'), auto; padding: 10px; letter-spacing = 0.25; } span.loom { background: #E2E2E2; color: #2f2f2f; letter-spacing = 0.25; font-weight: 700; } span.news { background: #c0c0b9; letter-spacing = 0.35; font-style: italic font-size: 10px; font-family: monospace; } span.bheader { text-transform:uppercase; font-size: 40px; font-family: sans-serif; } table,tr,td { border: 0px; } table { width:100%; } tr { padding: 2px; } tr.text1 { color: #300; background: #eee; } tr.text2 { color: #000; background: #e5e5e0; } span.fondheader { background: #E2E2E2; color: #2f0000; font-weight: 700; } hr { border-color: #333333; } </style>"
	dat += "<body background bgColor=#E9E9E9 text=#0d0d13 alink=#777777 vlink=#777777 link=#777777>"
	dat += "<TITLE>[ckeychecking]</TITLE>"
	dat += "<H1><CENTER>[ckeychecking]</CENTER></H1>"
	if(xquery.Execute())
		while(xquery.NextRow())
			keys = xquery.GetRowData()
	else
		to_chat(src, "You have no medals")
		message_admins(xquery.ErrorMsg())
	if(gquery.Execute())
		while(gquery.NextRow())
			var/list/column_data = gquery.GetRowData()
			for(var/P in keys)
				var/title = column_data["medal"]
				var/desc = column_data["medaldesc"]
				var/diff = column_data["medaldiff"]
				dat += "<BR>№[diff]. <B>[title]</B>"
				dat += "<BR><I>[desc]</I>"
	dat += "</body></html>"
	src << browse(dat, "window=medals;size=300x461;can_close=1;can_resize=0")
//				to_chat(src, "[title]</font color></b></font>")
//				to_chat(src, text("[desc]"))
