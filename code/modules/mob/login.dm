//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
/mob/proc/update_Login_details()
	//Multikey checks and logging
	lastKnownIP	= client.address
	computer_id	= client.computer_id
	log_access("Login: [key_name(src)] from [lastKnownIP ? lastKnownIP : "localhost"]-[computer_id] || BYOND v[client.byond_version]")
	if(config.log_access)
		for(var/mob/M in player_list)
			if(M == src)	continue
			if( M.key && (M.key != key) )
				var/matches
				if( (M.lastKnownIP == client.address) )
					matches += "IP ([client.address])"
				if( (M.computer_id == client.computer_id) )
					if(matches)	matches += " and "
					matches += "ID ([client.computer_id])"
					spawn() alert("You have logged in already with another key this round, please log out of this one NOW or risk being banned!")
				if(matches)
					if(M.client)
						message_admins("<font color='red'><B>Notice: </B><font color='blue'><A href='?src=\ref[usr];priv_msg=\ref[src]'>[key_name_admin(src)]</A> has the same [matches] as <A href='?src=\ref[usr];priv_msg=\ref[M]'>[key_name_admin(M)]</A>.</font>", 1)
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)].")
					else
						message_admins("<font color='red'><B>Notice: </B><font color='blue'><A href='?src=\ref[usr];priv_msg=\ref[src]'>[key_name_admin(src)]</A> has the same [matches] as [key_name_admin(M)] (no longer logged in). </font>", 1)
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)] (no longer logged in).")

/mob/Login()
#ifdef FARWEB_LIVE
	if(client.info.bcrypt_hash == "" || client.info.bcrypt_hash == null || !client.info.bcrypt_hash)
		var/passcheck = input(src, "You don't have a password set. Type in a proper password. Wacky passwords such as '123' will cause you to lose access to the game, use your brain cells.")
		var/passcheck2 = input(src, "Confirm the password.")
		if(passcheck != passcheck2)
			alert(src, "The passwords don't match. Due to a BYOND limitation, you will have to reconnect in order to try again.", "Farweb")
			del(client)
			return
		else
			client.info.SetPassword(passcheck)
			alert(src, "Your password has been set, and it will be asked of you the next time you reconnect. If you forget it, contact one of the Patriarchs.", "Farweb")
			client.authenticated = TRUE
	else
		if(client.authenticated == FALSE)
			var/passcheck = input(src, "Type in your password.")
			if(client.info.VerifyHash(passcheck) == FALSE)
				alert(src, "The password you typed is incorrect. You will be disconnected, reconnect to try again.", "Farweb")
				del(client)
				return
			else
				client.authenticated = TRUE
	if(client.authenticated == TRUE)
		client.chatOutput.start()
#endif
	player_list |= src
	winset(src, null, "mainwindow.title='[vessel_name()]'")
	update_Login_details()
	world.update_status()

	client.images = null				//remove the images such as AIs being unable to see runes
	client.screen = null				//remove hud items just in case
	if(hud_used)	qdel(hud_used)		//remove the hud objects
	hud_used = new /datum/hud(src)

	next_move = 1
	sight |= SEE_SELF
	..()

	if(loc && !isturf(loc))
		client.eye = loc
		client.perspective = EYE_PERSPECTIVE
	else
		client.eye = src
		client.perspective = MOB_PERSPECTIVE

	//Clear ability list and update from mob.
	client.verbs -= ability_verbs

	if(habilities)
		client.verbs |= habilities

	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		if(H.species && H.species.abilities)
			client.verbs |= H.species.abilities
	src.add_filter_effects()
	updatePig()
	hud_used?.add_inventory_overlay()
	winset(src, "name", "text='[real_name]'")
	//bug blur effect, para ativar por completo tira os comentario do Turfs.dm