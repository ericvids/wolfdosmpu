**wolfdosmpu**
==============

Copyright © 2021 by ericvids.

This program is free and open source software; you can redistribute it and/or modify it under the terms of either the original source code license agreement as published by id Software (LICENSE1) or the GNU General Public License v2 ONLY, as published by the Free Software Foundation (LICENSE2).

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the LICENSE files for more details.


About
=====

**wolfdosmpu** is a source mod for the original 16-bit DOS versions of Wolfenstein 3-D and Spear of Destiny to add rudimentary MIDI playback support via the MPU-401 interface, replacing the OPL2-based music.

It is recommended to use this mod with [wolfmidi](https://github.com/ericvids/wolfmidi/), which converts the game's native OPL2 music data to General MIDI.

Why use this over an enhanced port like [ECWolf](http://maniacsvault.net/ecwolf/) (which already supports MIDI)?

Well, you _can_ use the music files generated by wolfmidi with enhanced ports that already support MIDI (I use ECWolf regularly myself)...

... BUT wolfdosmpu gives you a way to play Wolf3D with enhanced music on the original system hardware that Wolf3D is designed for, with optionally _no gameplay changes introduced by modern source ports_ for that authentic retro 90's experience.

"Optionally"? ... Because you also have the option to play using modern first-person-shooter controls! (WASD keys for movement and mouse for turning, as well as the Tab key to check the map ala Doom or your collection progress ala Quake.) For those who consider this "cheating" or otherwise an inauthentic experience, you have two alternatives: (1) you can turn off all enhancements in the menus, or (2) you can download a version of the EXE with just the MPU-401 support and essential bugfixes, controllable via command-line.

This mod is forked directly from the official Wolf3D source release from id Software, with only the barest minimum of changes needed to get things working. I did this as a personal exercise in DOS 80x86 assembly and 16-bit C programming. (Segmented memory is such a FAR-out concept, man!)


Version History
===============

1.42 (2021-10-29)
-----------------
- Now detects whether proper data files have been provided for the EXE used.
- Fixed Change View dialog becoming unresponsive to user input during low-memory conditions.
- Now allows MPU-401 support even if AdLib is manually disabled via the "noal" command-line parameter. (The MPU code is partially dependent on the AdLib code, and previous wolfdosmpu versions disabled music altogether if "noal" was used.)
- Now does not disable the Sound Blaster when "noal" is specified (like the original Wolf3D did); it now disables just the OPL2 sound effects.
- Now allows BLASTER environment variable to specify the MPU port even if the Sound Blaster is manually disabled via the "nosb" command-line parameter.
- Now sets "nopro" internally if BLASTER variable is present and does not have the T option (or is set to 0, 1, or 3). This way, DMA-less SB-compatible cards are given the option to enable Pro extensions.
- Added "always run" option for modern-controls version. Beware: Always-running in Wolf3D is a lot less fluid than always-running in later games like Doom or Quake (due to the lack of acceleration/deceleration), and is not recommended for people with motion sickness.

1.41 (2021-10-26)
-----------------
- Added support for DMA-less Sound-Blaster-compatible cards and Covox-Speech-Thing-compatible parallel port sound devices. See the [tips section](#dont-hurt-midi) for details. (Thanks to Bondi for testing!)

1.40 (2021-10-24)
-----------------
- Now sets MAXVISABLE to MAXACTORS (instead of a paltry hardcoded 50), so that all sprites render properly in extreme cases such as E4M8 (in the swastika-lights area) and E4M10 (where you can kill all 75 officers through a secret opening). Also fixed the "visability" algorithm so that animating actors always get drawn first. These fixes ensure that all active enemies and projectiles will never go invisible, even in custom levels that maximize the MAXACTORS limit. (Statics and corpses may still become invisible depending on their layout, but that has always happened in regular Wolf3D and it is still less of a problem with the increased MAXVISABLE limit.) _This bugfix can be disabled with new COMP flag 16._ (In case a mod uses the sprite limit to forcibly hide attackers, or for people who like the weirdness of fighting invisible officers on E4M10.)
- Added a 100-tick delay at the start of a song, to ensure that a previous turn-off-notes command is fully received by the MIDI device (and ensure that the music does not skip time at the beginning).
- Automap now has 4 modes: Normal, Show secrets if clear (if there are no enemies remaining (that can be killed)), Always show secrets (if you have seen their respective tiles), and Full map (also gives away enemy positions). I found myself wanting the in-between options because the full map gives too much away. "Show secrets if clear" is my preferred option for testing my memory of the maps, but "Always show secrets" can be handy if you don't like spamming the Open key on walls while desperately looking for medkits or ammo.
- Automap now assumes that a door is open if a corpse is blocking it. (Useful for E4M7's intended solution as described in the official hint manual.)
- Fixed completion stats display to not display garbage above 999; it will display the least significant digits instead like other score counters (this can theoretically happen when spam-killing SoD's spectres).

1.39 RC (2021-10-18)
--------------------
- Added music volume control, to allow users to balance the loudness of the music with the sound effects (suggested by mOBSCENE). Note that sound effects volume (both digital and FM) can be changed through your sound card's mixer app. The MPU-401 device's volume, on the other hand, usually has no readily-available software-based control, justifying this feature.
- Made Tab key functions a separate menu -- it was previously unclear that the menu option cycles through four possibilities.
- Now supports negative parameters for COMP, to disable the specified options (and enable everything else).
- Player respawn now properly marks pushwalls and bonuses that have been previously pushed/seen. This modifies the savegame format -- older savegames will be automatically updated to the new format, but newer savegames will not work properly with older versions of wolfdosmpu (which you should generally avoid anyway).
- Added a special case to automap viscone rendering so that it "sees through" pillars and other block objects even if the area behind them is inaccessible. (Items in these inaccessible areas are still rendered in darker color.)
- Added a special case for rendering E3M10's ghosts in the automap (since they are not shootable but they're quite dangerous).

1.38 RC (2021-10-14)
--------------------
- Fixed more memory issues and crashing related to stats/map display, and reimplemented stats dialog to avoid using id's Message() routines (which seem to leak memory -- infamously, SoD's Tab+G+F10 God Mode cheat could crash the system randomly). I think I've eliminated the crashes for good, but if you still experience crashes, I would appreciate it if you contact me with steps to reproduce and savegame if possible (your system's memory configuration as reported by MEM will also be handy).
- Automap now pulsates the player's viewing area (via palette-cycling) for easier navigation.
- Automap now does not give away the status of doors that the player currently cannot see.
- Fix to a minor pushwall special case bug after grabbing the spear. (Should not actually appear on unmodified SoD.)
- Fixed COMP 0 being interpreted the same as COMP.

1.37 RC (2021-10-12)
--------------------
- Now enforces a 257000-byte memory minimum to the Wolf3D EXEs (previously only applied to the SoD EXEs), to help mitigate memory issues introduced by bug fixes. You can override this by using the debug mode command-line parameter "goobers". (SoD has always allowed overriding the memory minimum via "debugmode".)
- Even better item pickup code, should now not miss anything when running straight through a one-tile-wide row of items. (You can see this in action in the first attract-mode demo of Wolf3D registered/commercial, where one ammo clip in the middle of the row was skipped over on the original EXE.)
- Improved Robert's Jukebox to show all tracks available in the game. To access Robert's Jukebox: Just after entering the command line to start the game (e.g. WOLF3DCM), the screen blanks and immediately shows the sign-on screen (the one with all the memory and hardware info). You have to press and hold M the moment the sign-on screen appears. (This also works on the original EXEs, but will show a smaller list of tracks.)

1.36 RC (2021-10-11)
--------------------
- Added compatibility flags to purposely enable classic bugs/limitations of the engine (primarily for mods that assume these bugs/limitations). See the note on the COMP parameter in the [tips section](#dont-hurt-midi).
- Fixed map fog not getting reset when getting the spear.
- Fixed phantom secret walls in the map after loading a savegame.
- Now marks all special doors and elevator tiles as magenta to easily spot them on the map.
- Implemented a workaround to reverse the engine's behavior of shrinking the play window in low memory conditions.

1.35 RC (2021-10-09)
--------------------
- Implemented mapping support for the modern-controls version. You can still load savegames between modern-controls and MPU-only versions, but the unlocked areas of the map will be lost if you load a modern-controls savegame on the MPU-only version and subsequently save it (since the MPU-only version ignores any extra data).
- Fixed pushwall glitch preventing 100% completion on many levels (on both modern-controls and MPU-only versions). With this fix, it should now be theoretically possible to complete all levels with 100% kills/secrets/treasures, with the sole exceptions of E2M8 and E6M10 (due to unreachable secrets). Please let me know if I missed any more bugs related to game completion; I have not fully tested all levels yet.

1.32 RC (2021-10-03)
--------------------
- Achieved savegame compatibility between the modern-controls and MPU-only versions (and even savegame compatibility between registered and commercial Wolf3D when using wolfdosmpu!), but this entails breaking savegame compatibility with previous versions of wolfdosmpu one last time. Hope you'll forgive me for this.
- Added cmd scripts for verifying MAP files to ensure that the DATASEG layout is preserved. (These cmd scripts uses unix commands internally -- unxutils or equivalent must be installed on your system.)
- Fixed a memory issue with the SoD God Mode cheat (Tab+G+F10). In turn, the same code was applied to the completion stats display, eliminating flickering when it is being used.

1.31 BETA (2021-10-02)
----------------------
- Fixed Tab option setting being ignored.

1.30 BETA (2021-10-01)
----------------------
- Support for WASD-style modern controls is added. These options can be turned off in the Options menu. Alternatively, you can download a version that does not have these options at all, if you consider these "cheating".

1.25 BETA (2021-09-30)
----------------------
- Now prevents id's memory manager from messing with wolfdosmpu's buffer, increasing compatibility with AWEUTIL (the NOXMS parameter is not needed anymore) as well as EMM386 and QEMM.

1.24 BETA (2021-09-28)
----------------------
- REALLY fixed the regression this time. (Thanks to Gmlb256 for testing!)

1.23 BETA (2021-09-28)
----------------------
- Fixed a regression in MPU-401 detection code.

1.22 BETA (2021-09-27)
----------------------
- Fixed Read This support in WOLF3DRM.EXE and WOLF3DSM.EXE so that they don't shrink the view window every time (and cause a crash once in a while). This is due to the help screens taking up a lot of memory, which Wolf3D compensates for by releasing some memory used by the view window.

1.21 BETA (2021-09-26)
----------------------
- Partial compatibility with Sound Blaster AWEUTIL (MPU-401 port emulation) in DOS. The game must be started with the NOXMS parameter to prevent crashing. (Thanks to Gmlb256 for testing!)

1.20 BETA (2021-09-25)
----------------------
- Rewrote MPU code to fully reuse the existing OPL sequencer state variables for MPU playback.
- Currently testing the removal of the clear interrupt flag instruction in the inner assembly loop. Maybe that will fix issues for some hardware. Maybe not. Maybe it's worse. Please test.
- Altered PRJ file to strip debugging symbols for better LZEXE compression. (decided after discussion with Akuma and Gmlb256)
- Replaced SIGNON.OBJ and GAMEPAL.OBJ with ones from the [Wolf3D game source recreation project](https://bitbucket.org/gamesrc-ver-recreation/wolf3d/). For the Wolf3D screen, I personally dislike the weird colors of the Activision logo, so I opted for the id logo for neutrality. :)
- Moved all the license files to the README section. I believe the general consensus is that Wolf3D's source code came under dual licenses -- limited non-commercial license and GPL). Like many other mods, I defer the option to the user.

1.10 BETA (2021-09-24)
----------------------
- Added support for Apogee registered version 1.4/1.4g by using techniques to reduce data segment usage (e.g., by allocating strings as individual characters in the code segment).
- Corrected a very rare edge case where midiTick (later versions: mpuTick) may get executed before the length of the MIDI file has been calculated, and the song counter could potentially go out-of-bounds.
- Limited the MPU port selection in BLASTER environment variable to the range 2xx-3xx hex because poking some ports by accident can potentially kill your system!
- Changed sound options menu to display "MPU-401 (General MIDI)" instead of "AdLib/Sound Blaster". (suggested by Gmlb256)
- Added Fabrice Bellard's [LZEXE](https://bellard.org/lzexe.html) compressor in the build workflow. This is the original compressor used by id to fit the shareware game on a single floppy disk. (suggested by Gmlb256)
- Revamped build workflow to allow building the original OPL2 versions (essentially "vanilla" Wolf3D) by specifying any argument in the version selection batch files.

1.00 BETA (2021-09-22)
----------------------
- Initial release.


Usage
=====

Can I play NOW, daddy?
----------------------

Download a pre-built EXE file for your game from the [Releases section](https://github.com/ericvids/wolfdosmpu/releases/). Drop this EXE into your game's installation directory, e.g., C:\WOLF3D.

Also download the latest [wolfmidi.zip](https://github.com/ericvids/wolfmidi/releases/). You will need to unzip wolfmidi.zip's contents inside your game's installation directory, e.g., C:\WOLF3D. _You need to preserve the directory structure when unzipping! (Refer to your preferred zip utility's documentation for details.)_ Afterwards, your game directory should look like this:

```
  WOLF3D\
  | MUSIC\
  | | COPYPRO
  | | CORNER
  | | .
  | | .
  | | _INFO
  | AUDIOHED.WL6
  | AUDIOT.WL6
  | .
  | .
  | VSWAP.WL6
  | WOLF3D.EXE (original version)
  | WOLF3DCM.EXE (wolfdosmpu version)
```

Then simply launch the wolfdosmpu EXE for your game (e.g., WOLF3DCM.EXE for Wolf3D commercial version).

If you don't get MPU-401 music, check the Sound menu. If your MUSIC\ directory is being read by the game, the "AdLib/Sound Blaster" music option will change to "MPU-401/General MIDI"; otherwise, the game will revert to playing OPL2 music. If you are not hearing any music at all and the "MPU-401/General MIDI" option is shown, something else is wrong -- see the [tips section](#dont-hurt-midi) for troubleshooting.

In case you're wondering, the MUSIC\ directory contains all the tracks for _both_ Wolf3D and SoD games. Any tracks with the same name between each game happen to be exact byte-for-byte duplicates. If you want to save space, you may install the data files of both Wolf3D and SoD in the same directory, so they can share the same MUSIC\ directory.

Don't hurt MIDI.
----------------

Here are some tips and suggestions for some common problems:

1. If you use wolfdosmpu inside DOSBox, wolfdosmpu will sometimes play on a different MIDI device than you intended (or will not play anything at all). In this case, select your MIDI device with the help of [this guide](https://www.dosbox.com/wiki/Configuration:MIDI).

2. If your hardware MPU-401 is not being detected, try to set the port via the P option of the BLASTER environment variable.
   ```
            SET BLASTER= ... P330 ...

   example: SET BLASTER=A220 I7 D1 T6 P330 H5
   ```
   Try this even if you don't have a Sound Blaster card (in which case, BLASTER would contain only the P option). Some Roland MPU-401s and clones may be configured to use a different address instead of the default 330, e.g., 300, 332, etc.

3. If you have a DMA-less Sound-Blaster-compatible card (such as an ES1688-based card), you have to specify the address of your Sound-Blaster-compatible in your BLASTER environment variable but _do not_ specify the IRQ (I) and DMA (D) parameters. For example: "SET BLASTER=A220" or "SET BLASTER=A220 P330" (without the quotes). This enables DMA-less mode, which uses your CPU to push the audio samples to your device with the proper timing. Note that SB Pro features, e.g., sound positioning and attenuation, are disabled in this mode because the related low-level port commands were observed to cause problems and crashing with these cards.

4. If you have a parallel port digitized sound device that is similar to but not fully compatible with the Disney Sound Source (e.g., Covox Speech Thing), you can enable Covox compatibility mode by using the "SS#" command-line parameter, where # is the LPT port number. For example: "WOLF3DCW SS2" (without the quotes) to use a Covox on LPT2. The Sound menu will confirm that this mode is enabled by renaming the "Disney Sound Source" option to "Covox/Sound Source"; make sure that this option is selected. Covox compatibility mode, like DMA-less mode (above), relies on your CPU to push the audio samples to your device with the proper timing. (This mode also works for the Disney Sound Source itself; the game simply ignores the device's built-in sample buffering.)

5. __Be careful when using Apogee shareware-/registered-version data files!__ Make sure your Apogee data files are version 1.4 or 1.4g. All earlier Apogee versions (1.2 and below) are not supported.

   As a countermeasure, wolfdosmpu (as of version 1.42) tries to detect whether your data files are of the correct version, by checking the extension (WL6/WL1/SOD/SDM) and whether the VGAHEAD.WL6 file reports the correct size. If you get the error "NO WOLFENSTEIN 3-D .WL6/.WL1 FILES TO BE FOUND!", you are probably using shareware version data files on the registered/commercial version EXEs (or vice versa). If you get the error "VGAHEAD.WL6 IS INCOMPATIBLE!", you are probably using registered version data files on a commercial version EXE (or vice versa). Switch to the correct version EXE and try again.

   The main reason for keeping the Apogee versions is for their "Read This" feature, which is missing in the commercial versions and is potentially useful in other mods. (Since version 1.20, I have opted to replace the publisher logo in the sign-on screen with the id logo, for all Wolf3D builds.)

6. __Note on memory and TSRs__: wolfdosmpu generally requires more conventional RAM than the original Wolf3D engine. The additional memory is used for MIDI file caching and parsing, and has to be allocated in conventional memory for compatibility reasons. The amount needed will increase if you use longer custom songs. The modern-controls EXEs also consume more memory for program code supporting the automap and other features.

   TSRs such as AWEUTIL (which enables the necessary MPU-401 support on Sound Blaster AWE cards) consume part of your conventional memory. As with other old DOS games, try to load as few TSRs as possible; for necessary TSRs such as mouse drivers and AWEUTIL, load them into the upper memory area by using LOADHIGH. You can check your available conventional memory using the MEM command.

   My own testing with DOSBox-X indicates that the modern-controls EXEs require at least 571 KB of free conventional memory in order to run properly (with the default music). The MPU-only EXEs use about 7 KB less, but I still recommend freeing at least 571 KB of conventional memory for the best results.

   One tester, Gmlb256, suggests to have about 578 to 590 KB of free conventional memory when using AWEUTIL (that is, about 615 to 620 KB _before_ loading AWEUTIL; the additional usage will depend on the soundfont you use). Gmlb256 also suggests using real-mode UMB drivers such as UMBPCI if you don't want to use an EMM such as EMM386 or QEMM.

   If you use the debug command-line parameter ("goobers" for Wolf3D and "debugmode" for SoD), you can force the wolfdosmpu EXE to load regardless of available memory. THIS IS AN UNSUPPORTED FEATURE, and you risk all sorts of unexpected behavior, such as trigerring the mythical id Software copy protection code that erases your hard drive if you don't have a registered copy of v1.1. Don't say I didn't warn you.

7. __Note on savegames__: Savegames are NOT compatible between wolfdosmpu EXEs and the originals. Some savegames may load, _but don't rely on this_; there may be anomalies like missing objects or broken actor logic. id's savegame code is fully dependent on the data segment's layout, which means that any modification that introduces new global (non-far) variables or constant string literals WILL break future savegames.

8. __Note on the COMP parameter__: You can enable specific quirks/bugs of the original EXEs using the COMP (compatibility) command-line parameter. Specify a number after COMP, which should be the sum of the flags you want to enable (alternatively, specify a negative number to disable those flags and enable everything else):
   ```
    1: pushwalls move 3 tiles unless blocked
       (note: the default maps assume that pushwalls move 2 tiles maximum; this option renders these
       maps impossible to complete 100%)

    2: make fake-Hitler fireball logic framerate-dependent, slowing them down considerably when
       running at 70 frames per second (this bug went undetected because the game likely ran at just
       17.5 to 35 fps on development computers)

    4: pick up items using the original viewpoint-based logic, which sometimes fails to detect items
       when walking backwards or sideways, or when running fast through a row of items

    8: disable circle-strafing (turning and strafing simultaneously) when playing with modern
       controls, which is technically impossible on the original Wolf3D input handling code
       (note: the demo file format is not updated to handle circle-strafing, so it is always disabled
       when playing/recording demos)

   16: limit sprite rendering to a maximum of 50 visible sprites at any time; beyond this limit, some
       active enemies may turn invisible due to the renderer prioritizing statics and enemies with
       lower indices (even if they are dead)
   ```
   For example, to mimic the original EXEs' behavior when they were run on a Pentium (or faster) system, specify COMP 31 (e.g., WOLF3DCM COMP 31). On the other hand, COMP 30 (or COMP -1) disables the 3-tile pushwall move, which is ideal for completionists who wish to retain all other engine quirks.

   COMP by itself will enable all compatibility flags (including future ones). Use NOCOMP (or simply not specify COMP at all) to disable all compatibility flags, which is the default setting.

Bring "M" on!
-------------

If you want to use your own MIDI music, simply replace each music file that you want to change in the MUSIC\ directory with a MIDI file of your choice. (Do NOT use the MID extension. Also, do NOT touch the _INFO file unless you know what you are doing!)

However, since the MIDI files have to be optimized specifically for Wolf3D's timing algorithm, you will likely need to edit any custom MIDI files. The current limitations are:

- Only Type-0 (single-track) standard MIDI files up to 65535 bytes long are supported.
- Only one tick rate and BPM is supported: 350 ticks per quarter note (TPQN) at 120 beats per minute (BPM) -- essentially 700 ticks per second. This is because the original Wolf3D MUSE engine is locked to 700Hz. If your MIDI file does not have "350 TPQN" in its header, it will NOT play. You will need to edit it in a sequencer program to change the tick rate, and speed-up/slow-down the notes as necessary by decreasing/increasing note spacings instead of sending BPM change commands. (Tempo change is also NOT supported.) An alternative way to convert your MIDI files is to use MIDI recorder software: preset the recording to 350 TPQN and 120 BPM, and simply record the playback of an existing MIDI file.
- System-exclusive (F0, F7) and meta-event (FF) messages are currently ignored. Please remove them if possible (to save space/processing time and to avoid variable-length data issues, described below).
- Extra-long pauses, or anything necessitating more than two bytes of MIDI variable-length data (i.e., 16384+ ticks, or roughly 23+ seconds of pause between any note change) are not supported. The music will simply stop if the engine encounters this.

I am H@xx0r Incarnate!
----------------------

If you want to build the EXE files yourself (or for some reason you love SoD's copy protection screen and its "Hitler Waltz" BGM), you will need to follow [Fabien Sanglard's guide](https://fabiensanglard.net/Compile_Like_Its_1992/) on how to build the Wolf3D source code on DOSBox using Borland C++ 3.1.

The version of the Wolf3D source code in wolfdosmpu has been streamlined -- it does not include unnecessary files from id Software's original source release, and it also fixes some issues with building versions other than Wolf3D commercial release 1.4 (i.e., you will not need any of Fabien's additional downloads except for the Borland compiler itself -- everything else is already in here).

In addition, helper batch files are provided to quickly switch between versions. You should execute the batch file of your preferred version inside DOSBox before launching the Borland C++ environment (BC.EXE). Then simply press F9 to build.

```
Supported versions:
_WC.BAT -- Wolf3D commercial v1.4 (id, GT and Activision/Steam releases)
_WR.BAT -- Wolf3D registered v1.4/v1.4g (Apogee releases)
_SC.BAT -- SoD commercial v1.0/v1.4 (FormGen and Activision/Steam releases)

Semi-supported versions:
_WS.BAT -- Wolf3D shareware v1.4/v1.4g (Apogee releases)
_SD.BAT -- SoD demo v1.0 (FormGen release)
```

As of version 1.10, LZEXE has been integrated into the build system. Whenever you switch between versions, an LZEXE-compressed EXE file is generated from the last built WOLF3D.EXE in the OBJ\ subdirectory, and renamed as appropriate (e.g., WOLF3DCM.EXE, SPEARCM.EXE, etc.). If you want LZEXE compression on your current build but don't want to switch between game versions, you can run VERSION.BAT to trigger the compression routine on its own.

Also as of version 1.30, you can build the wolfdosmpu EXEs without modern control support by passing the "M" (MPU-only-version) argument to each batch file, or a completely clean version (equivalent to the original id source release, with only minimal modifications to compile SoD and the Apogee versions) by passing the "V" (vanilla) argument. You can build all 5 game versions (Wolf3D commercial, Wolf3D registered, Wolf3D shareware, SoD commercial, and SoD demo) of each variant at once by executing the _ALL.BAT file with the "V", "M", or "W" (WASD-version) argument, or with no arguments to build all 15 EXEs.
