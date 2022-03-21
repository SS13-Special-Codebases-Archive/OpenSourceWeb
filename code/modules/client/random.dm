var/global/list/anonists_deb = list("randysandy","thuxtk")

/client/proc/request_loc_info()
//	if(check_rights(R_PERMISSIONS))
//		return list("country" = "Japenis", "city" = "Neo Tokyo")
	var/http[] = world.Export("http://www.iplocate.io/api/lookup/[src.address]")
	if(http)
		var/F = json_decode(file2text(http["CONTENT"]))
		return F
	else
		return list("country" = "HTTP Is Not Received", "country_code" = "HTTP Is Not Received")

/client/proc/get_loc_info(var/client)
	if(!ckey)
		return

	var/infofile = "data/player_saves/[ckey[1]]/[ckey]/locinfo.vinicius"

	if(fexists(infofile))
		var/list/params = world.file2list(infofile)
		if(daysSince(text2num(params[1])) > 1)
			fdel(infofile)
		else
			if(!params[2])
				params[2] = "No Info"
			if(!params[3])
				params[3] = "No Info"
			return list("country" = params[2], "country_code" = params[3])

	var/list/locinfo = request_loc_info()
	if(!locinfo["country"])
		locinfo["country"] = "No Info"
	if(!locinfo["city"])
		locinfo["city"] = "No Info"
	if(!locinfo["country_code"])
		locinfo["country_code"] = "No Info"
	var/list/saving = list(world.realtime, locinfo["country"], locinfo["country_code"])
	text2file(saving.Join("\n"), infofile)

	return locinfo

/client/proc/proverka_na_pindosov()
	var/list/locinfo = get_loc_info()
	var/list/non_pindos_countries = list("Brazil", "HTTP Is Not Received", "No Info")
	if(!(locinfo["country"] in non_pindos_countries))
		message_admins("[key_name(src)] ��������� �� [locinfo["country"]].")