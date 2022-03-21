
/mob/living/carbon/human/var/is_sining = FALSE //for prevent never stoping singing
/mob/living/carbon/human/var/list/songs_remembered = list() //songs remembered by Bard or a Jester, so he can use them later.

/mob/living/carbon/human/proc/remembersong()
	set hidden = 0
	set name = "RememberSong"

	if(!check_perk(/datum/perk/singer))
		return

	var/song_name = sanitize(input(src, "Choose the name of your song!", "Song", "") as text)
	if(!song_name)
		return
	var/song_input = sanitize(input(src, "Song", "Song", "") as message, repl_chars = list("\t"="#","ÿ"="&#255;"))
	if(!song_input)
		return

	var/list/song_list = splittext(song_input, "\n")
	if(length(song_list) < 2)
		to_chat(src, "<span class='combat'>The length of the song must be at least 2 lines!</span>")
		return

	songs_remembered[song_name] = song_list
	to_chat(src, "I remember a song named [song_name].")
	return

/mob/living/carbon/human/proc/sing()
	set hidden = 0
	set name = "Sing"

	if(!check_perk(/datum/perk/singer))
		return

	if(stat) return
	if(is_sining)
		to_chat(src, "You stop singing.")
		is_sining = FALSE
		return

	if(!length(songs_remembered))
		to_chat(src, "<span class='combat'>I don't know any song!</span>")
		return

	is_sining = TRUE
	var/song_name = input(usr, "Which song I should sing?", "Song") in songs_remembered

	for(var/song_text in songs_remembered[song_name])
		if(!is_sining)
			return
		if(stat && is_sining)
			is_sining = FALSE
			return
		say("sing*[song_text]")
		sleep(20)