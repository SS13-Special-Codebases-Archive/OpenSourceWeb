/proc/sanitize_simple(t,list/repl_chars = list("\n"="#","\t"="#"))
	for(var/char in repl_chars)
		var/index = findtext(t, char)
		while(index)
			t = copytext(t, 1, index) + repl_chars[char] + copytext(t, index+1)
			index = findtext(t, char, index+1)
	return t

/proc/sanitize_filename(t)
	return sanitize_simple(t, list("\n"="", "\t"="", "/"="", "\\"="", "?"="", "%"="", "*"="", ":"="", "|"="", "\""="", "<"="", ">"=""))

var/global/TAB = "&nbsp;&nbsp;&nbsp;&nbsp;"



/datum/asset/simple/goonchat
	verify = FALSE
	assets = list(
		"jquery.min.js"            = 'code/modules/html_interface/js/jquery.min.js',
		"json2.min.js"             = 'code/modules/goonchat/browserassets/js/json2.min.js',
		"errorHandler.js"          = 'code/modules/goonchat/browserassets/js/errorHandler.js',
		"browserOutput.js"         = 'code/modules/goonchat/browserassets/js/browserOutput.js',
		"fontawesome-webfont.eot"  = 'tgui/assets/fonts/fontawesome-webfont.eot',
		"fontawesome-webfont.svg"  = 'tgui/assets/fonts/fontawesome-webfont.svg',
		"fontawesome-webfont.ttf"  = 'tgui/assets/fonts/fontawesome-webfont.ttf',
		"fontawesome-webfont.woff" = 'tgui/assets/fonts/fontawesome-webfont.woff',
		"jquery.jscrollpane.min.js"= 'code/modules/goonchat/browserassets/js/scrollbar/jquery.jscrollpane.min.js',
		"jquery.jscrollpane.css"   = 'code/modules/goonchat/browserassets/js/scrollbar/jquery.jscrollpane.css',
		"font-awesome.css"	       = 'code/modules/goonchat/browserassets/css/font-awesome.css',
		"browserOutput.css"	       = 'code/modules/goonchat/browserassets/css/browserOutput.css',
	)

//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣧⠀⠀⠀⢰⡿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡟⡆⠀⠀⣿⡇⢻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⣿⠀⢰⣿⡇⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡄⢸⠀⢸⣿⡇⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡇⢸⡄⠸⣿⡇⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⢸⡅⠀⣿⢠⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣥⣾⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⡿⡿⣿⣿⡿⡅⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠉⠀⠉⡙⢔⠛⣟⢋⠦⢵⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣄⠀⠀⠁⣿⣯⡥⠃⠀⢳⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⡇⠀⠀⠀⠐⠠⠊⢀⠀⢸⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⡿⠀⠀⠀⠀⠀⠈⠁⠀⠀⠘⣿⣄⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⣠⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣷⡀⠀⠀⠀
//⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣧⠀⠀
//⠀⠀⠀⡜⣭⠤⢍⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⢛⢭⣗⠀
//⠀⠀⠀⠁⠈⠀⠀⣀⠝⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠠⠀⠀⠰⡅
//⠀⠀⢀⠀⠀⡀⠡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠔⠠⡕⠀
//⠀⠀⠀⠀⣿⣷⣶⠒⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠀⠀⠀⠀
//⠀⠀⠀⠀⠘⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠈⢿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠊⠉⢆⠀⠀⠀⠀
//⠀⢀⠤⠀⠀⢤⣤⣽⣿⣿⣦⣀⢀⡠⢤⡤⠄⠀⠒⠀⠁⠀⠀⠀⢘⠔⠀⠀⠀⠀
//⠀⠀⠀⡐⠈⠁⠈⠛⣛⠿⠟⠑⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠉⠑⠒⠀⠁⠀⠀

// ░░░░░▒░░▄██▄░▒░░░░░░
// ░░░▄██████████▄▒▒░░░
// ░▒▄████████████▓▓▒░░
// ▓███▓▓█████▀▀████▒░░
// ▄███████▀▀▒░░░░▀█▒░░
// ████████▄░░░░░░░▀▄░░
// ▀██████▀░░▄▀▀▄░░▄█▒░
// ░█████▀░░░░▄▄░░▒▄▀░░
// ░█▒▒██░░░░▀▄█░░▒▄█░░
// ░█░▓▒█▄░░░░░░░░░▒▓░░
// ░▀▄░░▀▀░▒░░░░░▄▄░▒░░
// ░░█▒▒▒▒▒▒▒▒▒░░░░▒░░░
// ░░░▓▒▒▒▒▒░▒▒▄██▀░░░░
// ░░░░▓▒▒▒░▒▒░▓▀▀▒░░░░
// ░░░░░▓▓▒▒░▒░░▓▓░░░░░
// ░░░░░░░▒▒▒▒▒▒▒░░░░░░

//`7MMF'   `7MF' db      `7MMF'    MMP""MM""YMM   .g8""8q. `7MMM.     ,MMF'      db      `7MM"""Mq.      `7MN.   `7MF' .g8""8q.         .g8"""bgd `7MMF'   `7MF'    `7MN.   `7MF' .g8""8q. `7MM"""Mq.`7MMM.     ,MMF'
//  `MA     ,V  ;MM:       MM      P'   MM   `7 .dP'    `YM. MMMb    dPMM       ;MM:       MM   `MM.       MMN.    M .dP'    `YM.     .dP'     `M   MM       M        MMN.    M .dP'    `YM. MM   `MM. MMMb    dPMM
//   VM:   ,V  ,V^MM.      MM           MM      dM'      `MM M YM   ,M MM      ,V^MM.      MM   ,M9        M YMb   M dM'      `MM     dM'       `   MM       M        M YMb   M dM'      `MM MM   ,M9  M YM   ,M MM
//    MM.  M' ,M  `MM      MM           MM      MM        MM M  Mb  M' MM     ,M  `MM      MMmmdM9         M  `MN. M MM        MM     MM            MM       M        M  `MN. M MM        MM MMmmdM9   M  Mb  M' MM
//    `MM A'  AbmmmqMA     MM           MM      MM.      ,MP M  YM.P'  MM     AbmmmqMA     MM  YM.         M   `MM.M MM.      ,MP     MM.           MM       M        M   `MM.M MM.      ,MP MM        M  YM.P'  MM
//     :MM;  A'     VML    MM           MM      `Mb.    ,dP' M  `YM'   MM    A'     VML    MM   `Mb.       M     YMM `Mb.    ,dP'     `Mb.     ,'   YM.     ,M        M     YMM `Mb.    ,dP' MM        M  `YM'   MM
//      VF .AMA.   .AMMA..JMML.       .JMML.      `"bmmd"' .JML. `'  .JMML..AMA.   .AMMA..JMML. .JMM.    .JML.    YM   `"bmmd"'         `"bmmmd'     `bmmmmd"'      .JML.    YM   `"bmmd"' .JMML.    .JML. `'  .JMML.

