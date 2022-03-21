var/list/loud_speakers = list()
var/global/chosenSong = null

/obj/machinery/loud_speaker
	name = "Loud Speaker"
	desc = ""
	icon = 'icons/obj/monitors.dmi'
	icon_state = "loudspeaker"
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	var/datum/sound_token/sound_token
	var/playing = 0
	var/sound_id

/obj/machinery/loud_speaker/New()
	. = ..()
	sound_id = "[type]_[sequential_id(type)]"
	loud_speakers.Add(src)


/obj/machinery/loud_speaker/proc/StopPlaying()
	playing = 0
	qdel(sound_token)

/obj/machinery/loud_speaker/proc/playsom()
	StopPlaying()
	sound_token = sound_player.PlayLoopingSound(src, sound_id, chosenSong, volume = 40, range = 10, falloff = 3)
	playing = 1