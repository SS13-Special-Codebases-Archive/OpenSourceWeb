//admin verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless
var/list/admin_verbs_default = list(
	/datum/admins/proc/show_player_panel,	/*shows an interface for individual players, with various links (links require additional flags*/
	/client/proc/deadmin_self,			/*destroys our own admin datum so we can play as a regular player*/
	/client/proc/hide_verbs,			/*hides all our adminverbs*/
	/client/proc/hide_stats,
	/client/proc/hide_most_verbs,		/*hides all our hideable adminverbs*/
	/client/proc/debug_variables,		/*allows us to -see- the variables of any instance in the game. +VAREDIT needed to modify*/
	/client/proc/check_antagonists,		/*shows all antags*/
	/client/proc/display_admin_reports,
	/client/proc/cmd_admin_say			/*admin-only ooc chat*/
	)
var/list/admin_verbs_admin = list(
	/client/proc/player_panel,			/*shows an interface for all players, with links to various panels (old style)*/
	/client/proc/player_panel_new,		/*shows an interface for all players, with links to various panels*/
	/client/proc/invisimin,				/*allows our mob to go invisible/visible*/
	/client/proc/toggle_asay_log,
	/datum/admins/proc/toggleenter,		/*toggles whether people can join the current game*/
	/datum/admins/proc/toggleguests,	/*toggles whether guests can join the current game*/
	/datum/admins/proc/announce,		/*priority announce something to all clients.*/
	/client/proc/colorooc,				/*allows us to set a custom colour for everythign we say in ooc*/
	/client/proc/admin_ghost,			/*allows us to ghost/reenter body at will*/
	/client/proc/toggle_view_range,		/*changes how far we can see*/
	/datum/admins/proc/view_txt_log,	/*shows the server log (diary) for today*/
	/datum/admins/proc/view_atk_log,	/*shows the server combat-log, doesn't do anything presently*/
	/client/proc/cmd_admin_pm_context,	/*right-click adminPM interface*/
	/client/proc/cmd_admin_pm_panel,	/*admin-pm list*/
	/client/proc/cmd_admin_subtle_message,	/*send an message to somebody as a 'voice in their head'*/
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_admin_check_contents,	/*displays the contents of an instance*/
	/datum/admins/proc/access_news_network,	/*allows access of newscasters*/
	/client/proc/jumptocoord,			/*we ghost and jump to a coordinate*/
	/client/proc/Getmob,				/*teleports a mob to our location*/
	/client/proc/Getkey,				/*teleports a mob with a certain ckey to our location*/
	/client/proc/Jump,
	/client/proc/jumptokey,				/*allows us to jump to the location of a mob with a certain ckey*/
	/client/proc/jumptomob,				/*allows us to jump to a specific mob*/
	/client/proc/jumptoturf,			/*allows us to jump to a specific turf*/
	/client/proc/admin_call_shuttle,	/*allows us to call the emergency shuttle*/
	/client/proc/admin_cancel_shuttle,	/*allows us to cancel the emergency shuttle, sending it back to centcomm*/
	/client/proc/cmd_admin_direct_narrate,	/*send text directly to a player with no padding. Useful for narratives and fluff-text*/
	/client/proc/cmd_admin_world_narrate,	/*sends text to all players with no padding*/
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/check_words,			/*displays cult-words*/
	/client/proc/check_ai_laws,			/*shows AI and borg laws*/
	/client/proc/admin_memo,			/*admin memo system. show/delete/write. +SERVER needed to delete admin memos of others*/
	/client/proc/dsay,					/*talk in deadchat using our ckey/fakekey*/
	/client/proc/investigate_show,		/*various admintools for investigation. Such as a singulo grief-log*/
	/client/proc/secrets,
	/datum/admins/proc/toggleooc,		/*toggles ooc on/off for everyone*/
	/datum/admins/proc/toggleoocdead,	/*toggles ooc on/off for everyone who is dead*/
	/datum/admins/proc/toggledsay,    /*toggles dsay on/off for everyone*/
	/client/proc/game_panel,			/*game panel, allows to change game-mode etc*/
	/datum/admins/proc/PlayerNotes,
	/client/proc/cmd_mod_say,
	/datum/admins/proc/show_player_info,
	/client/proc/free_slot,			/*frees slot for chosen job*/
	/client/proc/cmd_admin_change_custom_event,
	/client/proc/cmd_admin_rejuvenate,
	/client/proc/toggleattacklogs,
	/client/proc/toggledebuglogs,
	/client/proc/toggleghostwriters,
	/client/proc/allow_character_respawn,    /* Allows a ghost to respawn */
	/client/proc/admin_infect_zombie,
	/client/proc/checkAccount,
	/client/proc/TogglePrivateParty,
	/client/proc/ReloadKeys,
	/client/proc/fyutha,
)
var/list/admin_verbs_ban = list(
	/client/proc/unban_panel,
	/client/proc/jobbans,
	/client/proc/unjobban_panel,
	/client/proc/DB_ban_panel
	)
