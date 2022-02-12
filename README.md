# EDACS-FM Florida Man Edition
EDACS 9600 Trunk Tracking software for Linux, *Nix, BSD systems, Cygwin (and maybe others) using two RTL2838 dongles for decoding and tuning or decoding with SDR++ and GQRX UDP Sink sources.

![alt text](https://raw.githubusercontent.com/lwvmobile/edacs-fm/main/screenshot.png)

https://www.youtube.com/watch?v=jCS7RBdyDZg

Continuation of the LEDACS-ESK project, originally forked from LEDACS, appropriate links below:

https://github.com/lwvmobile/ledacs-esk

https://github.com/sp5wwp/ledacs

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

Choose whether you wish to run software with rtl_fm or gnuradio. gnuradio has added benefit of being able to select site, set gain, and hunt for control channel from LCNs in the site.csv file. ~~Most users are recommended to use the gnuradio/PyEdacs solution provided.~~ Advanced users may also wish to tinker with the provided gr files to fine tune the radio to their desired usage, or select a device type other than rtl dongles. Only support for rtl dongles is provided on the github, but other sources should be compatible, given a little advanced user tweaking to the python code. 

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



## Want to help the Project?

WAV recordings of EDACS 9600 control channels are always nice to have. 
Currently, I am in need of EDACS Narrowband systems, and any other exotic variants.
Feel like your EDACS system isn't working correctly? Then submit the WAV file!
Please don't submit more than 3 to 5 minute recordings, WAV sample sizes can become very large.
WAV Samples MUST be 48000Hz 16-bit mono. No Wonky SDR# recording please.

Also, please no baseband recordings unless you discuss it with me first.

WAV files of Control Channels can be acquired using SDR++ .

### SDR++

Be sure to set your VFO to 25khz NFM, set the VFO on the control channel and select Audio under Recorder. Make sure to keep the audio in the green and not in the red under recording, turn the gain down if necessary. Thanks.

![alt text](https://raw.githubusercontent.com/lwvmobile/edacs-fm/main/sdrpp-help.png)

### GQRX?? SDR#??

I don't recommend sending GQRX or SDR# samples right now, I tested a few of my own creation, and found they may have issues that prevent them from working properly. I highly recommend SDR++ for sample creation (and general use).

Samples can be uploaded to https://ufile.io/ free of charge without making a membership. File links can be sent to me under issues, I will have a rolling issue for control channel samples.

Thanks for your help.

----
## Cygwin Installs

Cygwin has limited support by me as far as I can test things on my own personal set up, but currently it can be built in Cygwin with the right prerequisites installed. Check the cygwin-build.sh file for the necessary packages to install in Cygwin prior to building. The build scripts will be prefixed with cygwin and the start up scripts suffixed with cygwin for clarity to denote the correct scripts to use for Cygwin builds.

[Cygwin Build Video](https://www.youtube.com/watch?v=FFKR3b4qcTY)
