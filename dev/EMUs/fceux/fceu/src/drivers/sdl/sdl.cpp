#include <unistd.h>
#include <sys/types.h>
#include <signal.h>
#include <sys/time.h>
#include <sys/stat.h>
#include <string.h>
#include <strings.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <limits.h>
#include <math.h>


#include "main.h"
#include "throttle.h"
#include "config.h"

#include "../common/cheat.h"
#include "../../fceu.h"
#include "../../movie.h"
#ifdef _S9XLUA_H
#include "../../fceulua.h"
#endif

#include "input.h"
#include "dface.h"

#include "sdl.h"
#include "sdl-video.h"
#include "unix-netplay.h"

#include "../common/configSys.h"

#ifdef CREATE_AVI
#include "../videolog/nesvideos-piece.h"
#endif

#include "../../oldmovie.h"
#include "../../types.h"

#ifdef WIN32
#include <windows.h>
#endif

extern double g_fpsScale;

extern bool MaxSpeed;

int CloseGame(void);

static int inited=0;
static int isloaded=0;	// Is game loaded?

int eoptions=0;

static void DriverKill(void);
static int DriverInitialize(FCEUGI *gi);
int gametype = 0;
#ifdef CREATE_AVI
int mutecapture;
#endif
static int noconfig;

char *DriverUsage="\
--pal          {0|1}   Uses PAL timing.\n\
--gamegenie    {0|1}   Enables emulated Game Genie.\n\
--nospritelim  {0|1}   Disables the 8 sprites per scanline limitation.\n\
--newppu       {0|1}   Enables the new PPU core. (WARNING: May break savestates)\n\
--frameskip     x      Sets # of frames to skip per emulated frame.\n\
--xres          x      Sets horizontal resolution to x for full screen mode.\n\
--yres          x      Sets vertical resolution to x for full screen mode.\n\
--autoscale    {0|1}   Enables autoscaling in fullscreen if x in nonzero. \n\
--keepratio    {0|1}   Keeps native NES ratio when autoscaling. \n\
--(x/y)scale    x      Multiplies width/height by x. \n\
                        (Real numbers >0 with OpenGL, otherwise integers >0).\n\
--(x/y)stretch {0|1}   Stretches to fill surface on x/y axis (OpenGL only).\n\
--bpp        {8|16|32} Sets bits per pixel.\n\
--opengl       {0|1}   Enables OpenGL support.\n\
--doublebuf    {0|1}   Enables SDL double-buffering if x is nonzero.\n\
--fullscreen   {0|1}   Enables full screen mode.\n\
--clipsides    {0|1}   Clips left and rightmost 8 columns of pixels.\n\
--noframe      {0|1}   Hides title bar and window decorations.\n\
--slstart    {0-239}   Sets the first drawn emulated scanline.\n\
--special     {1-4}    Use special video scaling filters\n\
                          (1 = hq2x 2 = Scale2x 3 = hq3x 4 = Scale3x)\n\
--slend      {0-239}   Sets the last drawn emulated scanline.\n\
--ntsccolor    {0|1}   Emulates an NTSC TV's colors.\n\
--hue           x      Sets hue for NTSC color emulation.\n\
--tint          x      Sets tint for NTSC color emulation.\n\
--palette       f      Loads a custom global palette from file f.\n\
--sound        {0|1}   Enables sound.\n\
--soundrate     x      Sets sound playback rate to x Hz.\n\
--soundq       {0|1}   Enables high sound quality.\n\
--soundbufsize  x      Sets sound buffer size to x ms.\n\
--volume      {0-150}  Sets volume.\n\
--trianglevol {0-256}  Sets Triangle volume.\n\
--square1vol  {0-256}  Sets Square 1 volume.\n\
--square2vol  {0-256}  Sets Square 2 volume.\n\
--noisevol    {0-256}  Sets Noise volume.\n\
--pcmvol      {0-256}  Sets PCM volume.\n\
--lowpass      {0|1}   Enables low-pass filter if x is nonzero.\n\
--soundrecord   f      Records sound to file f.\n\
--input(1,2)    d      Set the input device for input 1 or 2.\n\
                        Devices:  gamepad zapper powerpad.0 powerpad.1 arkanoid\n\
--input(3,4)    d      Set the famicom expansion device for input(3, 4)\n\
                        Devices: quizking hypershot mahjong toprider ftrainer\n\
                         familykeyboard oekakids arkanoid shadow bworld 4player\n\
--inputcfg      d      Configures input device d on startup.\n\
--inputdisplay{0|1|2|4}Displays game input.\n\
--playmov       f      Plays back a recorded movie from filename f.\n\
--pauseframe    x      Pauses movie playback at frame x.\n\
--fcmconvert    f      Converts fcm movie file f to fm2.\n\
--ripsubs       f      Converts movie's subtitles to srt\n\
--subtitles    {0,1}   Enables subtitle display\n\
--no-config    {0,1}   Don't change the config file";