var/list/admin_verbs_sounds = list(
	/client/proc/play_local_sound,
	/client/proc/play_sound
	)
var/list/admin_verbs_fun = list(
	/client/proc/object_talk,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/everyone_random,
	/client/proc/one_click_antag,
	/datum/admins/proc/toggle_aliens,
	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/cmd_admin_add_random_ai_law,
	/client/proc/make_sound,
	/client/proc/toggle_random_events,
	/client/proc/set_ooc,
	/client/proc/man_up,
	/client/proc/admin_infect_zombie,
	/client/proc/editappear
	)

var/list/admin_verbs_spawn = list(
	/datum/admins/proc/spawn_atom,		/*allows us to spawn instances*/

	)
var/list/admin_verbs_server = list(
	/client/proc/ToRban,
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/datum/admins/proc/immreboot,
	/client/proc/everyone_random,
	/datum/admins/proc/toggleAI,
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_debug_del_all,
	/datum/admins/proc/adrev,
	/datum/admins/proc/adspawn,
	/datum/admins/proc/adjump,
	/datum/admins/proc/toggle_aliens,
	/client/proc/toggle_random_events,
	/client/proc/fyutha,
	)
var/list/admin_verbs_debug = list(
	/client/proc/CarbonCopy,

	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/Debug2,
	/client/proc/kill_air,
	/client/proc/ZASSettings,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/debug_controller,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_admin_delete,
	/client/proc/cmd_debug_del_all,
	/client/proc/cmd_debug_tog_aliens,
	/client/proc/air_report,
	/client/proc/reload_admins,
	/client/proc/restart_controller,
	/client/proc/enable_debug_verbs,
	/client/proc/callproc,
	/client/proc/callproc_datum,
	/client/proc/toggledebuglogs
	)
var/list/admin_verbs_possess = list(
	/proc/possess,
	/proc/release
	)
var/list/admin_verbs_permissions = list(
	/client/proc/edit_admin_permissions
	)
var/list/admin_verbs_rejuv = list(

	)

