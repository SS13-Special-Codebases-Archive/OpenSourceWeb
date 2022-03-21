/proc/play_modnote(A3sample, A5sample, note, acc, octave)
	var/list/semitones_num = list(1, 3, 5, 6, 8, 10, 12)
	var/list/tones = list("C","D","E","F","G","A","B")

	var/const/A3Freq = 220
	var/const/A3Pos = 12 * 3 + 10
	var/const/A5Freq = 1760
	var/const/A5Pos = 12 * 5 + 10

	var/current_note = uppertext(note)
	var/semitone = semitones_num[tones.Find(current_note)]
	var/octave_diver = octave * 12
	var/note_num = semitone + octave_diver
	var/sound/note_sound = null
	var/sample_freq = 0
	var/sample_pos  = 0
	if (octave <= 4)
		note_sound = sound(A3sample)
		sample_freq= A3Freq
		sample_pos = A3Pos
	else
		note_sound = sound(A5sample)
		sample_freq= A5Freq
		sample_pos = A5Pos
	if (acc == "#")
		note_num++
	if (acc == "b")
		note_num--
	var/note_freq = sample_freq * 2**((note_num-sample_pos)/12)
	var/note_acc = note_freq / sample_freq
	note_sound.frequency = note_acc

	return note_sound

var/list/instruments = list("Piano", "Violin", "Guitar", "True sawtooth", "Lead sawtooth", "True square", "Lead square", "Vibraphone", "Organ")
var/list/instruments_A3files = list('sound/synthesizer/PianoA3.ogg', 'sound/synthesizer/ViolinA3.ogg', 'sound/synthesizer/GuitarA3.ogg', 'sound/synthesizer/SawtoothA3.ogg', 'sound/synthesizer/LeadSawtoothA3.ogg', 'sound/synthesizer/SquareA3.ogg', 'sound/synthesizer/LeadSquareA3.ogg', 'sound/synthesizer/VibraphoneA3.ogg', 'sound/synthesizer/OrganA3.ogg')
var/list/instruments_A5files = list('sound/synthesizer/PianoA5.ogg', 'sound/synthesizer/ViolinA5.ogg', 'sound/synthesizer/GuitarA5.ogg', 'sound/synthesizer/SawtoothA5.ogg', 'sound/synthesizer/LeadSawtoothA5.ogg', 'sound/synthesizer/SquareA5.ogg', 'sound/synthesizer/LeadSquareA5.ogg', 'sound/synthesizer/VibraphoneA5.ogg', 'sound/synthesizer/OrganA5.ogg')

/obj/structure/device/piano/synthesizer
	name = "Synthesizer"
	icon_state = "synthesizer"
	anchored = 0 //Movable
	var/octave_off = 0
	var/classic = 0
	var/volume = 100
	var/A3mod_note = 'sound/synthesizer/PianoA3.ogg'
	var/A5mod_note = 'sound/synthesizer/PianoA5.ogg'


/obj/structure/device/piano/synthesizer/New()
	return