/* Moved network options out while netplay is broken.
--net s, -n s	Connects to server 's' for TCP/IP network play.\n\
--port x, -p x	Uses TCP/IP port x for network play.\n\
--user s, -u s	Sets the nickname to use in network play.\n\
--pass s, -w s	Sets password to use for connecting to the server.\n\
--netkey s, -k s	Uses key 's' to create a unique session for the game loaded.\n\
--players x, -l x	Sets the number of local players.\n\
*/


// global configuration object
Config *g_config;

static void ShowUsage(char *prog)
{
	printf("\nUsage is as follows:\n%s <options> filename\n\n",prog);
	puts("Options:");
	puts(DriverUsage);
	#ifdef _S9XLUA_H
	puts ("--loadlua       f      Loads lua script from filename f.");
	#endif
	#ifdef CREATE_AVI
	puts ("--videolog      c      Calls mencoder to grab the video and audio streams to\n                       encode them. Check the documentation for more on this.");
	puts ("--mute         {0|1}   Mutes FCEUX while still passing the audio stream to\n                       mencoder.");
	#endif
	puts("");
}

/**
 * Prints an error string to STDOUT.
 */
void
FCEUD_PrintError(char *s)
{
    puts(s);
}

/**
 * Prints the given string to STDOUT.
 */
void FCEUD_Message(char *s)
{
    fputs(s, stdout);
}

/**
 * Loads a game, given a full path/filename.  The driver code must be
 * initialized after the game is loaded, because the emulator code
 * provides data necessary for the driver code(number of scanlines to
 * render, what virtual input devices to use, etc.).
 */
int LoadGame(const char *path)
{
    std::string filename;

    CloseGame();
    if(!FCEUI_LoadGame(path, 1)) {
        return 0;
    }
    ParseGIInput(GameInfo);
    RefreshThrottleFPS();

    if(!DriverInitialize(GameInfo)) {
        return(0);
    }

    g_config->getOption("SDL.SoundRecordFile", &filename);
    if(filename.size()) {
        if(!FCEUI_BeginWaveRecord(filename.c_str())) {
            g_config->setOption("SDL.SoundRecordFile", "");
        }
    }
    isloaded = 1;

    FCEUD_NetworkConnect();
    return 1;
}

/**
 * Closes a game.  Frees memory, and deinitializes the drivers.
 */
int
CloseGame()
{
    std::string filename;

    if(!isloaded) {
        return(0);
    }
    FCEUI_CloseGame();
    DriverKill();
    isloaded = 0;
    GameInfo = 0;

    g_config->getOption("SDL.SoundRecordFile", &filename);
    if(filename.size()) {
        FCEUI_EndWaveRecord();
    }

    InputUserActiveFix();
    return(1);
}

void FCEUD_Update(uint8 *XBuf, int32 *Buffer, int Count);

static void DoFun(int frameskip)
{
    uint8 *gfx;
    int32 *sound;
    int32 ssize;
    static int fskipc = 0;
    static int opause = 0;

#ifdef FRAMESKIP
    fskipc = (fskipc + 1) % (frameskip + 1);
#endif

    if(NoWaiting) {
        gfx = 0;
    }
    FCEUI_Emulate(&gfx, &sound, &ssize, fskipc);
    FCEUD_Update(gfx, sound, ssize);

    if(opause!=FCEUI_EmulationPaused()) {
        opause=FCEUI_EmulationPaused();
        SilenceSound(opause);
    }
}


/**
 * Initialize all of the subsystem drivers: video, audio, and joystick.
 */
