
var/global/normal_ooc_colour = "#666699"
/obj/pigforrandy
	icon = 'chat_for_randy.dmi'
	icon_state = "pigforrandy"

/client/verb/ooc(msg as text)
	set name = "OOC" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite
	set category = "OOC"

	if(!mob)	return
	if(IsGuestKey(key))
		src << "Guests may not use OOC."
		return

	msg = sanitize(msg)
	if(!msg)	return


	if(!holder)
		if(silenceofpigs)
			if(comradelist.Find(src.ckey) || villainlist.Find(src.ckey))
				src << "worked"
			else
				to_chat(src, "<span class='hitbold'>Silence, pig!</span>")
				return
		if(!dooc_allowed && (mob.stat == DEAD))
			usr << "\red OOC for dead mobs has been turned off."
			return
		if(prefs.muted & MUTE_OOC)
			src << "\red You cannot use OOC (muted)."
			return
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src,"<span class='highlighttext'><B>Stop right there criminal scum!</B></span>")
			src << 'sound/sound_ahelp_br.ogg'
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return
		if(findtext(msg, "OOC:"))
			to_chat(src, "<span class='highlighttext'><B>Pare de ser carente.</B></span>")
			src << 'sound/sound_ahelp_br.ogg'
			log_admin("[key_name(src)] has attempted to be carente in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to be carente in OOC: [msg]")
			return

	log_ooc("[mob.name]/[key] : [msg]")

	var/display_colour = normal_ooc_colour
	if(!holder)
		if(ckey(src.key) in customooccolorlist)
			display_colour = src.prefs.ooccolor
		else
			display_colour = normal_ooc_colour
	else
		if(ckey(src.key) in customooccolorlist)
			display_colour = src.prefs.ooccolor
		else
			display_colour = normal_ooc_colour
/*	else if(holder)
		display_colour = src.prefs.ooccolor
	else if(src.ckey in ckey(guardianlist))
		display_colour = "#4b02f5"*/
/*	if(holder && !holder.fakekey)
		display_colour = "#666699"	//light blue
		if(holder.rights & R_MOD && !(holder.rights & R_ADMIN))
			display_colour = "#184880"	//dark blue
		if(holder.rights & R_DEBUG && !(holder.rights & R_ADMIN))
			display_colour = "#1b521f"	//dark green
		else if(holder.rights & R_ADMIN)
			if(config.allow_admin_ooccolor)
				display_colour = src.prefs.ooccolor
			else
				display_colour = "#b80000"	//orange
		else if(src.key in villainlist)
			display_colour = "#b00912"
		else if(src.key in comradelist)
			display_colour = "#000a2b"
*/
	msg = emoji_parse(msg)

	if(ticker.current_state == GAME_STATE_PREGAME || ticker.current_state == GAME_STATE_FINISHED || ticker.current_state == GAME_STATE_SETTING_UP)
		for(var/client/C in clients)
			if(C.prefs.toggles & CHAT_OOC)
				var/display_name = src.key
				if(holder)
					if(holder.fakekey)
						if(C.holder)
							display_name = "[holder.fakekey]/([src.key])"
						else
							display_name = holder.fakekey
				//to_chat(C, "<span class='ooc'>OOC: [display_name]: [msg]</span>")
				if(guardianlist.Find(ckey(src.key)))
					to_chat(C, "<span class='oocnew'><font color='[display_colour]'>⚔️<b>OOC: [display_name]: [msg]</b></font></span>")
				else
					to_chat(C, "<span class='oocnew'><font color='[display_colour]'><b>OOC: [display_name]: [msg]</b></font></span>")

	if(ticker.current_state == GAME_STATE_PLAYING)
		for(var/mob/new_player/C in player_list)
			if(C.client.prefs.toggles & CHAT_OOC)
				var/display_name = src.key
				if(guardianlist.Find(ckey(src.key)))
					to_chat(C, "<span class='oocnew'><font color='[display_colour]'>⚔️<b>LOBBY: [display_name]: [msg]</b></font></span>")
				else
					to_chat(C, "<span class='oocnew'><font color='[display_colour]'><b>LOBBY: [display_name]: [msg]</b></font></span>")