//verbs which can be hidden - needs work
var/list/admin_verbs_hideable = list(
	/client/proc/set_ooc,
	/client/proc/deadmin_self,
	/datum/admins/proc/show_traitor_panel,
	/datum/admins/proc/toggleenter,
	/datum/admins/proc/toggleguests,
	/datum/admins/proc/announce,
	/client/proc/colorooc,
	/client/proc/admin_ghost,
	/client/proc/toggle_view_range,
	/datum/admins/proc/view_txt_log,
	/datum/admins/proc/view_atk_log,
	/client/proc/cmd_admin_subtle_message,
	/client/proc/cmd_admin_check_contents,
	/datum/admins/proc/access_news_network,
	/client/proc/admin_call_shuttle,
	/client/proc/admin_cancel_shuttle,
	/client/proc/cmd_admin_direct_narrate,
	/client/proc/cmd_admin_world_narrate,
	/client/proc/check_words,
	/client/proc/play_local_sound,
	/client/proc/play_sound,
	/client/proc/object_talk,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/datum/admins/proc/toggle_aliens,
	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/cmd_admin_add_random_ai_law,
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/make_sound,
	/client/proc/toggle_random_events,
	/client/proc/cmd_admin_add_random_ai_law,
	/client/proc/ToRban,
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/datum/admins/proc/immreboot,
	/client/proc/everyone_random,
	/datum/admins/proc/toggleAI,
	/datum/admins/proc/adrev,
	/datum/admins/proc/adspawn,
	/datum/admins/proc/adjump,
	/client/proc/restart_controller,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/callproc,
	/client/proc/callproc_datum,
	/client/proc/Debug2,
	/client/proc/reload_admins,
	/client/proc/kill_air,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/debug_controller,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_debug_del_all,
	/client/proc/cmd_debug_tog_aliens,
	/client/proc/air_report,
	/client/proc/enable_debug_verbs,
	/client/proc/late_ban,
	/proc/possess,
	/proc/release
	)
var/list/admin_verbs_mod = list(
	/client/proc/cmd_admin_pm_context,	/*right-click adminPM interface*/
	/client/proc/cmd_admin_pm_panel,	/*admin-pm list*/
	/client/proc/debug_variables,		/*allows us to -see- the variables of any instance in the game.*/
	/client/proc/toggledebuglogs,
	/datum/admins/proc/PlayerNotes,
	/client/proc/admin_ghost,			/*allows us to ghost/reenter body at will*/
	/client/proc/cmd_mod_say,
	/datum/admins/proc/show_player_info,
	/client/proc/player_panel_new,
	/client/proc/dsay,
	/client/proc/cmd_admin_subtle_message,	/*send an message to somebody as a 'voice in their head'*/
	/client/proc/fyutha
)
/client/proc/add_admin_verbs()
	if(holder)
		var/rights = holder.rights
		verbs += admin_verbs_default
		if(rights & R_BUILDMODE)	verbs += /client/proc/togglebuildmodeself
		if(rights & R_ADMIN)		verbs += admin_verbs_admin
		if(rights & R_BAN)			verbs += admin_verbs_ban
		if(rights & R_FUN)			verbs += admin_verbs_fun
		if(rights & R_SERVER)		verbs += admin_verbs_server
		if(rights & R_DEBUG)		verbs += admin_verbs_debug
		if(rights & R_POSSESS)		verbs += admin_verbs_possess
		if(rights & R_PERMISSIONS)	verbs += admin_verbs_permissions
		if(rights & R_STEALTH)		verbs += /client/proc/stealth
		if(rights & R_REJUVINATE)	verbs += admin_verbs_rejuv
		if(rights & R_SOUNDS)		verbs += admin_verbs_sounds
		if(rights & R_SPAWN)		verbs += admin_verbs_spawn
		if(rights & R_MOD)			verbs += admin_verbs_mod

/client/proc/remove_admin_verbs()
	verbs.Remove(
		admin_verbs_default,
		/client/proc/togglebuildmodeself,
		admin_verbs_admin,
		admin_verbs_ban,
		admin_verbs_fun,
		admin_verbs_server,
		admin_verbs_debug,
		admin_verbs_possess,
		admin_verbs_permissions,
		/client/proc/stealth,
		admin_verbs_rejuv,
		admin_verbs_sounds,
		admin_verbs_spawn,
		/*Debug verbs added by "show debug verbs"*/
		/client/proc/Cell,
		/client/proc/do_not_use_these,
		/client/proc/camera_view,
		/client/proc/sec_camera_report,
		/client/proc/intercom_view,
		/client/proc/atmosscan,
		/client/proc/powerdebug,
		/client/proc/count_objects_on_z_level,
		/client/proc/count_objects_all,
		/client/proc/cmd_assume_direct_control,
		/client/proc/ticklag,
		/client/proc/cmd_admin_grantfullaccess,
		/client/proc/kaboom,
		/client/proc/splash,
		/client/proc/cmd_admin_areatest,
		/client/proc/late_ban
		)

