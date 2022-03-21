client/proc/invite_ckey()
	var/invitee = input("Input the user's ckey. Double check if it's correct.", "Farweb")
	var/age = input("Enter their age (minimum is 18)", "Farweb")
	if(text2num(age) < 18)
		to_chat(usr, "<span class='highlighttext'>They're too young.</span>")
		return
	age = "[invitee] age:[age] \n\n"
	var/details = input("Fill this form and send it, 156 character limit", "Farweb", "Why are they interested in Farweb and will become an active and interesting player?") as message
	var/reason = age
	reason += details
	if(length(reason) <= 99 || length(reason) >= 255)
		if(!holder)
			to_chat(usr, "<span class='highlighttext'>Reason is too long or too short.</span>")
			return
	var/DBQuery/queryInvites = dbcon.NewQuery("SELECT invitecount FROM playersfarweb WHERE ckey = \"[usr.ckey]\";")
	if(!queryInvites.Execute())
		world.log << queryInvites.ErrorMsg()
		return
	while(queryInvites.NextRow())
		if(text2num(queryInvites.item[1]) >= MAX_COMRADE_INVITES && !usr.client.holder && !(usr.ckey == SECRET_GUARDIAN))
			to_chat(usr, "<span class='highlighttext'>You've spent all your invites.</span>")
			queryInvites.Close()
			return
	queryInvites.Close()
	if((ckey(invitee) in ckeywhitelistweb))
		to_chat(usr, "<span class='highlighttext'>You can't invite someone who's already invited.</span>")
		return
	if(findtext(invitee,"\n"))
		to_chat(usr, "<span class='highlighttext'>Linebreaks are NOT allowed.</span>")
		return
	if(length(invitee) <= 1 || length(invitee) > 30)
		to_chat(usr, "<span class='highlighttext'>This CKEY is invalid.</span>")
		return
	var/DISPLAY_NAME = TRUE
	if(holder)
		var/togglename = input("DISPLAY YOUR NAME?","Confirmation") in list ("No","Yes")
		if(togglename == "Yes")
			DISPLAY_NAME = TRUE
		else
			DISPLAY_NAME = FALSE
	if(DISPLAY_NAME)
		var/confirmation = input("You will invite [invitee]. Are you sure?","Confirmation") in list ("Yes","No")
		if(confirmation == "Yes")
			var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO playersfarweb (ckey, invitedby, reason) VALUES (\"[ckey(invitee)]\", \"[ckey(usr.key)]\", \"[reason]\")")
			if(!queryInsert.Execute())
				world.log << queryInsert.ErrorMsg()
				queryInsert.Close()
				return
			queryInsert.Close()
			var/DBQuery/queryIncreaseInvite = dbcon.NewQuery("UPDATE playersfarweb SET invitecount = invitecount + 1 WHERE ckey = \"[usr.ckey]\"")
			if(!queryIncreaseInvite.Execute())
				world.log << queryIncreaseInvite.ErrorMsg()
				queryIncreaseInvite.Close()
				return
			queryIncreaseInvite.Close()
			ckeywhitelistweb.Add(ckey(invitee))
			to_chat(usr, "<span class='highlighttext'>[invitee] has been invited.</span>")
			usr << 'thanet.ogg'
			var/inviteez = "`[invitee] has been invited by [usr.ckey]` [reason]"
			HttpPost("https://discord.com/api/webhooks/809920414796349440/mZWJvl9vTmVUYaiq-nLGESFoIkkDV58xCGqD1rZWpfS-qBG55bcf9n_s95Rarw8EJ_vi",list(content = inviteez,username = usr.ckey))
			return
	else
		var/confirmation = input("You will invite [invitee]. Are you sure?","Confirmation") in list ("Yes","No")
		if(confirmation == "Yes")
			var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO playersfarweb (ckey, reason) VALUES (\"[ckey(invitee)]\", \"[reason]\")")
			if(!queryInsert.Execute())
				world.log << queryInsert.ErrorMsg()
				queryInsert.Close()
				return
			queryInsert.Close()
			var/DBQuery/queryIncreaseInvite = dbcon.NewQuery("UPDATE playersfarweb SET invitecount = invitecount + 1 WHERE ckey = \"[usr.ckey]\"")
			if(!queryIncreaseInvite.Execute())
				world.log << queryIncreaseInvite.ErrorMsg()
				queryIncreaseInvite.Close()
				return
			queryIncreaseInvite.Close()
			ckeywhitelistweb.Add(ckey(invitee))
			to_chat(usr, "<span class='highlighttext'>[invitee] has been invited.</span>")
			usr << 'thanet.ogg'
			var/inviteez = "`[invitee] has been invited by [usr.ckey]` [reason]"
			HttpPost("https://discord.com/api/webhooks/809920414796349440/mZWJvl9vTmVUYaiq-nLGESFoIkkDV58xCGqD1rZWpfS-qBG55bcf9n_s95Rarw8EJ_vi",list(content = inviteez,username = usr.ckey))
			return