static int
DriverInitialize(FCEUGI *gi)
{
#ifndef WIN32
    // XXX soules - capturing all these signals seems pointless
    //SetSignals(CloseStuff);
#endif

    /* Initialize video before all else, due to some wacko dependencies
       in the SexyAL code(DirectSound) that need to be fixed.
    */

    if(InitVideo(gi) < 0) return 0;
    inited|=4;

    if(InitSound(gi))
        inited|=1;

    if(InitJoysticks())
        inited|=2;

    InitInputInterface();
    return 1;
}

/**
 * Shut down all of the subsystem drivers: video, audio, and joystick.
 */
static void
DriverKill()
{
    if (!noconfig)
        g_config->save();

#ifndef WIN32
    // XXX soules - capturing all these signals seems pointless
    //SetSignals(SIG_IGN);
#endif

    if(inited&2)
        KillJoysticks();
    if(inited&4)
        KillVideo();
    if(inited&1)
        KillSound();
    inited=0;
}

/**
 * Update the video, audio, and input subsystems with the provided
 * video (XBuf) and audio (Buffer) information.
 */
void
FCEUD_Update(uint8 *XBuf,
             int32 *Buffer,
             int Count)
{
    extern int FCEUDnetplay;

    #ifdef CREATE_AVI
    if(LoggingEnabled == 2 || (eoptions&EO_NOTHROTTLE))
    {
      if(LoggingEnabled == 2)
      {
        int16* MonoBuf = (int16*)malloc(sizeof(*MonoBuf) * Count);
        int n;
        for(n=0; n<Count; ++n)
            MonoBuf[n] = Buffer[n] & 0xFFFF;
        NESVideoLoggingAudio
         (
          MonoBuf, 
          FSettings.SndRate, 16, 1,
          Count
         );
        free(MonoBuf);
      }
      Count /= 2;
      if(inited & 1)
      {
        if(Count > GetWriteSound()) Count = GetWriteSound();
        if (!mutecapture)
          if(Count > 0 && Buffer) WriteSound(Buffer,Count);   
      }
      if(inited & 2)
        FCEUD_UpdateInput();
      if(XBuf && (inited & 4)) BlitScreen(XBuf);
      
      //SpeedThrottle();
        return;
     }
    #endif
    
    int ocount = Count;
    // apply frame scaling to Count
    Count = (int)(Count / g_fpsScale);
    if(Count) {
        int32 can=GetWriteSound();
        static int uflow=0;
        int32 tmpcan;

        // don't underflow when scaling fps
        if(can >= GetMaxSound() && g_fpsScale==1.0) uflow=1;	/* Go into massive underflow mode. */

        if(can > Count) can=Count;
        else uflow=0;

        #ifdef CREATE_AVI
        if (!mutecapture)
        #endif
          WriteSound(Buffer,can);

        //if(uflow) puts("Underflow");
        tmpcan = GetWriteSound();
        // don't underflow when scaling fps
        if(g_fpsScale>1.0 || ((tmpcan < Count*0.90) && !uflow)) {
            if(XBuf && (inited&4) && !(NoWaiting & 2))
                BlitScreen(XBuf);
            Buffer+=can;
            Count-=can;
            if(Count) {
                if(NoWaiting) {
                    can=GetWriteSound();
                    if(Count>can) Count=can;
                    #ifdef CREATE_AVI
                    if (!mutecapture)
                    #endif
                      WriteSound(Buffer,Count);
                } else {
                    while(Count>0) {
                        #ifdef CREATE_AVI
                        if (!mutecapture)
                        #endif
                          WriteSound(Buffer,(Count<ocount) ? Count : ocount);
                        Count -= ocount;
                    }
                }
            }
        } //else puts("Skipped");
        else if(!NoWaiting && FCEUDnetplay && (uflow || tmpcan >= (Count * 1.8))) {
            if(Count > tmpcan) Count=tmpcan;
            while(tmpcan > 0) {
                //    printf("Overwrite: %d\n", (Count <= tmpcan)?Count : tmpcan);
                #ifdef CREATE_AVI
                if (!mutecapture)
                #endif
                  WriteSound(Buffer, (Count <= tmpcan)?Count : tmpcan);
                tmpcan -= Count;
            }
        }

    } else {
        if(!NoWaiting && (!(eoptions&EO_NOTHROTTLE) || FCEUI_EmulationPaused()))
        while (SpeedThrottle())
        {
            FCEUD_UpdateInput();
        }
        if(XBuf && (inited&4)) {
            BlitScreen(XBuf);
        }
    }
    FCEUD_UpdateInput();
    //if(!Count && !NoWaiting && !(eoptions&EO_NOTHROTTLE))
    // SpeedThrottle();
    //if(XBuf && (inited&4))
    //{
    // BlitScreen(XBuf);
    //}
    //if(Count)
    // WriteSound(Buffer,Count,NoWaiting);
    //FCEUD_UpdateInput();
}


