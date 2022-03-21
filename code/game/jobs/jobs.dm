
var/const/ENGSEC			=(1<<0)

var/const/CAPTAIN			=(1<<0)
var/const/HOS				=(1<<1)
var/const/WARDEN			=(1<<2)
var/const/DETECTIVE			=(1<<3)
var/const/OFFICER			=(1<<4)
var/const/CHIEF				=(1<<5)
var/const/ENGINEER			=(1<<6)
var/const/ATMOSTECH			=(1<<7)
var/const/AI				=(1<<8)
var/const/CYBORG			=(1<<9)
var/const/SQUIRE			=(1<<10)
var/const/BARONESS			=(1<<11)
var/const/GATEKEEPER		=(1<<12)
var/const/HEIR				=(1<<13)
var/const/INQUISITOR		=(1<<14)
var/const/CHAPLAIN			=(1<<15)
var/const/SHERIFF			=(1<<16)
var/const/SUCCESSOR			=(1<<17)
var/const/MAID				=(1<<18)
var/const/NUN				=(1<<19)
var/const/MEISTERDISC		=(1<<20)
var/const/PRACTICUS			=(1<<21)
var/const/BGUARD			=(1<<22)
var/const/HAND				=(1<<23)

var/const/MEDSCI			=(1<<1)

var/const/RD				=(1<<0)
var/const/SCIENTIST			=(1<<1)
var/const/CHEMIST			=(1<<2)
var/const/CMO				=(1<<3)
var/const/DOCTOR			=(1<<4)
var/const/GENETICIST		=(1<<5)
var/const/VIROLOGIST		=(1<<6)
var/const/INNKEEPERWIFE		=(1<<7)
var/const/CONSYTE			=(1<<8)
var/const/SCUFF				=(1<<9)
var/const/GUEST				=(1<<10)
var/const/TRIBVET			=(1<<11)
var/const/MERC			    =(1<<12)
var/const/URCHIN		    =(1<<13)
var/const/CHEMSIS		    =(1<<14)
var/const/ARMORSMITH		=(1<<15)
var/const/METALSMITH		=(1<<16)
var/const/FACKID			=(1<<17)

var/const/CIVILIAN			=(1<<2)

var/const/HOP				=(1<<0)
var/const/BARTENDER			=(1<<1)
var/const/BOTANIST			=(1<<2)
var/const/CHEF				=(1<<3)
var/const/JANITOR			=(1<<4)
var/const/MIGRANT			=(1<<5)
var/const/QUARTERMASTER		=(1<<6)
var/const/CARGOTECH			=(1<<7)
var/const/MINER				=(1<<8)
var/const/LAWYER			=(1<<9)
var/const/CLOWN				=(1<<10)
var/const/SITZFRAU			=(1<<11)
var/const/BUTLER			=(1<<12)
var/const/HOOKER			=(1<<13)
var/const/SMUGGLER			=(1<<14)
var/const/HOBO				=(1<<15)
var/const/WEAPONSMITH		=(1<<16)
var/const/SERVANT			=(1<<17)
var/const/APPRENTICE		=(1<<18)
var/const/MORTUS			=(1<<19)
var/const/SNIFFER			=(1<<20)
var/const/ASSISTANT			=(1<<21)
var/const/SIEGER			=(1<<24)

var/list/assistant_occupations = list(
)


var/list/baronfamily = list(
	"Baron",
	"Heir",
	"Successor",
	"Baroness"
//	"Chief Medical Officer"
)

var/list/command_positions = list(
	"Baron",
	"Marduk",
	"Hand",
	"Heir",
	"Baroness",
	"Successor",
	"Meister",
	"Inquisitor",
	"Treasurer"
//	"Chief Medical Officer"
)


var/list/engineering_positions = list(
	"Hump",
	"Mortus"
)


var/list/medical_positions = list(
	"Esculap",
	"Serpent"
)


var/list/science_positions = list(
	"Research Director"
)

//BS12 EDIT
var/list/civilian_positions = list(
	"Innkeeper",
	"Innkeeper Wife",
	"Soiler",
	"Misero",
	"Bookkeeper",
	"Grayhound",
	"Arbiter",
	"Bishop",
	"Practicus",
	"Jester",
	"Amuser",
	"Pusher",
	"Bum",
	"Heir",
	"Unassigned",
	"Servant",
	"Apprentice",
	"Butler",
	"Sitzfrau",
	"Sniffer",
	"Consyte",
	"Maid",
	"Scuff",
	"Guest",
	"Sniffer"
)


var/list/security_positions = list(
	"Marduk",
	"Tiamat",
	"Incarn",
	"Squire",
	"Sheriff"
)


var/list/nonhuman_positions = list(
	"AI",
	"Cyborg",
	"pAI"
)
