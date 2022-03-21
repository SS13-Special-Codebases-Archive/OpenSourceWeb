// Segunda tentativa de fazer um sistema para não rodar dbqueries todo login de um cliente.
// Desta vez, as queries só (devem) rodar uma vez por login.

// Second attempt at creating a way to load database info for each client without running dbqueries every single time the same client reconnects.
// This time around, the queries should only run on the first login.

// The lastseen property is intended to only be set once per round.

var/global/list/dbdatums = list()

/datum/dbinfo
	var/first_seen
	var/last_seen
	var/reputation
	var/chromosomes
	var/ckey
	var/bcrypt_hash

/datum/dbinfo/New(client/C)
	ckey = C.ckey
	if(!check_ckey_whitelisted(ckey))
		MakeNewUserEntry()
	SetFirstAndLastSeen()
	LoadFirstAndLastSeeen()
	LoadReputation()
	LoadChromies()
	LoadHash()

/datum/dbinfo/proc/SetFirstAndLastSeen()
	set waitfor = FALSE
	var/DBQuery/first_seen_sql = dbcon.NewQuery("SELECT firstseen FROM playersfarweb WHERE ckey = \"[ckey]\"")
	if(!first_seen_sql.Execute())
		world.log << first_seen_sql.ErrorMsg()
		return
	while(first_seen_sql.NextRow())
		if(first_seen_sql.item[1] == "" || !first_seen_sql.item[1] || first_seen_sql.item[1] == null)
			var/DBQuery/query_seen = dbcon.NewQuery("UPDATE playersfarweb SET firstseen = NOW() WHERE ckey = \"[ckey]\"")
			if(!query_seen.Execute())
				world.log << query_seen.ErrorMsg()
				return
		else
			var/DBQuery/query_last = dbcon.NewQuery("UPDATE playersfarweb SET lastseen = NOW() WHERE ckey = \"[ckey]\"")
			if(!query_last.Execute())
				world.log << query_last.ErrorMsg()
				return

/datum/dbinfo/proc/LoadFirstAndLastSeeen()
	set waitfor = FALSE
	var/DBQuery/set_var = dbcon.NewQuery("SELECT firstseen FROM playersfarweb WHERE ckey = \"[ckey]\"")
	var/DBQuery/set_var2 = dbcon.NewQuery("SELECT lastseen FROM playersfarweb WHERE ckey = \"[ckey]\"")
	if(!set_var.Execute())
		world.log << set_var.ErrorMsg()
		return
	if(!set_var2.Execute())
		world.log << set_var2.ErrorMsg()
		return
	while(set_var.NextRow())
		src.first_seen = set_var.item[1]
	while(set_var2.NextRow())
		src.last_seen = set_var2.item[1]

/datum/dbinfo/proc/LoadReputation()
	set waitfor = FALSE
	var/DBQuery/rep = dbcon.NewQuery("SELECT SUM(value) FROM reputation WHERE ckey = \"[ckey]\"")
	if(!rep.Execute())
		world.log << rep.ErrorMsg()
		return
	while(rep.NextRow())
		src.reputation = text2num(rep.item[1])

/datum/dbinfo/proc/LoadChromies()
	set waitfor = FALSE
	var/DBQuery/chromie = dbcon.NewQuery("SELECT chromosomes FROM playersfarweb WHERE ckey = \"[ckey]\"")
	if(!chromie.Execute())
		world.log << chromie.ErrorMsg()
		return
	while(chromie.NextRow())
		src.chromosomes = text2num(chromie.item[1])

/datum/dbinfo/proc/AdjustChromies(var/value) // use negative values to take away chromosomes
	set waitfor = FALSE
	if(!isnum(value))
		world.log << "Attempted to set chromies for user with an invalid value!"
		return
	async_call(null, "ChromieAdjustDeferred", list(src.ckey, value), src, TRUE)
	src.chromosomes += value

/datum/dbinfo/proc/SetPassword(var/password)
	set waitfor = FALSE
	var/hash = hash_password(password)
	var/DBQuery/passquery = dbcon.NewQuery("UPDATE playersfarweb SET password = \"[hash]\" WHERE ckey = \"[ckey]\"")
	if(!passquery.Execute())
		world.log << passquery.ErrorMsg()
		return 0
	src.bcrypt_hash = hash
	return 1

/datum/dbinfo/proc/LoadHash()
	set waitfor = FALSE
	var/DBQuery/hashquery = dbcon.NewQuery("SELECT password FROM playersfarweb WHERE ckey = \"[ckey]\"")
	if(!hashquery.Execute())
		world.log << hashquery.ErrorMsg()
		return
	while(hashquery.NextRow())
		src.bcrypt_hash = hashquery.item[1]
		return

/datum/dbinfo/proc/VerifyHash(var/password)
	if(verify_password(bcrypt_hash, password) == "True")
		return TRUE
	else
		return FALSE

/datum/dbinfo/proc/MakeNewUserEntry()
	async_call(null, "HubbieInsertDeferred", list(src.ckey), src, TRUE)