/*
			if(!C.prefs.nameglow)
				if(display_name == "ThuxTK")
					to_chat(C, "<span class='thuxooc'>[icon2html(a, C)]<b>OOC: [display_name]: [msg]</b></span>")
				else
					if(display_name == "Aedaris" || display_name == "Comicao1")
						to_chat(C, "<span class='glowooc'><font color='[display_colour]'>ᛋᛋ <b>OOC: [display_name]: [msg]</b></font></span>")
					else
						if(display_name == "Nopm2")
							to_chat(C, "<span class='glowooc'><font color='[display_colour]'>👺👹<b>OOC: [display_name]: [msg]</b></font></span>")
						else
							if(display_name == "John_egbert3" || display_name == "Torne saien")
								to_chat(C, "<span class='glowooc'><font color='[display_colour]'>ඞ<b>OOC: [display_name]: [msg]</b></font></span>")
							else
								to_chat(C, "<span class='glowooc'><font color='[display_colour]'><b>OOC: [display_name]: [msg]</b></font></span>")
			else
				if(display_name == "ThuxTK")
					to_chat(C, "<span class='thuxooc'>[icon2html(a, C)]<b>OOC: [display_name]: [msg]</b></span>")
				else
					if(display_name == "Aedaris" || display_name == "Comicao1")
						to_chat(C, "<span class='glowooc'><font color='[display_colour]'>ᛋᛋ <b>OOC: [display_name]: [msg]</b></font></span>")
					else
						if(display_name == "Nopm2")
							to_chat(C, "<span class='glowooc'><font color='[display_colour]'>👺👹<b>OOC: [display_name]: [msg]</b></font></span>")
						else
							if(display_name == "John_egbert3" || display_name == "Torne saien")
								to_chat(C, "<span class='glowooc'><font color='[display_colour]'>ඞ<b>OOC: [display_name]: [msg]</b></font></span>")
							else
								to_chat(C, "<span class='glowooc'><font color='[display_colour]'><b>OOC: [display_name]: [msg]</b></font></span>")
*/
									/*
			if(holder)
				if(!holder.fakekey || C.holder)
					if(holder.rights & R_ADMIN)
						C << "<font color=[config.allow_admin_ooccolor ? src.prefs.ooccolor :"#b82e00" ]><b><span class='prefix'>OOC:</span> <EM>[key][holder.fakekey ? "/([holder.fakekey])" : ""]:</EM> <span class='message'>[msg]</span></b></font>"
					else if(holder.rights & R_MOD)
						C << "<font color=#184880><b><span class='prefix'>OOC:</span> <EM>[src.key][holder.fakekey ? "/([holder.fakekey])" : ""]:</EM> <span class='message'>[msg]</span></b></font>"
					else
						C << "<font color='[normal_ooc_colour]'><span class='ooc'><span class='prefix'>OOC:</span> <EM>[src.key]:</EM> <span class='message'>[msg]</span></span></font>"

				else
					C << "<font color='[normal_ooc_colour]'><span class='ooc'><span class='prefix'>OOC:</span> <EM>[holder.fakekey ? holder.fakekey : src.key]:</EM> <span class='message'>[msg]</span></span></font>"
			else
				C << "<font color='[normal_ooc_colour]'><span class='ooc'><span class='prefix'>OOC:</span> <EM>[src.key]:</EM> <span class='message'>[msg]</span></span></font>"
			*/

/client/proc/set_ooc(newColor as color)
	set name = "Set Player OOC Colour"
	set desc = "Set to yellow for eye burning goodness."
	set category = "Fun"
	normal_ooc_colour = newColor