/obj/structure/device/piano/synthesizer/playsong()
	do
		var/avail_channels = list(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
		var/cur_oct[7]
		var/cur_acc[7]
		for(var/i = 1 to 7)
			cur_oct[i] = "3"
			cur_acc[i] = "n"

		for(var/line in song.lines)
			for(var/beat in text2list(lowertext(line), ","))
				var/list/notes = text2list(beat, "/")
				for(var/note in text2list(notes[1], "-"))
					if(!playing)
						return
					if(length(note) == 0)
						continue
					var/cur_note = text2ascii(note) - 96
					if(cur_note < 1 || cur_note > 7)
						continue
					for(var/i=2 to length(note))
						var/ni = copytext(note,i,i+1)
						if(!text2num(ni))
							if(ni == "#" || ni == "b" || ni == "n")
								cur_acc[cur_note] = ni
							else if(ni == "s")
								cur_acc[cur_note] = "#" // so shift is never required
						else
							cur_oct[cur_note] = ni

					var/letter = uppertext(copytext(note,1,2))
					var/acc = cur_acc[cur_note]
					var/oct = text2num(cur_oct[cur_note])
					if (classic)
						playnote(letter+acc+num2text(oct+octave_off))
					else
						var/list/mob/heard_by = hearers(15, get_turf(src))
						var/avail_channel = pick(avail_channels)
						avail_channels -= avail_channel
						var/sound/note_sound = play_modnote(A3mod_note, A5mod_note, letter, acc, oct+octave_off)
						note_sound.channel = avail_channel
						note_sound.volume = volume
						heard_by << note_sound
						var/note_length = song.tempo / (notes.len>=2 && text2num(notes[2]) != 0 ? text2num(notes[2]) : 1)
						spawn(note_length)
							heard_by << sound(null, channel=avail_channel)
							avail_channels += avail_channel
				if(notes.len >= 2 && text2num(notes[2]))
					sleep(song.tempo / text2num(notes[2]))
				else
					sleep(song.tempo)
		if(repeat > 0)
			repeat--
	while(repeat > 0)
	playing = 0
	updateUsrDialog()

/obj/structure/device/piano/synthesizer/attack_hand(var/mob/user as mob)
/*
	if(user.ckey == "editorrus")  // ok ok
		playsound(src.loc, "sparks", 75, 1, -1)
		user.Weaken(30)
		user << "\red You're feel like people are beginning to suffer."
		return*/

	usr.machine = src

	var/dat = "<HEAD><TITLE>Synthesizer</TITLE></HEAD><BODY>"

	if(song)
		if(song.lines.len > 0 && !(playing))
			dat += "<A href='?src=\ref[src];play=1'>Play Song</A><BR><BR>"
			dat += "<A href='?src=\ref[src];repeat=1'>Repeat Song: [repeat] times.</A><BR><BR>"
		if(playing)
			dat += "<A href='?src=\ref[src];stop=1'>Stop Playing</A><BR>"
			dat += "Repeats left: [repeat].<BR><BR>"
	if(!edit)
		dat += "<A href='?src=\ref[src];edit=2'>Show Editor</A><BR><BR>"
	else
		dat += "Octave transpose: <A href='?src=\ref[src];octave_down=1'>-</a> [octave_off] <a href='?src=\ref[src];octave_up=1'>+</A><BR>"
		dat += "[classic ? "<A href='?src=\ref[src];switch_mode=1'>Switch to modulated note</a>" : "<A href='?src=\ref[src];switch_mode=2'>Switch to recorded notes</a>"]<br>"
		if (!classic)
			dat += "Current volume: <a href='?src=\ref[src];change_volume=1'>[volume]</a><br>"
			dat += "Current instrument: <a href='?src=\ref[src];change_instrument=1'>[instruments[instruments_A3files.Find(A3mod_note)]]</a><br>"
		dat += "<A href='?src=\ref[src];edit=1'>Hide Editor</A><BR>"
		dat += "<A href='?src=\ref[src];newsong=1'>Start a New Song</A><BR>"
		dat += "<A href='?src=\ref[src];import=1'>Import a Song</A><BR><BR>"
		if(song)
			var/calctempo = (10/song.tempo)*60
			dat += "Tempo : <A href='?src=\ref[src];tempo=10'>-</A><A href='?src=\ref[src];tempo=1'>-</A> [calctempo] BPM <A href='?src=\ref[src];tempo=-1'>+</A><A href='?src=\ref[src];tempo=-10'>+</A><BR><BR>"
			var/linecount = 0
			for(var/line in song.lines)
				linecount += 1
				dat += "Line [linecount]: [line] <A href='?src=\ref[src];deleteline=[linecount]'>Delete Line</A> <A href='?src=\ref[src];modifyline=[linecount]'>Modify Line</A><BR>"
			dat += "<A href='?src=\ref[src];newline=1'>Add Line</A><BR><BR>"
		if(help)
			dat += "<A href='?src=\ref[src];help=1'>Hide Help</A><BR>"
			dat += {"
					Lines are a series of chords, separated by commas (,), each with notes seperated by hyphens (-).<br>
					Every note in a chord will play together, with chord timed by the tempo.<br>
					<br>
					Notes are played by the names of the note, and optionally, the accidental, and/or the octave number.<br>
					By default, every note is natural and in octave 3. Defining otherwise is remembered for each note.<br>
					Example: <i>C,D,E,F,G,A,B</i> will play a C major scale.<br>
					After a note has an accidental placed, it will be remembered: <i>C,C4,C,C3</i> is C3,C4,C4,C3</i><br>
					Chords can be played simply by seperating each note with a hyphon: <i>A-C#,Cn-E,E-G#,Gn-B</i><br>
					A pause may be denoted by an empty chord: <i>C,E,,C,G</i><br>
					To make a chord be a different time, end it with /x, where the chord length will be length<br>
					defined by tempo / x: <i>C,G/2,E/4</i><br>
					Combined, an example is: <i>E-E4/4,/2,G#/8,B/8,E3-E4/4</i>
					<br>
					Lines may be up to 50 characters.<br>
					A song may only contain up to 50 lines.<br>
					"}
		else
			dat += "<A href='?src=\ref[src];help=2'>Show Help</A><BR>"
	dat += "</BODY></HTML>"
	user << browse(dat, "window=piano;size=700x300")
	onclose(user, "piano")

/obj/structure/device/piano/synthesizer/Topic(href, href_list)
	if(!in_range(src, usr) || issilicon(usr) || !usr.canmove || usr.restrained()) //To copypaste entire Topic just to remove !anchored from here. Good job, dammit.
		usr << browse(null, "window=piano;size=700x300")
		onclose(usr, "piano")
		return

	if(href_list["octave_up"])
		if (octave_off < 5)
			octave_off++
	if(href_list["octave_down"])
		if (octave_off > -5)
			octave_off--
	if(href_list["switch_mode"])
		classic = text2num(href_list["switch_mode"])-1
	if(href_list["change_instrument"])
		var/instruments_files_index = instruments.Find(input(usr, "Choose your instrument", "Instrument", "Piano") in instruments)
		A3mod_note = instruments_A3files[instruments_files_index]
		A5mod_note = instruments_A5files[instruments_files_index]

	if(href_list["change_volume"])
		var/new_volume = input(usr, "Enter new volume (0-100)", "Volume", volume) as num
		volume = min(max(new_volume, 0), 100)

	if(href_list["newsong"])
		song = new()
	else if(song)
		if(href_list["repeat"]) //Changing this from a toggle to a number of repeats to avoid infinite loops.
			if(playing) return //So that people cant keep adding to repeat. If the do it intentionally, it could result in the server crashing.
			var/tempnum = input("How many times do you want to repeat this piece? (max:10)") as num|null
			if(tempnum > 10)
				tempnum = 10
			if(tempnum < 0)
				tempnum = 0
			repeat = round(tempnum)

		else if(href_list["tempo"])
			song.tempo += round(text2num(href_list["tempo"]))
			if(song.tempo < 1)
				song.tempo = 1

		else if(href_list["play"])
			if(song)
				playing = 1
				spawn() playsong()

		else if(href_list["newline"])
			var/newline = html_encode(input("Enter your line: ", "Piano") as text|null)
			if(!newline)
				return
			if(song.lines.len > 50)
				return
			if(length(newline) > 50)
				newline = copytext(newline, 1, 50)
			song.lines.Add(newline)

		else if(href_list["deleteline"])
			var/num = round(text2num(href_list["deleteline"]))
			if(num > song.lines.len || num < 1)
				return
			song.lines.Cut(num, num+1)

		else if(href_list["modifyline"])
			var/num = round(text2num(href_list["modifyline"]),1)
			var/content = html_encode(input("Enter your line: ", "Piano", song.lines[num]) as text|null)
			if(!content)
				return
			if(length(content) > 50)
				content = copytext(content, 1, 50)
			if(num > song.lines.len || num < 1)
				return
			song.lines[num] = content

		else if(href_list["stop"])
			playing = 0

		else if(href_list["help"])
			help = text2num(href_list["help"]) - 1

		else if(href_list["edit"])
			edit = text2num(href_list["edit"]) - 1

		else if(href_list["import"])
			var/t = ""
			do
				t = html_encode(input(usr, "Please paste the entire song, formatted:", text("[]", src.name), t)  as message)
				if (!in_range(src, usr))
					return

/*				if(length(t) >= 3072)
					var/cont = input(usr, "Your message is too long! Would you like to continue editing it?", "", "yes") in list("yes", "no")
					if(cont == "no")
						break*/
			while(length(t) > 3072)

			//split into lines
			//spawn() --What is the fucking point of this?
			var/list/lines = text2list(t, "\n")
			var/tempo = 5
			if(copytext(lines[1],1,6) == "BPM: ")
				tempo = 600 / text2num(copytext(lines[1],6))
				lines.Cut(1,2)
			if(lines.len > 100)
				usr << "Too many lines!"
				lines.Cut(101)
			var/linenum = 1
			for(var/l in lines)
				if(length(l) > 100)
					usr << "Line [linenum] too long!"
					lines.Remove(l)
				else
					linenum++
			song = new()
			song.lines = lines
			song.tempo = tempo
			updateUsrDialog()
	attack_hand(usr)
	add_fingerprint(usr)
	updateUsrDialog()
	return