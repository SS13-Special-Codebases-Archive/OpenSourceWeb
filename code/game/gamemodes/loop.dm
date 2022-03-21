#define KS_SHIFT_SHIFT	1
#define KS_SHIFT_CTRL	2
#define KS_SHIFT_ALT	4

#define KS_BACKSPACE 8
#define KS_TAB		9

#define KS_NUM_CENTER	12

#define KS_ENTER	13

#define KS_SHIFT	16
#define KS_CTRL		17
#define KS_ALT		18

#define KS_BREAK	19

#define KS_CAPSLOCK	20
#define KS_ESCAPE	27

#define KS_SPACE	32

#define KS_PAGEUP	33
#define KS_PAGEDOWN	34
#define KS_END		35
#define KS_HOME		36

#define KS_LEFT		37
#define KS_UP		38
#define KS_RIGHT	39
#define KS_DOWN		40

#define KS_INSERT	45
#define KS_DEL		46

#define KS_0		48
#define KS_1		49
#define KS_2		50
#define KS_3		51
#define KS_4		52
#define KS_5		53
#define KS_6		54
#define KS_7		55
#define KS_8		56
#define KS_9		57

#define KS_A		65
#define KS_B		66
#define KS_C		67
#define KS_D		68
#define KS_E		69
#define KS_F		70
#define KS_G		71
#define KS_H		72
#define KS_I		73
#define KS_J		74
#define KS_K		75
#define KS_L		76
#define KS_M		77
#define KS_N		78
#define KS_O		79
#define KS_P		80
#define KS_Q		81
#define KS_R		82
#define KS_S		83
#define KS_T		84
#define KS_U		85
#define KS_V		86
#define KS_W		87
#define KS_X		88
#define KS_Y		89
#define KS_Z		90


#define KS_NUM_0	96
#define KS_NUM_1	97
#define KS_NUM_2	98
#define KS_NUM_3	99
#define KS_NUM_4	100
#define KS_NUM_5	101
#define KS_NUM_6	102
#define KS_NUM_7	103
#define KS_NUM_8	104
#define KS_NUM_9	105
#define KS_NUM_ASTERISK	106
#define KS_NUM_ADD		107
#define KS_NUM_SUBTRACT	109
#define KS_NUM_PERIOD	110
#define KS_NUM_SLASH	111

#define KS_F1	112
#define KS_F2	113
#define KS_F3	114
#define KS_F4	115
#define KS_F5	116
#define KS_F6	117
#define KS_F7	118
#define KS_F8	119
#define KS_F9	120
#define KS_F10	121
#define KS_F11	122
#define KS_F12	123

#define KS_NUM_LOCK		144
#define KS_SCROLL_LOCK	145

#define KS_COLON	186
#define KS_EQUAL	187
#define KS_COMMA	188
#define KS_SUBTRACT	189
#define KS_PERIOD	190
#define KS_SLASH	191
#define KS_BACK_APOSTROPHE 192

#define KS_OPEN_BRACKET	219
#define KS_BACKSLASH	220
#define KS_CLOSE_BRACKET 221
#define KS_APOSTROPHE	222

client
	var/manual_focus = 0
	proc
		KeyDown(KeyCode,shift)
		KeyUp(KeyCode,shift)
KeyState
	var/key_repeat = 0
	var/open = 1
	proc
		open()
			open = 1
			if(client)client.KeyFocus()
		close()
			open = 0
			if(client)client<<browse(null,null)
/*
KeyState library
Created by Loduwijk
June 2005
*/

proc/keycode2char(N)
	switch(N)
		if(9)return "	"
		if(13)return ascii2text(13)
		if(32)return " "
		if(48 to 57)
			return ascii2text(N)
		if(65 to 90)
			return ascii2text(N)
		if(186)return ";"
		if(187)return "="
		if(188)return ","
		if(189)return "-"
		if(190)return "."
		if(191)return "/"
		if(192)return "`"
		if(219)return "\["
		if(220)return "\\"
		if(221)return "]"
		if(222)return "'"
		else return 0

KeyState
	var
		client/client
		shift = 0
		list/key[255]
		mouse_x=0;mouse_y=0
	New(client/C)
		if(C)client=C
		var/index
		for(index = 1 to 255)
			key[index]=0
	proc
		Update(event,KeyCode)
			var/T=KeyCode
			KeyCode=text2num(KeyCode)
			switch(event)
				if("KeyUp")
					if(key[KeyCode])
						key[KeyCode]=0
						switch(KeyCode)
							if(16)shift&=~1
							if(17)shift&=~2
							if(18)shift&=~4
						if(client)client.KeyUp(KeyCode,shift)
				if("KeyDown")
					if(!key[KeyCode])
						key[KeyCode]=1
						switch(KeyCode)
							if(16)shift|=1
							if(17)shift|=2
							if(18)shift|=4
						if(client)client.KeyDown(KeyCode,shift)
					else if(key_repeat&&client)client.KeyDown(KeyCode)
				if("MouseCoordinate")
					mouse_x=copytext(T,1,findtext(T,","))
					mouse_y=copytext(T,findtext(T,",")+1,0)

