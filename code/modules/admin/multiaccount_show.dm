/client/proc/checkAccount()
	set name = "Check multiaccounts"
	set category = "Admin"
	var/target = input(usr, "Напечатайте ckey, который нужно проверить.", "Ckey") as text|null
	if(!target) //Cancel теперь работает
		return
	showAccounts(src, target)

/proc/showAccounts(var/mob/user, var/targetkey)

	var/output = "<center><table border='1'> <caption>Совпадение по computerID</caption><tr> <th width='100px' >ckey</th><th width='100px'>firstseen</th><th width='100px'>lastseen</th><th width='100px'>ip</th><th width='100px'>computerid </th></tr>"

	var/DBQuery/query = dbcon.NewQuery("SELECT ckey,firstseen,lastseen,ip,computerid FROM erro_player WHERE computerid IN (SELECT DISTINCT computerid FROM erro_player WHERE ckey LIKE '[targetkey]')")
	query.Execute()
	while(query.NextRow())
		output+="<tr><td>[query.item[1]]</td>"
		output+="<td>[query.item[2]]</td>"
		output+="<td>[query.item[3]]</td>"
		output+="<td>[query.item[4]]</td>"
		output+="<td>[query.item[5]]</td></tr>"

	output+="</table>"

	output += "<center><table border='1'> <caption>Совпадение по IP</caption><tr> <th width='100px' >ckey</th><th width='100px'>firstseen</th><th width='100px'>lastseen</th><th width='100px'>ip</th><th width='100px'>computerid </th></tr>"

	query = dbcon.NewQuery("SELECT ckey,firstseen,lastseen,ip,computerid FROM erro_player WHERE ip IN (SELECT DISTINCT ip FROM erro_player WHERE computerid IN (SELECT DISTINCT computerid FROM erro_player WHERE ckey LIKE '[targetkey]'))")
	query.Execute()
	while(query.NextRow())
		output+="<tr><td>[query.item[1]]</td>"
		output+="<td>[query.item[2]]</td>"
		output+="<td>[query.item[3]]</td>"
		output+="<td>[query.item[4]]</td>"
		output+="<td>[query.item[5]]</td></tr>"

	output+="</table></center>"

	user << browse(output, "window=accaunts;size=600x400")