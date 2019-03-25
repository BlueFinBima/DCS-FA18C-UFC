# DCS-FA18C-UFC
This is a hardware and software project to build an Up Front Controller for the DCS F/A-18C Hornet
<div class=Section1>

<p class=MsoNormal>I would love to have a full Simpit for every aircraft – who
wouldn’t – but space / time / money all conspire against this.  I personally
feel that there is more immersion from the sensation of real switches, knobs
etc, but compromises are part of life.</p>

<p class=MsoNormal>I wanted a mix of virtual cockpit and some real devices so I
wrote a native F/A-18C interface for Helios, and I started a project to create
a hardware Up Front Controller.  This is what I am presenting here.   While the
3D printed UFC enclosure is very rough, hopefully you’ll get the idea of what I
am doing.  The UFC just has power going to it, and it has the potential to
drive future parts of the cockpit via i2c (I am aware of the limitations and
potential problems with the approach of using i2c, but it seems reliable in my
set up).   The UFC is controlled by an ESP32 board to get me the direct pins
and interrupts that I needed for the encoders.  Because there is only a single
power connecter to the UFC, it means that it can be removed from the set up
extremely quickly.  Likewise, the Thrustmaster Cougar MFDs are also very easy
to remove as they simply hang from the top of the screen, primarily to allow
hiding of the USB cables.  I rotated the rocker switches and 3D printed the
hangers so the MFDs sit over the top corners of the 23 inch Dell touch screen.</p>

<p class=MsoNormal>The UFC itself is pretty simple using DLG2416 displays (I
like the dots).  Unfortunately these do not have any programmable characters,
but the result is OK IMHO.  I would have preferred  16 and 7 segment displays,
but I could not find suitable devices.  The Comm Channel displays are 16
segment LED displays driven by the same HT16K32 that reads the keys and
switches.  Other things I would change if I ever revised the UFC design would
be to replace the 2 x volumes and the brightness knob with potentiometers and
put an i2c ADC onto the board – but I am happy enough with the encoders in the
current design that I’m not planning to do this.</p>

<p class=MsoNormal>I’m going to put a third Cougar MFD in for the AMPCD, but
I’m still considering how I can do this while keeping the mounting discrete.</p>

<p class=MsoNormal>The History of this Project</p>

<p class=MsoNormal>I started out many years ago with the A-10C and Loz’s
profile for Helios which was a a great place to start.  After a while, I built
a real caution panel based on the Holtek HT16K32 which was driven by an Arduino
Pro Micro which communicated via a serial connection to a c# program which
talked to DCS.  Over time, the A-10C parts grew a bit and I had CMSC, CMSP,
UFC, NMSP and a few other panels.</p>

<p class=MsoNormal>The EOS project was a little too complex for my needs, and
while DCS-BIOS is a fantastic option, for a number of reasons, I have chosen to
stick with my own technology.</p>

<p class=MsoNormal>Fast forward a few years, and the Pro Micro and c# program
were replaced by an ESP8266 with more memory so that it had the capacity to do
all of the parsing needed and the wifi communication allowed direct connection
to the DCS exports.lua. </p>

<p class=MsoNormal>When the Hornet came out, I decided that I again wanted to
have a hybrid Helios cockpit, but I have always taken the view that offloading
as much work from my DCS PC so that it can concentrate  resources on DCS, was a
good thing.  Since I always have access to under-utilised PCs, I wanted the
virtual cockpit to be on a remote machine like I had with the A-10C. 
Unfortunately this ruled out Capt Zeen’s Hornet profile because it uses
keyboard commands which appear on the wrong PC, and the use of the A-10C Helios
interface requires a lot of processing in the exports.lua on the DCS machine.</p>

<p class=MsoNormal>Most of this project is already available on GitHub at <a
href="https://github.com/BlueFinBima/DCS-FA18C-UFC">https://github.com/BlueFinBima/DCS-FA18C-UFC</a>
although this is not necessarily the best place for some of the files.  I’m
happy to make 3D parts visible on Fusion 360 on request.  Schematics etc are
Eagle format.</p>

<p class=MsoNormal> I hope this might have been of some interest for a portion
of you.      </p>

<p class=MsoNormal>   </p>

</div>