client/proc/remove_whitelist()
	var/ckeyy = ckey(input("Who do you want to ban?", "Farweb")) as null|text
	var/reason = input("Why are you doing this for?", "Farweb") as null|message
	var/DBQuery/query = dbcon.NewQuery("INSERT INTO bansfarweb (ckey, reason, adminckey, isbanned) VALUES (\"[ckeyy]\", \"[reason]\", \"[usr.ckey]\", \"1\")")
	if(!query.Execute())
		world.log << query.ErrorMsg()
		return
	to_chat(usr, "<span class='highlighttext'>[ckeyy] has been banned.</span>")
	bans.Add(ckeyy)
	switch(alert("Apply a stickyban?",,"Yes","No"))
		if("Yes")
			stickyban(ckeyy)
	if(do_discord_ban(ckeyy) == "False")
		to_chat(usr, "<span class='highlighttext'>Unable to remove Discord role for user. Perhaps they never joined.</span>")
	var/banz = "`[ckeyy] has been banned by [usr.ckey]` [reason]"
	HttpPost("https://discord.com/api/webhooks/809920414796349440/mZWJvl9vTmVUYaiq-nLGESFoIkkDV58xCGqD1rZWpfS-qBG55bcf9n_s95Rarw8EJ_vi",list(content = banz,username = usr.ckey))
	return

client/proc/game_remove_whitelist(var/reason = "", var/stickyban = TRUE) // Used for setting bans in the code
	var/DBQuery/query = dbcon.NewQuery("INSERT INTO bansfarweb (ckey, reason, adminckey, isbanned) VALUES (\"[ckey]\", \"[reason]\", \"Automatic Ban\", \"1\")")
	if(!query.Execute())
		world.log << query.ErrorMsg()
		return
	bans.Add(ckey)
	if(stickyban)
		stickyban(ckey)
	var/banz = "`[ckey] has been banned by the server` [reason]"
	HttpPost("https://discord.com/api/webhooks/809920414796349440/mZWJvl9vTmVUYaiq-nLGESFoIkkDV58xCGqD1rZWpfS-qBG55bcf9n_s95Rarw8EJ_vi",list(content = banz,username = "Automated tyranny"))
	return

/proc/remove_ban()
    var/list/current_bans = list()
    var/DBQuery/bandb = dbcon.NewQuery("SELECT ckey FROM bansfarweb WHERE isbanned = 1;")
    if(!bandb.Execute())
        world.log << bandb.ErrorMsg()
        return
    while(bandb.NextRow())
        current_bans.Add(bandb.item[1])
    var/ckey = input(usr, "Which ckey do you want to unban?", "Farweb") as null|anything in current_bans
    var/DBQuery/banset = dbcon.NewQuery("UPDATE bansfarweb SET isbanned = 0 WHERE ckey = \"[ckey]\"")
    if(!banset.Execute())
        world.log << banset.ErrorMsg()
        return
    bans.Remove(ckey)
    remove_stickyban(ckey)
    to_chat(usr, "<span class='highlighttext'>[ckey] has been unbanned.</span>")
    return