/* Maybe ifndef WXWINDOWS would be better? ^_^ */
/**
 * Opens a file to be read a byte at a time.
 */
std::fstream* FCEUD_UTF8_fstream(const char *fn, const char *m)
{
	std::ios_base::openmode mode = std::ios_base::binary;
	if(!strcmp(m,"r") || !strcmp(m,"rb"))
		mode |= std::ios_base::in;
	else if(!strcmp(m,"w") || !strcmp(m,"wb"))
		mode |= std::ios_base::out | std::ios_base::trunc;
	else if(!strcmp(m,"a") || !strcmp(m,"ab"))
		mode |= std::ios_base::out | std::ios_base::app;
	else if(!strcmp(m,"r+") || !strcmp(m,"r+b"))
		mode |= std::ios_base::in | std::ios_base::out;
	else if(!strcmp(m,"w+") || !strcmp(m,"w+b"))
		mode |= std::ios_base::in | std::ios_base::out | std::ios_base::trunc;
	else if(!strcmp(m,"a+") || !strcmp(m,"a+b"))
		mode |= std::ios_base::in | std::ios_base::out | std::ios_base::app;

	return new std::fstream(fn,mode);
}

/**
 * Opens a file, C++ style, to be read a byte at a time.
 */
FILE *FCEUD_UTF8fopen(const char *fn, const char *mode)
{
    return(fopen(fn,mode));
}

static char *s_linuxCompilerString = "g++ " __VERSION__;
/**
 * Returns the compiler string.
 */
const char *FCEUD_GetCompilerString() {
    return (const char *)s_linuxCompilerString;
}

/**
 * Unimplemented.
 */
void FCEUD_DebugBreakpoint() {
    return;
}

/**
 * Unimplemented.
 */
void FCEUD_TraceInstruction() {
    return;
}


/**
 * The main loop for the SDL.
 */
