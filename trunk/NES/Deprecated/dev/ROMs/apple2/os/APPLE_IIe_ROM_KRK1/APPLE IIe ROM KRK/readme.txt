June 1, 2007
In this directory is a modified Apple IIe ROM image that will let you break into the Monitor at any time, regardless of what program is loaded. Back in the day,
many of the better "Krackists" used this technique to break into a game and examine the code for cracking purposes. At the time, you needed to burn your own modified ROM chip, but with the marvelous Apple IIe emulators out today, all you need to do is point your emulator to APPLE2KRK.ROM and boot away. You could burn your own ROM with this code as well, I suppose, but I make no guarantees on that since I've only tested this mod with my emulator, Virtual ][. I'd be interested in feedback on how this mod works with other emulators.

Usage:
1) Select the APPLE2KRK.ROM file for use with your emulator
2) Boot
3) The system will appear to hang. It's waiting for a key press. Press any key to continue normally or press ESC to enter the monitor.
4) Anytime you press Reset or Boot on your Apple IIe, the system will wait for a key press before continuing.

What's going on:
The marvelous Krakowitz file gives a great in depth explanation, but here's a brief summary:
1) The original reset vector address in the ROM is changed from $FA62 to $FECD. Why $FECD? That's normally the cassette tape save/load area which I've replaced with a conditional call into the Monitor when ESC is pressed. If any other key is pressed, the system jumps to $FA62 for normal operation.

2) This modified ROM routine also copies all memory in $0000-$8FFF into a safer area, $2000-$28FF (hi-res picture area) before entering the monitor to preserve that memory for analysis.

Other notes:
The assembly code was written and compiled with S-C MASM 1.1 which is free. The SC MASM source file is included on a .dsk image, and a .pdf file of the source is also included here for easier viewing.

Maybe this file is 20 years too late, but for anyone who still enjoys tInkering with their old Apple II, I hope this helps make your hobby more enjoyable.

Happy Cracking!
Galael