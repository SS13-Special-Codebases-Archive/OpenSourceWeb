#define CKEYWHITELIST "config/ckey_whitelist.txt"

var/global/list/ckeywhitelistweb = list()

var/global/private_party = 1

var/global/list/proxyignore = list("nolafregit","randysandy","hydrated12","grifferman", "asdor","darkinfected", "demkova", "ltkoepple", "cheesewithpepsi","rarebirbwithtumors")

var/global/list/comradelist = list("comicao1","thuxtk","aregrued")

var/global/list/villainlist = list()

var/global/list/pigpluslist = list("tw789")

var/global/list/guardianlist = list("guymallory","riotmigrant")

var/global/list/hasinvited = list()

var/global/list/bans = list()

/proc/load_ckey_whitelist()
	ckeywhitelistweb = list()
	var/list/Lines = file2list(CKEYWHITELIST)
	for(var/line in Lines)
		if(!length(line))
			continue

		var/ascii = text2ascii(line,1)

		if(copytext(line,1,2) == "#" || ascii == 9 || ascii == 32)//# space or tab
			continue

		ckeywhitelistweb.Add(ckey(line))

	if(!ckeywhitelistweb.len)
		ckeywhitelistweb = null

/proc/check_ckey_whitelisted(var/ckey)
	return (ckeywhitelistweb && (ckey in ckeywhitelistweb) )



/proc/load_db_whitelist()
	set waitfor = FALSE
	var/DBQuery/query = dbcon.NewQuery("SELECT ckey FROM playersfarweb;")
	if(!query.Execute())
		world.log << query.ErrorMsg()
		return
	while(query.NextRow())
		ckeywhitelistweb.Add(query.item[1])

/proc/load_db_bans()
	set waitfor = FALSE
	var/DBQuery/query = dbcon.NewQuery("SELECT ckey FROM bansfarweb WHERE isbanned = 1;")
	if(!query.Execute())
		world.log << query.ErrorMsg()
		return
	while(query.NextRow())
		bans.Add(query.item[1])

/proc/unban_bob()
	set waitfor = FALSE
	bans.Remove("ChaoticAgent")
	var/DBQuery/query = dbcon.NewQuery("UPDATE bansfarweb SET isbanned = 0 WHERE ckey = \"ChaoticAgent\"")
	if(!query.Execute())
		world.log << query.ErrorMsg()
		return

/proc/get_story_id()
	set waitfor = FALSE
	var/DBQuery/query = dbcon.NewQuery("SELECT storyid FROM stories;")
	if(!query.Execute())
		world.log << query.ErrorMsg()
		return
	while(query.NextRow())
		story_id = query.item[1]
		story_id = text2num(story_id)
	story_id = story_id + 1
	add_story_id()


/proc/add_story_id()
	set waitfor = FALSE
	var/DBQuery/queryInsert = dbcon.NewQuery("UPDATE stories SET storyid =[story_id];")
	if(!queryInsert.Execute())
		world.log << queryInsert.ErrorMsg()
		queryInsert.Close()
		return

/proc/load_invitations()
	var/list/Lines = file2list("config/invitesystem/hasinvited.txt")
	for(var/line in Lines)
		if(!length(line))
			continue

		var/ascii = text2ascii(line,1)

		if(copytext(line,1,2) == "#" || ascii == 9 || ascii == 32)
			continue

		hasinvited.Add(ckey(line))

/proc/load_comrade_list()
	set waitfor = FALSE
	var/DBQuery/query = dbcon.NewQuery("SELECT ckey FROM comradelist;")
	if(!query.Execute())
		world.log << query.ErrorMsg()
		return
	while(query.NextRow())
		comradelist.Add(query.item[1])

/proc/load_pigplus_list()
	set waitfor = FALSE
	var/DBQuery/query = dbcon.NewQuery("SELECT ckey FROM pigpluslist;")
	if(!query.Execute())
		world.log << query.ErrorMsg()
		return
	while(query.NextRow())
		pigpluslist.Add(query.item[1])

/proc/load_villain_list()
	set waitfor = FALSE
	var/DBQuery/query = dbcon.NewQuery("SELECT ckey FROM villainlist;")
	if(!query.Execute())
		world.log << query.ErrorMsg()
		return
	while(query.NextRow())
		villainlist.Add(query.item[1])

client/proc/load_registered_by()
	set waitfor = FALSE
	var/DBQuery/query = dbcon.NewQuery("SELECT invitedby FROM playersfarweb WHERE ckey = \"[ckey]\";")
	if(!query.Execute())
		world.log << query.ErrorMsg()
		return
	while(query.NextRow())
		InvitedBy = query.item[1]
		//query.Close()
		//return

/proc/has_invited(var/ckey)
	return (hasinvited && (ckey in hasinvited))

/proc/loadFateLocks()
	if(!config.usefatelocks)
		return
	var/list/fates = job_master.occupations
	var/fatelock_list = file2list("config/fatelocks.txt")
	for(var/L in fatelock_list)
		if(!length(L))				continue
		if(copytext(L,1,2) == "#")	continue

		var/list/List = text2list(L,"+")
		if(!List.len)					continue

		var/temp_fate = ckey(List[1])
		var/datum/job/current_fate
		for(var/datum/job/D in fates)
			var/name = ckey(D.title)
			if(name == temp_fate)
				current_fate = D
				break

		if(!current_fate)
			continue

		for(var/i=2, i<=List.len, i++)
			switch(ckey(List[i]))
				if("pigplus")	current_fate.job_whitelisted |= PIGPLUS
				if("comrade")	current_fate.job_whitelisted |= COMRADE
				if("villain") 	current_fate.job_whitelisted |= VILLAIN

#undef CKEYWHITELIST

proc/stickyban(var/key)
	world.SetConfig("ban",ckey(key),"type=sticky;message=God be saved!;")
proc/remove_stickyban(var/key)
	world.SetConfig("ban",ckey(key),null)