client
	var
		KeyState/keystate
		resolution
		avail_resolution
		system_type
		color_quality
	Topic(href,href_list[])
		if("action" in href_list)
			if(href_list["action"]=="KeyState")
				var/event = href_list[2]
				keystate.Update(event,href_list[event])
			if(href_list["action"]=="infosetup")
				resolution=href_list["resolution"]
				avail_resolution=href_list["availresolution"]
				color_quality=href_list["color"]
				system_type=href_list["os"]
		return ..()
	verb/manual_focus()
		set hidden = 1
		if(!keystate)return
		if(manual_focus&&keystate.open)
			KeyFocus()
	proc
		//info return functions
		resolution()return resolution
		avail_resolution()return avail_resolution
		system_type()return system_type
		color_quality()return color_quality
		//action functions
		key_repeat(repeat)keystate.key_repeat=repeat
		KeySetup(focus=1)
			keystate=new(src)
			if(focus)KeyFocus()
		InfoSetup()
			src<<browse({"
<html>
<head>
</head>
<body>
<script type="text/javascript">
resolution=screen.width+","+screen.height
avail_res=screen.availWidth+","+screen.availHeight
avail_y=screen.availHeight
color=screen.colorDepth
os=navigator.platform
window.location="?action=infosetup&resolution="+resolution+"&availresolution="+avail_res+"&color="+color+"&os="+os
</script>
</body>
</html>
"},"window=infosetup;size=0x0;can_resize=0;titlebar=0")
		MouseUpdate()
			src<<browse({"
<html>
<head>
<script type="text/javascript">
function coordinate(event)
{
window.location="?action=KeyState&MouseCoordinate="+event.screenX+","+event.screenY
}
</script>
</head>
<body onload="coordinate(event)">
</body>
</html>
"},"window=coordinate;size=0x0;can_resize=0;titlebar=0")

		KeyFocus()
			var/key_repeat_code
			if(keystate.key_repeat)
				key_repeat_code = {"
<html>
<head>
<script type="text/javascript">
function KeyUp(event)
{
	window.location="?action=KeyState&KeyUp="+event.keyCode
}
function KeyDown(event)
{
	window.location="?action=KeyState&KeyDown="+event.keyCode
}
</script>
</head>
<body onkeydown="KeyDown(event)" onkeyup="KeyUp(event)">
<script type="text/javascript">
this.focus()
</script>
</body></html>"}
			else
				key_repeat_code = {"
<html>
<head>
<script type="text/javascript">
function KeyUp(event)
{
	window.location="?action=KeyState&KeyUp="+event.keyCode
	down\[event.keyCode]=0
}
function KeyDown(event)
{
if(down\[event.keyCode]==0)
{
	down\[event.keyCode]=1
	window.location="?action=KeyState&KeyDown="+event.keyCode
}
}
</script>
</head>
<body onkeydown="KeyDown(event)" onkeyup="KeyUp(event)">
<script type="text/javascript">
down = new Array(255);
for(index=0; index<255; index+=1)
{
	down\[index]=0;
}
this.focus()
</script>
</body></html>"}
			src<<browse(key_repeat_code,"window=KeyEvent;size=0x0;can_resize=0;titlebar=0")

var/list/opposite_dirs = list(SOUTH,NORTH,null,WEST,null,null,null,EAST)

/client
	var/tmp
		mloop = 0
		move_dir = 0 //keep track of the direction the player is currently trying to move in.
		true_dir = 0
		keypresses = 0
		CAN_MOVE_DIAGONALLY = 0

	//rebind your interface so that your north/south/east/west keypresses are bound to:
	//keydown: MoveKey [Direction] 1
	//keyup: MoveKey [Direction] 0
	//Directions:
	//NORTH = 1
	//SOUTH = 2
	//EAST = 4
	//WEST = 8

/client/verb/MoveKey(Dir as num,State as num)
	set hidden = 1
	set instant = 1
	//if we are currently not moving at the start of this function call, set a flag for later
	if(!move_dir)
		. = 1
	//get the opposite direction
	var/opposite = opposite_dirs[Dir]
	if(State)
		//turn on the bitflags
		move_dir |= Dir
		keypresses |= Dir
		//make sure that conflicting directions result in the newest one being dominant.
		if(opposite&keypresses)
			move_dir &= ~opposite

	else
		//turn off the bitflags
		move_dir &= ~Dir
		keypresses &= ~Dir

		//restore non-dominant directional keypress
		if(opposite&keypresses)
			move_dir |= opposite

		else
			move_dir |= keypresses

	if(CAN_MOVE_DIAGONALLY)
		true_dir = move_dir
	else
		true_dir = move_dir^(move_dir&move_dir-1)

	//if earlier flag was set, and we now are going to be moving
	if(.&&true_dir)
		move_loop()

/client/North()
/client/South()
/client/East()
/client/West()

/client/proc/move_loop()
	set waitfor = 0
	if(src.mloop) return
	mloop = 1
	src.Move(mob.loc,true_dir)
	while(src.true_dir)
		sleep(world.tick_lag)
		if(src.true_dir)
			src.Move(mob.loc,true_dir)
	mloop = 0