int
main(int argc,
     char *argv[])
{
    int error, frameskip;

    FCEUD_Message("\nStarting "FCEU_NAME_AND_VERSION"...\n");

#ifdef WIN32
    /* Taken from win32 sdl_main.c */
    SDL_SetModuleHandle(GetModuleHandle(NULL));
#endif

    /* SDL_INIT_VIDEO Needed for (joystick config) event processing? */
    if(SDL_Init(SDL_INIT_VIDEO)) {
        printf("Could not initialize SDL: %s.\n", SDL_GetError());
        return(-1);
    }

#ifdef OPENGL
SDL_GL_LoadLibrary(0);
#endif

    // Initialize the configuration system
    g_config = InitConfig();
	
    if(!g_config) {
        SDL_Quit();
        return -1;
    }

    // initialize the infrastructure
    error = FCEUI_Initialize();
    if(error != 1) {
        ShowUsage(argv[0]);
        SDL_Quit();
        return -1;
    }

    int romIndex = g_config->parse(argc, argv);

	//mbg 8/23/2008 - this is also here so that the inputcfg routines can have a chance to dump the new inputcfg to the fceux.cfg
	//in case you didnt specify a rom filename
	  // This is here so that a default fceux.cfg will be created on first
	  // run, even without a valid ROM to play.
	  // Unless, of course, there's actually --no-config given
	  g_config->getOption("SDL.NoConfig", &noconfig);
	  if (!noconfig)
	    g_config->save();
	std::string s;
	g_config->getOption("SDL.InputCfg", &s);
	
	// update the input devices
    UpdateInput(g_config);

    // check for a .fcm file to convert to .fm2
    g_config->getOption ("SDL.FCMConvert", &s);
    g_config->setOption ("SDL.FCMConvert", "");
    if (!s.empty())
    {
      int okcount = 0;
      std::string infname = s.c_str();
      // produce output filename
      std::string outname;
      size_t dot = infname.find_last_of (".");
      if (dot == std::string::npos)
        outname = infname + ".fm2";
      else
        outname = infname.substr(0,dot) + ".fm2";
      
      MovieData md;
      EFCM_CONVERTRESULT result = convert_fcm (md, infname);
      
      if (result == FCM_CONVERTRESULT_SUCCESS)
      {
        okcount++;
        std::fstream* outf = FCEUD_UTF8_fstream (outname, "wb");
        md.dump (outf,false);
        delete outf;
        FCEUD_Message ("Your file has been converted to FM2.\n");
      } else {
        FCEUD_Message ("Something went wrong while converting your file...\n");
      }
      
      DriverKill();
      SDL_Quit();
      return 0;
    }
    
    // check for a .fm2 file to rip the subtitles
    g_config->getOption("SDL.RipSubs", &s);
    g_config->setOption("SDL.RipSubs", "");
    if (!s.empty())
    {
      MovieData md;
      std::string infname;
      infname = s.c_str();
      FCEUFILE *fp = FCEU_fopen(s.c_str(), 0, "rb", 0);
      
      // load the movie and and subtitles
      extern bool LoadFM2(MovieData&, std::istream*, int, bool);
      LoadFM2(md, fp->stream, INT_MAX, false);
      LoadSubtitles(md); // fill subtitleFrames and subtitleMessages
      delete fp;
      
      // produce .srt file's name and open it for writing
      std::string outname;
      size_t dot = infname.find_last_of (".");
      if (dot == std::string::npos)
        outname = infname + ".srt";
      else
        outname = infname.substr(0,dot) + ".srt";
      FILE *srtfile;
      srtfile = fopen(outname.c_str(), "w");
      
      if (srtfile != NULL)
      {
        extern std::vector<int> subtitleFrames;
        extern std::vector<std::string> subtitleMessages;
        float fps = (md.palFlag == 0 ? 60.0988 : 50.0069); // NTSC vs PAL
        float subduration = 3; // seconds for the subtitles to be displayed
        for (int i = 0; i < subtitleFrames.size(); i++)
        {
          fprintf(srtfile, "%i\n", i+1); // starts with 1, not 0
          double seconds, ms, endseconds, endms;
          seconds = subtitleFrames[i]/fps;
          if (i+1 < subtitleFrames.size()) // there's another subtitle coming after this one
          {
            if (subtitleFrames[i+1]-subtitleFrames[i] < subduration*fps) // avoid two subtitles at the same time
            {
              endseconds = (subtitleFrames[i+1]-1)/fps; // frame x: subtitle1; frame x+1 subtitle2
            } else {
              endseconds = seconds+subduration;
            }
          } else {
            endseconds = seconds+subduration;
          }
          ms = modf(seconds, &seconds);
          endms = modf(endseconds, &endseconds);
          // this is just beyond ugly, don't show it to your kids
          fprintf(srtfile,
            "%02.0f:%02d:%02d,%03d --> %02.0f:%02d:%02d,%03d\n", // hh:mm:ss,ms --> hh:mm:ss,ms
            floor(seconds/3600),    (int)floor(seconds/60   ) % 60, (int)floor(seconds)    % 60, (int)(ms*1000),
            floor(endseconds/3600), (int)floor(endseconds/60) % 60, (int)floor(endseconds) % 60, (int)(endms*1000));
          fprintf(srtfile, "%s\n\n", subtitleMessages[i].c_str()); // new line for every subtitle
        }
        fclose(srtfile);
        printf("%d subtitles have been ripped.\n", subtitleFrames.size());
      } else {
        FCEUD_Message("Couldn't create output srt file...\n");
      }
      
      DriverKill();
      SDL_Quit();
      return 0;
    }
	
    if(romIndex <= 0) {
        ShowUsage(argv[0]);
        FCEUD_Message("\nError parsing command line arguments\n");
        SDL_Quit();
        return -1;
    }


    

    // update the emu core
    UpdateEMUCore(g_config);
    g_config->getOption("SDL.Frameskip", &frameskip);
    
    #ifdef CREATE_AVI
    g_config->getOption("SDL.VideoLog", &s);
    g_config->setOption("SDL.VideoLog", "");
    if(!s.empty())
    {
        NESVideoSetVideoCmd(s.c_str());
        LoggingEnabled = 1;
        g_config->getOption("SDL.MuteCapture", &mutecapture);
    } else {
        mutecapture = 0;
    }
    #endif

    {
    int id;
    g_config->getOption("SDL.InputDisplay", &id);
    extern int input_display;
    input_display = id;
    g_config->getOption("SDL.SubtitleDisplay", &id); // not exactly an id as an true/false switch; still better than creating another int for that
    extern int movieSubtitles;
    movieSubtitles = id;
    }
	
	// load the hotkeys from the config life
	setHotKeys();
	
    // load the specified game
    error = LoadGame(argv[romIndex]);
    if(error != 1) {
        DriverKill();
        SDL_Quit();
        return -1;
    }
    
    // movie playback
    std::string fname;
    g_config->getOption("SDL.Movie", &fname);
    g_config->setOption("SDL.Movie", "");
    if (fname != "")
    {
        if(fname.find(".fm2") != std::string::npos)
        {
            static int pauseframe;
            g_config->getOption("SDL.PauseFrame", &pauseframe);
            g_config->setOption("SDL.PauseFrame", 0);
            FCEUI_printf("Playing back movie located at %s\n", fname.c_str());
            FCEUI_LoadMovie(fname.c_str(), false, false, pauseframe ? pauseframe : false);
        }
        else
        {
          FCEUI_printf("Sorry, I don't know how to play back %s\n", fname.c_str());
        }
    }
	
    
    #ifdef _S9XLUA_H
    // load lua script if option passed
    g_config->getOption("SDL.LuaScript", &fname);
	g_config->setOption("SDL.LuaScript", "");
    if (fname != "")
    {
        FCEU_LoadLuaCode(fname.c_str());
    }
	#endif
	
	g_config->getOption("SDL.NewPPU", &fname);
	if (fname == "1")
		newppu = 1;
	/*g_config->setOption("SDL.LuaScript", "");
    if (fname != "")
    {
        FCEU_LoadLuaCode(fname.c_str());
    }*/
	
	
	
    // loop playing the game
    while(GameInfo) {
        DoFun(frameskip);
    }
    CloseGame();


    // exit the infrastructure
    FCEUI_Kill();
    SDL_Quit();
    return 0;
}


