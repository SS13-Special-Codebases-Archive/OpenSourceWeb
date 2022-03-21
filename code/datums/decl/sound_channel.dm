#define subtypesof(prototype) (typesof(prototype) - prototype)

// Helper macros to aid in optimizing lazy instantiation of lists.
// All of these are null-safe, you can use them without knowing if the list var is initialized yet

//Picks from the list, with some safeties, and returns the "default" arg if it fails
#define DEFAULTPICK(L, default) ((istype(L, /list) && L:len) ? pick(L) : default)
// Ensures L is initailized after this point
#define LAZYINITLIST(L) if (!L) L = list()
// Sets a L back to null iff it is empty
#define UNSETEMPTY(L) if (L && !L.len) L = null
// Removes I from list L, and sets I to null if it is now empty
#define LAZYREMOVE(L, I) if(L) { L -= I; if(!length(L)) { L = null; } }
// Adds I to L, initalizing L if necessary
#define LAZYADD(L, I) if(!L) { L = list(); } L += I;
// Insert I into L at position X, initalizing L if necessary
#define LAZYINSERT(L, I, X) if(!L) { L = list(); } L.Insert(X, I);
// Adds I to L, initalizing L if necessary, if I is not already in L
#define LAZYDISTINCTADD(L, I) if(!L) { L = list(); } L |= I;
// Sets L[A] to I, initalizing L if necessary
#define LAZYSET(L, A, I) if(!L) { L = list(); } L[A] = I;
// Reads I from L safely - Works with both associative and traditional lists.
#define LAZYACCESS(L, I) (L ? (isnum(I) ? (I > 0 && I <= length(L) ? L[I] : null) : L[I]) : null)
// Reads the length of L, returning 0 if null
#define LAZYLEN(L) length(L)
// Safely checks if I is in L
#define LAZYISIN(L, I) (L ? (I in L) : FALSE)
// Null-safe List.Cut() and discard.
#define LAZYCLEARLIST(L) if(L) { L.Cut(); L = null; }
// Reads L or an empty list if L is not a list.  Note: Does NOT assign, L may be an expression.
#define SANITIZE_LIST(L) ( islist(L) ? L : list() )

var/repository/sound_channels/sound_channels = new()

/repository/sound_channels
	var/datum/stack/available_channels
	var/list/keys_by_channel           // So we know who to blame if we run out
	var/channel_ceiling	= 1024         // Initial value is the current BYOND maximum number of channels

/repository/sound_channels/New()
	..()
	available_channels = new()

/repository/sound_channels/proc/RequestChannel(var/key)
	. = RequestChannels(key, 1)
	return LAZYLEN(.) && .[1]

/repository/sound_channels/proc/RequestChannels(var/key, var/amount)
	if(!key)
		CRASH("Invalid key given.")
	. = list()

	for(var/i = 1 to amount)
		var/channel = available_channels.Pop() // Check if someone else has released their channel.
		if(!channel)
			if(channel_ceiling <= 0) // This basically means we ran out of channels
				break
			channel = channel_ceiling--
		. += channel

	if(length(.) != amount)
		ReleaseChannels(.)
		CRASH("Unable to supply the requested amount of channels: [key] - Expected [amount], was [length(.)]")

	for(var/channel in .)
		LAZYSET(keys_by_channel, "[channel]", key)
	return .

/repository/sound_channels/proc/ReleaseChannel(var/channel)
	ReleaseChannels(list(channel))

/repository/sound_channels/proc/ReleaseChannels(var/list/channels)
	for(var/channel in channels)
		LAZYREMOVE(keys_by_channel, "[channel]")
		available_channels.Push(channel)