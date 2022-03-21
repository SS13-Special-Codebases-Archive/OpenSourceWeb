/*
 * Holds procs designed to help with d_filtering text
 * Contains groups:
 *			SQL sanitization
 *			Text sanitization
 *			Text searches
 *			Text modification
 *			Misc
 */


/*
 * SQL sanitization
 */

// Run all strings to be used in an SQL query through this proc first to properly escape out injection attempts.
/proc/sanitizeSQL(var/t as text)
	var/sanitized_text = replacetext(t, "'", "\\'")
	sanitized_text = replacetext(sanitized_text, "\"", "\\\"")
	return sanitized_text

/*
 * Text sanitization
 */

//Simply removes < and > and limits the length of the message
/proc/strip_html_simple(var/t,var/limit=MAX_MESSAGE_LEN)
	var/list/strip_chars = list("<",">")
	t = copytext_char(t,1,limit)
	for(var/char in strip_chars)
		var/index = findtext(t, char)
		while(index)
			t = copytext_char(t, 1, index) + copytext_char(t, index+1)
			index = findtext(t, char)
	t = replacetext(t, "&#", "")
	return t

proc/sanitize_PDA(var/msg)
	var/index = findtext(msg, "�")
	while(index)
		msg = copytext_char(msg, 1, index) + "&#1103;" + copytext_char(msg, index+1)
		index = findtext(msg, "�")
	index = findtext(msg, "&#255;")
	while(index)
		msg = copytext_char(msg, 1, index) + "&#1103;" + copytext_char(msg, index+1)
		index = findtext(msg, "&#255;")
	return msg

//Removes a few problematic characters
/proc/sanitize(var/t,var/list/repl_chars = list("\n"="#","\t"="#","ÿ"="&#255;"))
	for(var/char in repl_chars)
		var/index = findtext(t, char)
		while(index)
			t = copytext(t, 1, index) + repl_chars[char] + copytext(t, index+1)
			index = findtext(t, char)
	return strip_html_simple(t)


/proc/replace_characters(var/t,var/list/repl_chars)
	for(var/char in repl_chars)
		t = replacetext(t, char, repl_chars[char])
	return t

/proc/sanitize_uni(var/t,var/list/repl_chars = list("�"="&#255;"))
	for(var/char in repl_chars)
		var/index = findtext(t, char)
		while(index)
			t = copytext_char(t, 1, index) + repl_chars[char] + copytext_char(t, index+1)
			index = findtext(t, char)
	return t

//Returns null if there is any bad text in the string
/proc/reject_bad_text(var/text, var/max_length=512)
	if(length(text) > max_length)	return			//message too long
	var/non_whitespace = 0
	for(var/i=1, i<=length(text), i++)
		switch(text2ascii(text,i))
			if(62,60,92,47)	return			//rejects the text if it contains these bad characters: <, >, \ or /
//			if(127 to 255)	return			//rejects weird letters like �
			if(0 to 31)		return			//more weird stuff
			if(32)			continue		//whitespace
			else			non_whitespace = 1
	if(non_whitespace)		return text		//only accepts the text if it has some non-spaces

// Used to get a sanitized input.
/proc/stripped_input(var/mob/user, var/message = "", var/title = "", var/default = "", var/max_length=MAX_MESSAGE_LEN)
	var/name = input(user, message, title, default)
	return strip_html_simple(name, max_length)

//d_filters out undesirable characters from names
/proc/reject_bad_name(var/t_in, var/allow_numbers=0, var/max_length=MAX_NAME_LEN)
	if(!t_in || length(t_in) > max_length)
		return //Rejects the input if it is null or if it is longer then the max length allowed

	var/number_of_alphanumeric	= 0
	var/last_char_group			= 0
	var/t_out = ""

	for(var/i=1, i<=length(t_in), i++)
		var/ascii_char = text2ascii(t_in,i)
		switch(ascii_char)
			// A  .. Z
			if(65 to 90)			//Uppercase Letters
				t_out += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_group = 4

			// a  .. z
			if(97 to 122)			//Lowercase Letters
				if(last_char_group<2)		t_out += ascii2text(ascii_char-32)	//Force uppercase first character
				else						t_out += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_group = 4

			// 0  .. 9
			if(48 to 57)			//Numbers
				if(!last_char_group)		continue	//suppress at start of string
				if(!allow_numbers)			continue
				t_out += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_group = 3

			// '  -
			if(39,45)			//Common name punctuation
				if(!last_char_group) continue
				t_out += ascii2text(ascii_char)
				last_char_group = 2

			//Space
			if(32)
				if(last_char_group <= 1)	continue	//suppress double-spaces and spaces at start of string
				t_out += ascii2text(ascii_char)
				last_char_group = 1
			else
				return

	if(number_of_alphanumeric < 2)	return		//protects against tiny names like "A" and also names like "' ' ' ' ' ' ' '"

	if(last_char_group == 1)
		t_out = copytext_char(t_out,1,length(t_out))	//removes the last character (in this case a space)

	for(var/bad_name in list("space","floor","wall","r-wall","monkey","unknown","inactive ai"))	//prevents these common metagamey names
		if(cmptext(t_out,bad_name))	return	//(not case sensitive)

	return t_out

