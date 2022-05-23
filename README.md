# EDACS-FM Florida Man Edition
EDACS 9600 Trunk Tracking software for Linux, *Nix, BSD systems, Cygwin (and maybe others) using two RTL2838 dongles for decoding and tuning or decoding with SDR++ and GQRX UDP Sink sources.

![alt text](https://raw.githubusercontent.com/lwvmobile/edacs-fm/main/screenshot.png)

## How to Build

Make sure to have the prerequisite dependencies (or equivalents) installed:
```
sox aplay cmake build-essential socat libusb-1.0-0-dev libncurses5 libncurses5-dev gnuradio rtl-sdr libusb-1.0-0-dev
```
If using Debian/Ubuntu base, you can use
```
sudo apt update

sudo apt install git sox cmake build-essential socat libusb-1.0-0-dev libncurses5 libncurses5-dev gnuradio gr-osmosdr rtl-sdr libusb-1.0-0-dev

chmod +x build.sh 

./build.sh
```
If any build errors occur, double check all dependencies are met, and feel free to raise issue on github if build errors persist.

When complete, you can populate your group.csv and site.csv with frequencies and groups. site.csv will need proper site number in decimal with matching frequencies in Hz in order to tune properly. group.csv is purely optional, but provides a way to give groups proper names and also set modes such as DE - Digital Encrypted, A - Allow, D - Digital, and B - Block. Example lines already provided in site.csv and group.csv files. Populating group.csv is highly recommended on highly busy systems to very selectively choose who to listen to.

Choose whether you wish to run software with rtl_fm or gnuradio. gnuradio has added benefit of being able to select site, set gain, and hunt for control channel from LCNs in the site.csv file. Advanced users may also wish to tinker with the provided gr files to fine tune the radio to their desired usage, or select a device type other than rtl dongles. Only support for rtl dongles is provided on the github, but other sources should be compatible, given a little advanced user tweaking to the python code. 

rtl_fm provides two modes of use, two dongle mode, where one dongle dwells on the control channel, and the second dongle tunes directly to the LCN, or single mode, where one dongle is used to tune both the control channel and switch to the voice channel LCN when a voice call is granted. Users are recommended to use this solution.

## How to Use
The included example scripts contain interactive setup which will ask you for all the necesary information to run EDACS-FM.

You can start either 
`./start-control-rtlfm.sh` and `./start-lcn-rtludp.sh` 
in two seperate terminals for two start-sdrpp-gqrx-udp-signal.shdongle mode

or 
`./start-single-dongle-rtludp.sh` to run in single dongle mode. I only currently advise using Single Dongle Mode for purely digital systems for now. 

If you wish to only decode EDACS systems, and not tune, then using `./start-control-rtlfm.sh` will be the best solution.

An alternate solution for EDACS-FM decoding is to use `start-sdrpp-gqrx-udp-signal.sh` which will take signal input from SDR++ or GQRX UDP port 7355 and decode the signal. Make sure to enable/start the UDP sink feature in either program prior to starting this script. This is very useful for discovering EDACS systems in your area, and can still be used with `./start-lcn-rtludp.sh` to tune the second dongle if desired.

## Virtual Audio Sinks

Optional 'Virtual Sinks' for routing audio from EDACS-FM, etc, into DSD-FME or similar.

You may wish to direct sound into DSD-FME, or similar, via Virtual Sinks. You may set up a Virtual Sink or two on your machine for routing audio in and out of applications to other applications using the following command, and opening up pavucontrol "PulseAudio Volume Control" in the menu to change line out of application to virtual sink, and line in of [DSD-FME](https://github.com/lwvmobile/dsd-fme "DSD-FME") to monitor of virtual sink. This command will not persist past a reboot, so you will need to invoke them each time you reboot, or search for how to add this to your conf files for persistency if desired.

```
pacmd load-module module-null-sink sink_name=virtual_sink  sink_properties=device.description=Virtual_Sink
pacmd load-module module-null-sink sink_name=virtual_sink2  sink_properties=device.description=Virtual_Sink2
```

## DSD-FME

With two dongle monitoring, [DSD-FME](https://github.com/lwvmobile/dsd-fme/tree/pulseaudio "DSD-FME") RTL input mode can be substituted for `./start-lcn-rtludp.sh` on purely digital systems. DSD-FME has the same built in UDP remote features that rtl_udp uses, so it works extremely well when paired together. 

`dsd -fp -i rtl -c 850M -P -2 -D 1 -G 36 -U 6020 -Y 24 -N 2> pv.log`

the log can be viewed in a second terminal tab using

`tail -n 40 -f pv.log`

You can also run EDACS-FM single dongle mode, and run line in into DSD-FME with the example below while routing the audio from the single instance into DSD-FME with pavucontrol "Pulse Audio Volume Control".

`dsd -fp `

----
## Cygwin Builds

2022.05.23 Update

After doing some testing with Cygwin builds, I've determined that there is an inherent lag due to the nature of how Cygwin works. This is fine for just pure control channel decoding, but if a user attempts to tune to voice channels, the lag is enough so that tuning usually misses voice traffic more often than not. Due to this, I am officially not recommending using the Cygwin build. 

If you still wish to build in Cygwin, you can see the instructional video below.

[Cygwin Build Video](https://www.youtube.com/watch?v=FFKR3b4qcTY)