/client/proc/late_ban()
	set name = "Late Ban"
	set category = "Admin"

	if(!check_rights(R_BAN))	return
	var/ban_key = input(usr, "Type in key for late ban?","Key", "") as text|null
	if (!ban_key) return
	var/ban_comp_id = input(usr, "Type in computer id","Computer ID", "") as text|null

	switch(alert("Temporary Ban?",,"Yes","No", "Cancel"))
		if("Yes")
			var/mins = input(usr,"How long (in minutes)?","Ban time",1440) as num|null
			if(!mins)
				return
			if(mins >= 525600) mins = 525599
			var/reason = input(usr,"Reason?","reason","Griefer") as text|null
			if(!reason)
				return
			AddBan(ban_key, ban_comp_id, reason, usr.ckey, 1, mins)
			ban_unban_log_save("[usr.client.ckey] has banned [ban_key] (not in game). - Reason: [reason] - This will be removed in [mins] minutes.")
//			DB_ban_record(BANTYPE_TEMP, 0, mins, reason, banckey = ban_key)
			log_admin("[usr.client.ckey] has banned [ban_key] (not in game).\nReason: [reason]\nThis will be removed in [mins] minutes.")
			message_admins("\blue[usr.client.ckey] has banned [ban_key] (not in game).\nReason: [reason]\nThis will be removed in [mins] minutes.")

		if("No")
			var/reason = input(usr,"Reason?","reason","Griefer") as text|null
			if(!reason)
				return
			switch(alert(usr,"IP ban?",,"Yes","No","Cancel"))
				if("Cancel")	return
				if("Yes")
					var/ban_ip = input(usr, "Type in ip for late ban", "IP", "") as text|null
					if (!ban_ip) return
					AddBan(ban_key, ban_comp_id, reason, usr.ckey, 0, 0, ban_ip)
				if("No")
					AddBan(ban_key, ban_comp_id, reason, usr.ckey, 0, 0)
			ban_unban_log_save("[usr.client.ckey] has permabanned [ban_key] (not in game). - Reason: [reason] - This is a permanent ban.")
			log_admin("[usr.client.ckey] has banned [ban_key] (not in game).\nReason: [reason]\nThis is a permanent ban.")
			message_admins("\blue[usr.client.ckey] has banned [ban_key] (not in game).\nReason: [reason]\nThis is a permanent ban.")
//			DB_ban_record(BANTYPE_PERMA, ban_key, -1, reason, banckey = ban_key)
		if("Cancel")
			return

/client/proc/hide_most_verbs()//Allows you to keep some functionality while hiding some verbs
	set name = "Adminverbs - Hide Most"
	set category = "Admin"

	verbs.Remove(/client/proc/hide_most_verbs, admin_verbs_hideable)
	verbs += /client/proc/show_verbs
	src << "<span class='interface'>Most of your adminverbs have been hidden.</span>"
	return

/client/var/hide_stats_tab = 0

/client/proc/hide_stats()//Allows you to keep some functionality while hiding some verbs
	set name = "Adminverbs - Hide Stats Screen"
	set category = "Admin"

	if(hide_stats_tab)
		src << "<span class='interface'>STATS DISABLED.</span>"
		hide_stats_tab = 0
	else
		src << "<span class='interface'>STATS ENABLED.</span>"
		hide_stats_tab = 1
	return


/client/proc/hide_verbs()
	set name = "Adminverbs - Hide All"
	set category = "Admin"

	remove_admin_verbs()
	verbs += /client/proc/show_verbs
	src << "<span class='interface'>Almost all of your adminverbs have been hidden.</span>"
	return

/client/proc/show_verbs()
	set name = "Adminverbs - Show"
	set category = "Admin"

	verbs -= /client/proc/show_verbs
	add_admin_verbs()
	src << "<span class='interface'>All of your adminverbs are now visible.</span>"



