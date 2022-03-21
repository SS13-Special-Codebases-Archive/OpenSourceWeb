#define COLOR_DARKMODE_BACKGROUND "#0e0b0e"
#define COLOR_DARKMODE_DARKBACKGROUND "#171717"
#define COLOR_DARKMODE_TEXT "#a4bad6"
#define COLOR_WEBHOOK_DEFAULT 0x8bbbd5

/client/proc/force_dark_theme() //Inversely, if theyre using white theme and want to swap to the superior dark theme, let's get WINSET() ing
	//Main windows
	if(winexists(src, "rulesb"))
		winset(src, "infowindow", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
		winset(src, "infowindow", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "rpane", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
		winset(src, "rpane", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "info", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
		winset(src, "info", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "browseroutput", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
		winset(src, "browseroutput", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "outputwindow", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
		winset(src, "outputwindow", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "rpanewindow", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
		winset(src, "rpanewindow", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "mainwindow", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
		winset(src, "split", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
		winset(src, "mainvsplit", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
		winset(src, "rpane", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
		//Buttons
		winset(src, "textb", "background-color = none;background-color = #494949")
		winset(src, "textb", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "infob", "background-color = none;background-color = #494949")
		winset(src, "infob", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "rulesb", "background-color = none;background-color = #494949")
		winset(src, "rulesb", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "Lore", "background-color = none;background-color = #494949")
		winset(src, "Lore", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "wikib", "background-color = none;background-color = #494949")
		winset(src, "wikib", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "forumb", "background-color = none;background-color = #494949")
		winset(src, "forumb", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "changelog", "background-color = none;background-color = #494949")
		winset(src, "changelog", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "github", "background-color = none;background-color = #494949")
		winset(src, "github", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "BugReport", "background-color = none;background-color = #494949")
		winset(src, "BugReport", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "Discord", "background-color = none;background-color = #494949")
		winset(src, "Discord", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "hotkey_toggle", "background-color = none;background-color = #494949")
		winset(src, "hotkey_toggle", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		//Status and verb tabs
		winset(src, "output", "background-color = none;background-color = [COLOR_DARKMODE_DARKBACKGROUND]")
		winset(src, "output", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "outputwindow", "background-color = none;background-color = [COLOR_DARKMODE_DARKBACKGROUND]")
		winset(src, "outputwindow", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "statwindow", "background-color = none;background-color = [COLOR_DARKMODE_DARKBACKGROUND]")
		winset(src, "statwindow", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "info", "background-color = #FFFFFF;background-color = [COLOR_DARKMODE_DARKBACKGROUND]")
		winset(src, "info", "tab-background-color = none;tab-background-color = [COLOR_DARKMODE_BACKGROUND]")
		winset(src, "info", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "info", "tab-text-color = #000000;tab-text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "info", "prefix-color = #000000;prefix-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "info", "suffix-color = #000000;suffix-color = [COLOR_DARKMODE_TEXT]")
		//Say, OOC, me Buttons etc.
		winset(src, "saybutton", "background-color = none;background-color = #494949")
		winset(src, "saybutton", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
		winset(src, "asset_cache_browser", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
		winset(src, "asset_cache_browser", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")

		winset(src, "input", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
		winset(src, "input", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")

/client/verb/set_chat_mode()
	set name = "Chat Color Mode"
	set category = "OOC"

	force_dark_theme()

#if DM_BUILD < 1540
#define FOR_BLIND(V, C) for (var/V as() in C)
#else
#define FOR_BLIND(V, C) for (var/V as anything in C)
#endif

/proc/valid_ckey(text)
	var/static/regex/matcher = new (@"^[a-z0-9]{1,30}$")
	return regex_find(matcher, text)

/proc/ckey2client(text)
	if (valid_ckey(text))
		FOR_BLIND(client/C, clients)
			if (C.ckey == text)
				return C

/proc/resolve_client(client/thing)
	if (!thing)
		return usr
	if (istype(thing))
		return thing
	if (ismob(thing))
		var/mob/M = thing
		return M.client
	return ckey2client(thing)