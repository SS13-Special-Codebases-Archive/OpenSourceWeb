#define MC_TICK_CHECK ( world.tick_usage > CURRENT_TICKLIMIT ? pause() : 0 )
// Used to smooth out costs to try and avoid oscillation.
#define MC_AVERAGE_FAST(average, current) (0.7 * (average) + 0.3 * (current))
#define MC_AVERAGE(average, current) (0.8 * (average) + 0.2 * (current))
#define MC_AVERAGE_SLOW(average, current) (0.9 * (average) + 0.1 * (current))
#define NEW_SS_GLOBAL(varname) if(varname != src){if(istype(varname)){Recover();qdel(varname);}varname = src;}

#define START_PROCESSING(Processor, Datum) if (!Datum.isprocessing) {Datum.isprocessing = 1;Processor.processing += Datum}
#define STOP_PROCESSING(Processor, Datum) Datum.isprocessing = 0;Processor.processing -= Datum

//SubSystem flags (Please design any new flags so that the default is off, to make adding flags to subsystems easier)

//subsystem should fire during pre-game lobby.
#define SS_FIRE_IN_LOBBY 1

//subsystem does not initialize.
#define SS_NO_INIT 2

//subsystem does not fire.
//	(like can_fire = 0, but keeps it from getting added to the processing subsystems list)
//	(Requires a MC restart to change)
#define SS_NO_FIRE 4

//subsystem only runs on spare cpu (after all non-background subsystems have ran that tick)
//	SS_BACKGROUND has its own priority bracket
#define SS_BACKGROUND 8

//subsystem does not tick check, and should not run unless there is enough time (or its running behind (unless background))
#define SS_NO_TICK_CHECK 16

//Treat wait as a tick count, not DS, run every wait ticks.
//	(also forces it to run first in the tick, above even SS_NO_TICK_CHECK subsystems)
//	(implies SS_FIRE_IN_LOBBY because of how it works)
//	(overrides SS_BACKGROUND)
//	This is designed for basically anything that works as a mini-mc (like SStimer)
#define SS_TICKER 32

//keep the subsystem's timing on point by firing early if it fired late last fire because of lag
//	ie: if a 20ds subsystem fires say 5 ds late due to lag or what not, its next fire would be in 15ds, not 20ds.
#define SS_KEEP_TIMING 64

//Calculate its next fire after its fired.
//	(IE: if a 5ds wait SS takes 2ds to run, its next fire should be 5ds away, not 3ds like it normally would be)
//	This flag overrides SS_KEEP_TIMING
#define SS_POST_FIRE_TIMING 128

//Timing subsystem
#define TIMER_NORMAL	"normal"
#define TIMER_UNIQUE	"unique"
#define isnum_safe(x) ( isnum((x)) && !isnan((x)) && !isinf((x)) )

#define isnan(x) ( (x) != (x) )

#define isinf(x) (isnum((x)) && (((x) == text2num("inf")) || ((x) == text2num("-inf"))))
// Define o macro da IZ.
#define INTERZONE "IZ"
// Define o macro da BRZ.
#define BRZONE "BR"

// TODO: Escrever um script para modificar isso em runtime.
#define CURRENT_LANG BRZONE

// Define o macro SRVR_LANG
#define SRVR_LANG server_language
// Checa se a VARIÁVEL server_language é BRzone.
#define CHCKV_BRZ SRVR_LANG == BRZONE
// Checa se a VARIÁVEL server_language é Interzone.
#define CHCKV_IZ SRVR_LANG == INTERZONE
// Checa se o MACRO CURRENT_LANG é Interzone.
#define CHECKM_IZ CURRENT_LANG == INTERZONE
// Checa se o MACRO CURRENT_LANG é BRzone.
#define CHECKM_BRZ CURRENT_LANG == BRZONE

// Troca a VARIÁVEL server_language para o idioma especificado.
#define SET_LANG(X) SRVR_LANG = X

// Define o macro que lista a porta da BRzone.
#define BRZ_PORT 1984
// Define o macro que lista a porta da Interzone (S2).
#define IZ2_PORT 2422
// Define o macro que lista a porta da Interzone (S1).
#define IZ1_PORT 1923
// Festa privada.
#define SHROOM_PORT 1969
// Define o macro que lista a porta do servidor de testes (S3).
#define IZ3_PORT 9530

// Quantidade máxima de pessoas que um comrade pode convidar.
#define MAX_COMRADE_INVITES 14

#define ceil(x) (-round(-(x)))

#define hash_password(options) json_decode(call("ByondSharpNE", "Hash")(options))["Data"]
#define verify_password(option1, option2) json_decode(call("ByondSharpNE", "VerifyPassword")(option1, option2))["Data"]
#define init_discord json_decode(call("ByondSharpNE", "Initialize")())["Data"]
#define send_roundend_embed json_decode(call("ByondSharpNE", "OnRoundEnd")(current_server))["Data"]
#define send_roundstart_embed json_decode(call("ByondSharpNE", "OnRoundStart")(current_server, "[world.port]"))["Data"]
#define register_user(options) json_decode(call("ByondSharpNE", "HandleRegistration")(options))["Data"]
#define do_discord_ban(options) json_decode(call("ByondSharpNE","HandleBan")(options))["Data"]

#define EGG_DELAY 5 MINUTES
#define SPIT_DELAY 16 SECONDS
#define WEED_DELAY 60 SECONDS