/client/proc/admin_ghost()
	set category = "Admin"
	set name = "Aghost"
	if(!holder)	return
	if(istype(mob,/mob/dead/observer))
		//re-enter
		var/mob/dead/observer/ghost = mob
		ghost.can_reenter_corpse = 1			//just in-case.
		ghost.reenter_corpse()
	else if(istype(mob,/mob/new_player))
		mob:aghost_observe()
	else
		//ghostize
		var/mob/body = mob
		body.ghostize(1)
		if(body && !body.key)
			body.key = "@[key]"	//Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus
/client/proc/invisimin()
	set name = "Invisimin"
	set category = "Admin"
	set desc = "Toggles ghost-like invisibility (Don't abuse this)"
	if(holder && mob)
		if(mob.invisibility == INVISIBILITY_OBSERVER)
			mob.invisibility = initial(mob.invisibility)
			mob << "\red <b>Invisimin off. Invisibility reset.</b>"
			mob.alpha = max(mob.alpha + 100, 255)
		else
			mob.invisibility = INVISIBILITY_OBSERVER
			mob << "\blue <b>Invisimin on. You are now as invisible as a ghost.</b>"
			mob.alpha = max(mob.alpha - 100, 0)


/client/proc/player_panel()
	set name = "Player Panel"
	set category = "Admin"
	if(holder)
		holder.player_panel_old()
	return

/client/proc/player_panel_new()
	set name = "Player Panel New"
	set category = "Admin"
	if(holder)
		holder.player_panel_new()
	return

/client/proc/check_antagonists()
	set name = "Check Antagonists"
	set category = "Admin"
	if(holder)
		holder.check_antagonists()
		log_admin("[key_name(usr)] checked antagonists.")	//for tsar~
	return

/client/proc/jobbans()
	set name = "Display Job bans"
	set category = "Admin"
	if(holder)
		holder.Jobbans()
	return

/client/proc/unban_panel()
	set name = "Unban Panel"
	set category = "Admin"
	if(holder)
		holder.unbanpanel()
	return

/client/proc/game_panel()
	set name = "Game Panel"
	set category = "Admin"
	if(holder)
		holder.Game()
	return

/client/proc/secrets()
	set name = "Secrets"
	set category = "Admin"
	if (holder)
		holder.Secrets()
	return

/client/proc/colorooc()
	set category = "Fun"
	set name = "OOC Text Color"
	if(holder || customooccolorlist.Find(src.ckey))
		var/new_ooccolor = input(src, "Please select your OOC colour.", "OOC colour") as color|null
		var/toggle_textshadow = input(src, "Do you want your username to glow?", "OOC colour") in list("Yes","No")
		if(new_ooccolor)
			prefs.ooccolor = new_ooccolor
			prefs.save_preferences()
		if(toggle_textshadow)
			if("Yes")
				prefs.nameglow = 1
				prefs.save_preferences()
			else
				prefs.nameglow = 0
				prefs.save_preferences()
		return
	else
		to_chat(src, "<span class='highlighttext'>You are not allowed to do that.</span>")
		return

/client/proc/stealth()
	set category = "Admin"
	set name = "Stealth Mode"
	if(holder)
		if(holder.fakekey)
			holder.fakekey = null
		else
			var/new_key = ckeyEx(input("Enter your desired display name.", "Fake Key", key) as text|null)
			if(!new_key)	return
			if(length(new_key) >= 26)
				new_key = copytext(new_key, 1, 26)
			holder.fakekey = new_key
		log_admin("[key_name(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]")
		message_admins("[key_name_admin(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]", 1)