//checks text for html tags
//if tag is not in whitelist (var/list/paper_tag_whitelist in global.dm)
//relpaces < with &lt;
proc/checkhtml(var/t)
	t = html_encode(t)
	var/p = findtext(t,"<",1)
	while (p)	//going through all the tags
		var/start = p++
		var/tag = copytext_char(t,p, p+1)
		if (tag != "/")
			while (reject_bad_text(copytext_char(t, p, p+1), 1))
				tag = copytext_char(t,start, p)
				p++
			tag = copytext_char(t,start+1, p)
			if (!(tag in paper_tag_whitelist))	//if it's unkown tag, disarming it
				t = copytext_char(t,1,start-1) + "&lt;" + copytext_char(t,start+1)
		p = findtext(t,"<",p)
	return t
/*
 * Text searches
 */

//Checks the beginning of a string for a specified sub-string
//Returns the position of the substring or 0 if it was not found
/proc/dd_hasprefix(text, prefix)
	var/start = 1
	var/end = length(prefix) + 1
	return findtext(text, prefix, start, end)

//Checks the beginning of a string for a specified sub-string. This proc is case sensitive
//Returns the position of the substring or 0 if it was not found
/proc/dd_hasprefix_case(text, prefix)
	var/start = 1
	var/end = length(prefix) + 1
	return findtextEx(text, prefix, start, end)

//Checks the end of a string for a specified substring.
//Returns the position of the substring or 0 if it was not found
/proc/dd_hassuffix(text, suffix)
	var/start = length(text) - length(suffix)
	if(start)
		return findtext(text, suffix, start, null)
	return

//Checks the end of a string for a specified substring. This proc is case sensitive
//Returns the position of the substring or 0 if it was not found
/proc/dd_hassuffix_case(text, suffix)
	var/start = length(text) - length(suffix)
	if(start)
		return findtextEx(text, suffix, start, null)

/*
 * Text modification
 */
/proc/replaceText(text, find, replacement)
	return list2text(text2list(text, find), replacement)

/proc/replaceTextEx(text, find, replacement)
	return list2text(text2listEx(text, find), replacement)

//Adds 'u' number of zeros ahead of the text 't'
/proc/add_zero(t, u)
	while (length(t) < u)
		t = "0[t]"
	return t

//Adds 'u' number of spaces ahead of the text 't'
/proc/add_lspace(t, u)
	while(length(t) < u)
		t = " [t]"
	return t

//Adds 'u' number of spaces behind the text 't'
/proc/add_tspace(t, u)
	while(length(t) < u)
		t = "[t] "
	return t

//Returns a string with reserved characters and spaces before the first letter removed
/proc/trim_left(text)
	for (var/i = 1 to length(text))
		if (text2ascii(text, i) > 32)
			return copytext_char(text, i)
	return ""

//Returns a string with reserved characters and spaces after the last letter removed
/proc/trim_right(text)
	for (var/i = length(text), i > 0, i--)
		if (text2ascii(text, i) > 32)
			return copytext_char(text, 1, i + 1)

	return ""

//Returns a string with reserved characters and spaces before the first word and after the last word removed.
/proc/trim(text)
	return trim_left(trim_right(text))

//Returns a string with the first element of the string capitalized.
/proc/capitalize(var/t as text)
	return uppertext(copytext_char(t, 1, 2)) + copytext_char(t, 2)

/proc/decapitalize(var/t as text)
	return lowertext(copytext_char(t, 1, 2)) + copytext_char(t, 2)

