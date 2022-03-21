/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"

	msg = sanitize(msg)
	if(!msg)	return

	if(usr.client)
		if(usr.client.prefs.muted & MUTE_PRAY)
			return
		if(src.client.handle_spam_prevention(msg,MUTE_PRAY))
			return

	for(var/mob/new_player/N in player_list)
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			to_chat(N, "<span class='passivebold'>[H.real_name]</span> <span class='passive'> prays ([H.religion]): [msg]</span>")
	for(var/client/C in admins)
		if(C.prefs.toggles & CHAT_PRAYER)
			if(ishuman(src))
				var/mob/living/carbon/human/H = src
				to_chat(C, "<span class='passivebold'>[H.real_name]</span> <span class='passive'> prays ([H.religion]): [msg]</span>")

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.qualarea()
		if(H.lastarea && istype(lastarea, /area/dunwell/station/church) && H.check_event("epitemia"))
			var/datum/happiness_event/epitemia/mood = H.events["epitemia"]
			if(mood?.epitemia_type == PRAY_CHURCH)
				H.free_sins()

	whisper("[msg]")

/proc/Centcomm_announce(var/text , var/mob/Sender , var/iamessage)
	var/msg = sanitize(text)
	msg = "\blue <b><font color=orange>CENTCOMM[iamessage ? " IA" : ""]:</font>[key_name(Sender, 1)] (<A HREF='?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[Sender]'>SM</A>) (<A HREF='?_src_=holder;adminplayerobservejump=\ref[Sender]'>JMP</A>) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;BlueSpaceArtillery=\ref[Sender]'>BSA</A>) (<A HREF='?_src_=holder;CentcommReply=\ref[Sender]'>RPLY</A>):</b> [msg]"
	admins << msg

/proc/Syndicate_announce(var/text , var/mob/Sender)
	var/msg = sanitize(text)
	msg = "\blue <b><font color=crimson>SYNDICATE:</font>[key_name(Sender, 1)] (<A HREF='?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[Sender]'>SM</A>) (<A HREF='?_src_=holder;adminplayerobservejump=\ref[Sender]'>JMP</A>) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;BlueSpaceArtillery=\ref[Sender]'>BSA</A>) (<A HREF='?_src_=holder;SyndicateReply=\ref[Sender]'>RPLY</A>):</b> [msg]"
	admins << msg