/client/proc/warn(warned_ckey)
	if(!check_rights(R_MOD))	return

	if(!warned_ckey || !istext(warned_ckey))	return
	if(warned_ckey in admin_datums)
		usr << "<font color='red'>Error: warn(): You can't warn admins.</font>"
		return

	var/datum/preferences/D
	var/client/C = directory[warned_ckey]
	if(C)	D = C.prefs
	else	D = preferences_datums[warned_ckey]

	if(!D)
		src << "<font color='red'>Error: warn(): No such ckey found.</font>"
		return

	if(++D.warns >= 2)					//uh ohhhh...you'reee iiiiin trouuuubble O:)
		ban_unban_log_save("[ckey] warned [warned_ckey], resulting in a 10 minute autoban.")
		if(C)
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)] resulting in a 10 minute ban.")
			C << "<font color='red'><BIG><B>You have been autobanned due to a warning by [ckey].</B></BIG><br>This is a temporary ban, it will be removed in 10 minutes."
			qdel(C)
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] resulting in a 60 minute ban.")
		AddBan(warned_ckey, D.last_id, "Autobanning due to too many formal warnings", ckey, 1, 10)
	else
		if(C)
			C << "<font color='red'><BIG><B>���� ��� ����� ���� ��������� �?</B></BIG><br>Further warnings will result in an autoban.</font>"
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)]. They have [2-D.warns] strikes remaining.")
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] (DC). They have [2-D.warns] strikes remaining.")


/client/proc/drop_bomb() // Some admin dickery that can probably be done better -- TLE
	set category = "Special Verbs"
	set name = "Drop Bomb"
	set desc = "Cause an explosion of varying strength at your location."

	var/turf/epicenter = mob.loc
	var/list/choices = list("Small Bomb", "Medium Bomb", "Big Bomb", "Custom Bomb")
	var/choice = input("What size explosion would you like to produce?") in choices
	switch(choice)
		if(null)
			return 0
		if("Small Bomb")
			explosion(epicenter, 1, 2, 3, 3)
		if("Medium Bomb")
			explosion(epicenter, 2, 3, 4, 4)
		if("Big Bomb")
			explosion(epicenter, 3, 5, 7, 5)
		if("Custom Bomb")
			var/devastation_range = input("Devastation range (in tiles):") as num
			var/heavy_impact_range = input("Heavy impact range (in tiles):") as num
			var/light_impact_range = input("Light impact range (in tiles):") as num
			var/flash_range = input("Flash range (in tiles):") as num
			explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)
	message_admins("\blue [ckey] creating an admin explosion at [epicenter.loc].")

/client/proc/give_spell(mob/T as mob in mob_list) // -- Urist
	set category = "Fun"
	set name = "Give Spell"
	set desc = "Gives a spell to a mob."
	var/obj/effect/proc_holder/spell/S = input("Choose the spell to give to that guy", "ABRAKADABRA") as null|anything in spells
	if(!S) return
	T.spell_list += new S
	log_admin("[key_name(usr)] gave [key_name(T)] the spell [S].")
	message_admins("\blue [key_name_admin(usr)] gave [key_name(T)] the spell [S].", 1)

/client/proc/give_disease(mob/T as mob in mob_list) // -- Giacom
	set category = "Fun"
	set name = "Give Disease"
	set desc = "Gives a Disease to a mob."
	var/datum/disease/D = input("Choose the disease to give to that guy", "ACHOO") as null|anything in diseases
	if(!D) return
	T.contract_disease(new D, 1)
	log_admin("[key_name(usr)] gave [key_name(T)] the disease [D].")
	message_admins("\blue [key_name_admin(usr)] gave [key_name(T)] the disease [D].", 1)

/client/proc/make_sound(var/obj/O in world) // -- TLE
	set category = "Special Verbs"
	set name = "Make Sound"
	set desc = "Display a message to everyone who can hear the target"
	if(O)
		var/message = input("What do you want the message to be?", "Make Sound") as text|null
		if(!message)
			return
		for (var/mob/V in hearers(O))
			V.show_message(sanitize_uni(message), 2)
		log_admin("[key_name(usr)] made [O] at [O.x], [O.y], [O.z]. make a sound")
		message_admins("\blue [key_name_admin(usr)] made [O] at [O.x], [O.y], [O.z]. make a sound", 1)