/proc/add_comrade()
    var/ckey = ckey(input("Type the user's ckey", "Farweb"))
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    if(ckey in comradelist)
        to_chat(usr, "<span class='highlighttext'>This user is already a comrade.</span>")
        return
    var/DBQuery/query = dbcon.NewQuery("INSERT INTO comradelist (ckey) VALUES (\"[ckey]\")")
    if(!query.Execute())
        world.log << query.ErrorMsg()
        return
    comradelist.Add(ckey)
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added as a comrade.")
    return

/proc/add_pigplus()
    var/ckey = ckey(input("Type the user's ckey", "Farweb"))
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    if(ckey in pigpluslist)
        to_chat(usr, "<span class='highlighttext'>This user is already a pig+.</span>")
        return
    var/DBQuery/query = dbcon.NewQuery("INSERT INTO pigpluslist (ckey) VALUES (\"[ckey]\")")
    if(!query.Execute())
        world.log << query.ErrorMsg()
        return
    pigpluslist.Add(ckey)
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added as a pig+.")
    return

/proc/add_villain()
    var/ckey = ckey(input("Type the user's ckey", "Farweb"))
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    if(ckey in villainlist)
        to_chat(usr, "<span class='highlighttext'>This user is already a villain.</span>")
        return
    var/DBQuery/query = dbcon.NewQuery("INSERT INTO villainlist (ckey) VALUES (\"[ckey]\")")
    if(!query.Execute())
        world.log << query.ErrorMsg()
        return
    villainlist.Add(ckey)
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added as a villain.")
    return

/proc/remove_villain()
    var/list/current_villains = list()
    var/DBQuery/bandb = dbcon.NewQuery("SELECT ckey FROM villainlist;")
    if(!bandb.Execute())
        world.log << bandb.ErrorMsg()
        return
    while(bandb.NextRow())
        current_villains.Add(bandb.item[1])
    var/ckey = input(usr, "Which ckey do you want to remove ranking?", "Farweb") as null|anything in current_villains
    var/DBQuery/banset = dbcon.NewQuery("DELETE FROM villainlist WHERE ckey = \"[ckey]\"")
    if(!banset.Execute())
        world.log << banset.ErrorMsg()
        return
    villainlist.Remove(ckey)
    to_chat(usr, "<span class='highlighttext'>[ckey] has been removed from the villain list.</span>")
    return

/proc/remove_comrade()
    var/list/current_comrades = list()
    var/DBQuery/bandb = dbcon.NewQuery("SELECT ckey FROM comradelist;")
    if(!bandb.Execute())
        world.log << bandb.ErrorMsg()
        return
    while(bandb.NextRow())
        current_comrades.Add(bandb.item[1])
    var/ckey = input(usr, "Which ckey do you want to remove ranking?", "Farweb") as null|anything in current_comrades
    var/DBQuery/banset = dbcon.NewQuery("DELETE FROM comradelist WHERE ckey = \"[ckey]\"")
    if(!banset.Execute())
        world.log << banset.ErrorMsg()
        return
    comradelist.Remove(ckey)
    to_chat(usr, "<span class='highlighttext'>[ckey] has been removed from the comrade list.</span>")
    return

/proc/remove_pigplus()
    var/list/current_pigs = list()
    var/DBQuery/bandb = dbcon.NewQuery("SELECT ckey FROM pigpluslist;")
    if(!bandb.Execute())
        world.log << bandb.ErrorMsg()
        return
    while(bandb.NextRow())
        current_pigs.Add(bandb.item[1])
    var/ckey = input(usr, "Which ckey do you want to remove ranking?", "Farweb") as null|anything in current_pigs
    var/DBQuery/banset = dbcon.NewQuery("DELETE FROM pigpluslist WHERE ckey = \"[ckey]\"")
    if(!banset.Execute())
        world.log << banset.ErrorMsg()
        return
    pigpluslist.Remove(ckey)
    to_chat(usr, "<span class='highlighttext'>[ckey] has been removed from the pig plus list.</span>")
    return