//Centers text by adding spaces to either side of the string.
/proc/dd_centertext(message, length)
	var/new_message = message
	var/size = length(message)
	var/delta = length - size
	if(size == length)
		return new_message
	if(size > length)
		return copytext_char(new_message, 1, length + 1)
	if(delta == 1)
		return new_message + " "
	if(delta % 2)
		new_message = " " + new_message
		delta--
	var/spaces = add_lspace("",delta/2-1)
	return spaces + new_message + spaces

//Limits the length of the text. Note: MAX_MESSAGE_LEN and MAX_NAME_LEN are widely used for this purpose
/proc/dd_limittext(message, length)
	var/size = length(message)
	if(size <= length)
		return message
	return copytext_char(message, 1, length + 1)


/proc/stringmerge(var/text,var/compare,replace = "*")
//This proc fills in all spaces with the "replace" var (* by default) with whatever
//is in the other string at the same spot (assuming it is not a replace char).
//This is used for fingerprints
	var/newtext = text
	if(length(text) != length(compare))
		return 0
	for(var/i = 1, i < length(text), i++)
		var/a = copytext_char(text,i,i+1)
		var/b = copytext_char(compare,i,i+1)
//if it isn't both the same letter, or if they are both the replacement character
//(no way to know what it was supposed to be)
		if(a != b)
			if(a == replace) //if A is the replacement char
				newtext = copytext_char(newtext,1,i) + b + copytext_char(newtext, i+1)
			else if(b == replace) //if B is the replacement char
				newtext = copytext_char(newtext,1,i) + a + copytext_char(newtext, i+1)
			else //The lists disagree, Uh-oh!
				return 0
	return newtext

/proc/stringpercent(var/text,character = "*")
//This proc returns the number of chars of the string that is the character
//This is used for detective work to determine fingerprint completion.
	if(!text || !character)
		return 0
	var/count = 0
	for(var/i = 1, i <= length(text), i++)
		var/a = copytext_char(text,i,i+1)
		if(a == character)
			count++
	return count

/proc/reverse_text(var/text = "")
	var/new_text = ""
	for(var/i = length(text); i > 0; i--)
		new_text += copytext_char(text, i, i+1)
	return new_text

/proc/upperrustext(text as text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (a > 223)
			t += ascii2text(a - 32)
		else if (a == 184)
			t += ascii2text(168)
		else t += ascii2text(a)
	t = replacetext(t,"&#255;","�")
	return t


/proc/lowerrustext(text as text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (a > 191 && a < 224)
			t += ascii2text(a + 32)
		else if (a == 168)
			t += ascii2text(184)
		else t += ascii2text(a)
	return t

/proc/rhtml_encode(var/msg)
	var/list/c = text2list(msg, "�")
	if(c.len == 1)
		c = text2list(msg, "&#255;")
		if(c.len == 1)
			return html_encode(msg)
	var/out = ""
	var/first = 1
	for(var/text in c)
		if(!first)
			out += "&#255;"
		first = 0
		out += html_encode(text)
	return out

/proc/rhtml_encode_paper(var/msg)
	var/list/c = text2list(msg, "�")
	if(c.len == 1)
		c = text2list(msg, "&#1103;")
		if(c.len == 1)
			return html_encode(msg)
	var/out = ""
	var/first = 1
	for(var/text in c)
		if(!first)
			out += "&#1103;"
		first = 0
		out += html_encode(text)
	return out

/proc/rhtml_decode(var/msg)
	var/list/c = text2list(msg, "�")
	if(c.len == 1)
		c = text2list(msg, "&#255;")
		if(c.len == 1)
			return html_decode(msg)
	var/out = ""
	var/first = 1
	for(var/text in c)
		if(!first)
			out += "&#255;"
		first = 0
		out += html_decode(text)
	return out

/proc/rhtml_decode_paper(var/msg)
	var/list/c = text2list(msg, "�")
	if(c.len == 1)
		c = text2list(msg, "&#1103;")
		if(c.len == 1)
			return html_decode(msg)
	var/out = ""
	var/first = 1
	for(var/text in c)
		if(!first)
			out += "&#1103;"
		first = 0
		out += html_decode(text)
	return out


//Used in preferences' SetFlavorText and human's set_flavor verb
//Previews a string of len or less length
proc/TextPreview(var/string,var/len=40)
	if(length(string) <= len)
		if(!length(string))
			return "\[...\]"
		else
			return sanitize(string)
	else
		return "[sanitize(copytext_char(string, 1, 37))]..."