/client/proc/togglebuildmodeself()
	set name = "Toggle Build Mode Self"
	set category = "Special Verbs"
	if(src.mob)
		togglebuildmode(src.mob)

/client/proc/object_talk(var/msg as text) // -- TLE
	set category = "Special Verbs"
	set name = "oSay"
	set desc = "Display a message to everyone who can hear the target"
	if(mob.control_object)
		if(!msg)
			return
		for (var/mob/V in hearers(mob.control_object))
			V.show_message("<b>[mob.control_object.name]</b> says: \"" + msg + "\"", 2)

/client/proc/kill_air() // -- TLE
	set category = "Debug"
	set name = "Kill Air"
	set desc = "Toggle Air Processing"
	if(air_processing_killed)
		air_processing_killed = 0
		usr << "<b>Enabled air processing.</b>"
	else
		air_processing_killed = 1
		usr << "<b>Disabled air processing.</b>"
	log_admin("[key_name(usr)] used 'kill air'.")
	message_admins("\blue [key_name_admin(usr)] used 'kill air'.", 1)

/client/proc/deadmin_self()
	set name = "De-admin self"
	set category = "Admin"

	if(holder)
		if(alert("Confirm self-deadmin for the round? You can't re-admin yourself without someont promoting you.",,"Yes","No") == "Yes")
			log_admin("[src] deadmined themself.")
			message_admins("[src] deadmined themself.", 1)
			deadmin()
			src << "<span class='interface'>You are now a normal player.</span>"

/client/proc/check_ai_laws()
	set name = "Check AI Laws"
	set category = "Admin"
	if(holder)
		src.holder.output_ai_laws()

//---- bs12 verbs ----

/client/proc/editappear(mob/living/carbon/human/M as mob in world)
	set name = "Edit Appearance"
	set category = "Fun"

	if(!check_rights(R_FUN))	return

	if(!istype(M, /mob/living/carbon/human))
		usr << "\red You can only do this to humans!"
		return
	switch(alert("Are you sure you wish to edit this mob's appearance? Skrell, Unathi, Vox and Tajaran can result in unintended consequences.",,"Yes","No"))
		if("No")
			return
	var/new_facial = input("Please select facial hair color.", "Character Generation") as color
	if(new_facial)
		M.r_facial = hex2num(copytext(new_facial, 2, 4))
		M.g_facial = hex2num(copytext(new_facial, 4, 6))
		M.b_facial = hex2num(copytext(new_facial, 6, 8))

	var/new_hair = input("Please select hair color.", "Character Generation") as color
	if(new_facial)
		M.r_hair = hex2num(copytext(new_hair, 2, 4))
		M.g_hair = hex2num(copytext(new_hair, 4, 6))
		M.b_hair = hex2num(copytext(new_hair, 6, 8))

	var/new_eyes = input("Please select eye color.", "Character Generation") as color
	if(new_eyes)
		M.r_eyes = hex2num(copytext(new_eyes, 2, 4))
		M.g_eyes = hex2num(copytext(new_eyes, 4, 6))
		M.b_eyes = hex2num(copytext(new_eyes, 6, 8))

	var/new_tone = input("Please select skin tone level: 1-255 (1=albino, 35=caucasian, 150=black, 255='very' black)", "Character Generation")  as text

	if (new_tone)
		M.s_tone = max(min(round(text2num(new_tone)), 255), 1)
		M.s_tone =  -M.s_tone + 35

	// hair
	var/new_hstyle = input(usr, "Select a hair style", "Grooming")  as null|anything in hair_styles_list
	if(new_hstyle)
		M.h_style = new_hstyle

	// facial hair
	var/new_fstyle = input(usr, "Select a facial hair style", "Grooming")  as null|anything in facial_hair_styles_list
	if(new_fstyle)
		M.f_style = new_fstyle

	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female")
	if (new_gender)
		if(new_gender == "Male")
			M.gender = MALE
		else
			M.gender = FEMALE
	M.update_hair()
	M.update_body()
	M.check_dna(M)

