+++
title = "Winstar OLED"
draft = true
+++


(link to driver GitHub page here)
(link to python image converter GitHub page here)

(still image of a custom graphic on display)

In January 2025, I picked up a Winstar OLED display at an electronics shop in Osaka for $80, drawn in by the cool animation playing above. I wasn't sure if this was a good price or not, or even if the display was "any good", as I had never worked with one before.

I assumed it would be a fairly simple plug-and-play device, as brief research showed that it used a similar interface to the common "HD44780" display controller, which apparently had a lot of support available.

I soon learned the importance of the display controller, I was under the impression that a similar-looking display (same pinout, resolution, even size) would all function in a similar way with a few small tweaks. After more research, I learned that my display used two WS0010 chips and all the libraries and drivers I could find were for single-chip displays (such as the Winstar 100x16 OLED).

I wanted to find: An example of someone using this display, someone's working initialisation code, or more detailed instructions on the initialisation process.

I visited many forums, GitHub repositories, around 10 versions of the chip, and display datasheet in multiple languages, Russian, Chinese, Japanese, and Finnish chatrooms, plus tried countless variations of the stated initialisation process on the datasheet, but no luck.

A while later I received some requested sample code from Winstar, along with a message asking me where I got my display from, why I chose the colour red (apparently no one ever bought it), and to please consider upgrading to a supported product.

The sample code was written in 2010 for an Intel 8051 8-bit microcontroller, so I now had the task of porting it over to C++ so it would run on my Arduino Uno. Once again this required more learning and research as concepts such as writing directly to the `P1 Data bus` (a specific input/output port on the 8051), `sbits` (single bit-addressable memory locations), and `_nop_();` (a 'no operation' instruction used for precise timing) were very unfamiliar to me.

The original code also held a frame in a `[4][100]` 2D array. Each index stored an 8-bit hexadecimal value, where each bit within that byte corresponded to an individual pixel. A '1' in a bit position would switch the corresponding pixel on, while a '0' would leave it off, effectively using bitmasking to represent 8 vertical pixels per byte. I kept this same design in my ported code, along with keeping the same logic for drawing the frame on the screen.

_Note: if anyone ever buys this display, the small information card I received with it states that pin 15 and pin 16 (chip select 1 and chip select 2) are NC or Not Connected but they definitely are and are needed for the display to work. Before I discovered this, I assumed I would never get the display working unless I figured out how to connect these pins on the PCB, which are crucial for selecting and communicating with each of the two WS0010 chips independently._

Finally, I got it to work! The display would power on, and cycle through some demo images. Next up was to display images (and possibly animations) of my own. I have experience with Aesprite, a program to make pixel art and sprite sheets which I have used for custom GIFs on sites, a dead RPG maker game, and old Logos, so making a 100x32 black and white test image was no problem. Now came the harder part of turning my .png into a 4 x 100 2D array of hexadecimal values. Through trial and error, I figured out how to address each pixel: 

(show the drawing here)

Next was to write a small Python program that took an appropriately sized PNG, and returned a text file with a formatted array, ready to be copied to my Arduino code.

To do this I:
- Used Image from Pillow, to open and convert my .png from 32-bit RGBA to 8-bit grayscale.
- Extracted the pixel data into a List
- Used numpy to create a bit array, and based on a threshold value of 127, set each value to a 0 or 1
- Looped through the array, collecting 8 bits at a time, converting them to hexadecimal, and saving the result in an output file.

At this point I had never contributed to an open source project or published some code/program that may be useful to others, I had always wanted to but I just didn't know what to do. After reflecting on my struggles and progress while getting this display to work, it jumped out as the perfect project to share online! The next step was to create a device driver that others could use, along with documentation and supplementary material such as my Python image converter. The driver would serve as a reference for people working with dual WS0010/S0010 chip displays, plus hopefully be fully functional for anyone with my model or a slight variant of it.

To make a comprehensive driver, I had to develop a wider scope of functions even if I didn't personally need them. This chip is capable of Character Mode, with an included English_Japanese font table, as well as Graphical Mode. This driver currently only explores graphical mode as in my opinion, it is much more fun.

(images and videos of the display showing custom images here)

Plans for the future

As of writing this, I'm using this display on a breadboard with simple jumper wires on an Arduino Uno. I still have bigger plans to use a Raspberry Pi Pico 2 and a NOR Flash Module, utilising the Pico's higher clock speed, direct memory access, 12 PIO state machines, and much more optimised code to push the refresh rate limit of the display, creating ultra smooth animations (and play Bad Apple!!). Hopefully this will have some sort of utility as well, I'm sure I'll think of something in the future. I will continue to add new functions to my driver, as well as optimise the code so it is more stable and faster. Hopefully I'll also make the driver for the Pico 2.