/**
 * Get the time in ticks.
 */
uint64
FCEUD_GetTime()
{
    return SDL_GetTicks();
}

/**
 * Get the tick frequency in Hz.
 */
uint64
FCEUD_GetTimeFreq(void)
{
    // SDL_GetTicks() is in milliseconds
    return 1000;
}

/**
* Prints a textual message without adding a newline at the end.
*
* @param text The text of the message.
*
* TODO: This function should have a better name.
**/
void FCEUD_Message(const char *text)
{
	fputs(text, stdout);
}

/**
* Shows an error message in a message box.
* (For now: prints to stderr.)
*
* @param errormsg Text of the error message.
**/
void FCEUD_PrintError(const char *errormsg)
{
	fprintf(stderr, "%s\n", errormsg);
}


// dummy functions

#define DUMMY(__f) void __f(void) {printf("%s\n", #__f); FCEU_DispMessage("Not implemented.");}
DUMMY(FCEUD_HideMenuToggle)
DUMMY(FCEUD_MovieReplayFrom)
DUMMY(FCEUD_ToggleStatusIcon)
DUMMY(FCEUD_AviRecordTo)
DUMMY(FCEUD_AviStop)
DUMMY(FCEUD_VideoChanged);
void FCEUI_AviVideoUpdate(const unsigned char* buffer) { }
int FCEUD_ShowStatusIcon(void) {return 0;}
bool FCEUI_AviIsRecording(void) {return false;}
void FCEUI_UseInputPreset(int preset) { }
bool FCEUD_PauseAfterPlayback() { return false; }
// These are actually fine, but will be unused and overriden by the current UI code.
void FCEUD_TurboOn    (void) { NoWaiting|= 1; }
void FCEUD_TurboOff   (void) { NoWaiting&=~1; }
void FCEUD_TurboToggle(void) { NoWaiting^= 1; }
FCEUFILE* FCEUD_OpenArchiveIndex(ArchiveScanRecord& asr, std::string &fname, int innerIndex) { return 0; }
FCEUFILE* FCEUD_OpenArchive(ArchiveScanRecord& asr, std::string& fname, std::string* innerFilename) { return 0; }
ArchiveScanRecord FCEUD_ScanArchive(std::string fname) { return ArchiveScanRecord(); }