/client/proc/playernotes()
	set name = "Show Player Info"
	set category = "Admin"
	if(holder)
		holder.PlayerNotes()
	return

/client/proc/free_slot()
	set name = "Free Job Slot"
	set category = "Admin"
	if(holder)
		var/list/jobs = list()
		for (var/datum/job/J in job_master.occupations)
			if (J.current_positions >= J.total_positions && J.total_positions != -1)
				jobs += J.title
		if (!jobs.len)
			usr << "There are no fully staffed jobs."
			return
		var/job = input("Please select job slot to free", "Free job slot")  as null|anything in jobs
		if (job)
			job_master.FreeRole(job)
	return

/client/proc/toggleattacklogs()
	set name = "Toggle Attack Log Messages"
	set category = "Preferences"

	prefs.toggles ^= CHAT_ATTACKLOGS
	if (prefs.toggles & CHAT_ATTACKLOGS)
		usr << "You now will get attack log messages"
	else
		usr << "You now won't get attack log messages"


/client/proc/toggleghostwriters()
	set name = "Toggle ghost writers"
	set category = "Server"
	if(!holder)	return
	if(config)
		if(config.cult_ghostwriter)
			config.cult_ghostwriter = 0
			src << "<b>Disallowed ghost writers.</b>"
			message_admins("Admin [key_name_admin(usr)] has disabled ghost writers.", 1)
		else
			config.cult_ghostwriter = 1
			src << "<b>Enabled ghost writers.</b>"
			message_admins("Admin [key_name_admin(usr)] has enabled ghost writers.", 1)

/client/proc/toggledebuglogs()
	set name = "Toggle Debug Log Messages"
	set category = "Preferences"

	prefs.toggles ^= CHAT_DEBUGLOGS
	if (prefs.toggles & CHAT_DEBUGLOGS)
		usr << "You now will get debug log messages"
	else
		usr << "You now won't get debug log messages"

/client/proc/TogglePrivateParty()
	set name = "Toggle Private Party"
	set category = "Server"

	if(private_party)
		usr << "Whitelist de CKEY Desligada."
		private_party = FALSE
	else
		usr << "Whitelist de CKEY ligada."

/client/proc/ReloadKeys()
	set name = "Reload Ckeys"
	set category = "Server"

	load_ckey_whitelist()

/client/proc/man_up(mob/T as mob in mob_list)
	set category = "Fun"
	set name = "Man Up"
	set desc = "Tells mob to man up and deal with it."

	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T << "<font color='red'><b><font size=3>SAIA DO JOGO.</font></b></span>"
	T.add_overlay_dreamer()
	T << 'jumpscarehand.ogg'
	spawn(20)
		qdel(T.client)

	log_admin("[key_name(usr)] mandou um screamer no [key_name(T)]")
	message_admins("\blue [key_name_admin(usr)] mandou um screamer no [key_name(T)] ", 1)

/*/client/proc/global_man_up()
	set category = "Fun"
	set name = "Man Up Global"
	set desc = "Tells everyone to man up and deal with it."
	whatLateParty = input("Select a late party","Late Party",whatLateParty)in list("soulbreaker", "countess", "ginkese", "countgift", "thanati", "sirvandenberg", "mortus", "cerberii", "inquis")
	to_chat(src, "[whatLateParty] locked.")*/

/client/proc/fyutha()
	set category = "Server"
	set name = "Fyut'Ha"
	set desc = "Fyut'has and shutdowns the server."
	to_chat(world, "<p style='font-size:25.00px'>FYUT'HA!</p>")
	world << 'ha.ogg'
	if(world.port == BRZ_PORT)
		shell("node nodejs/discordhookclose.js")
	if(world.port == IZ2_PORT)
		shell("node nodejs/discordhookiz2close.js")
	if(world.port == IZ1_PORT)
		shell("node nodejs/discordhookiz1close.js")
	spawn(30)
		shutdown()