# EDACS-FM Florida Man Edition
EDACS 9600 Trunk Tracking software for Linux, *Nix, BSD systems (and maybe others) using two RTL2838 dongles(or anything supported by gnuradio with a little tweaking).
![alt text](https://raw.githubusercontent.com/lwvmobile/edacs-fm/main/screenshot.png)

Continuation of the LEDACS-ESK project, originally forked from LEDACS, appropriate links below:

https://github.com/lwvmobile/ledacs-esk

https://github.com/sp5wwp/ledacs

Make sure to have the prerequisite sox aplay cmake build-essential socat libusb-1.0-0-dev libncurses5 libncurses5-dev gnuradio rtl-sdr libusb-1.0-0-dev

If using debian/ubuntu base, you can use

sudo apt update

sudo apt install git sox cmake build-essential socat libusb-1.0-0-dev libncurses5 libncurses5-dev gnuradio gr-osmosdr rtl-sdr libusb-1.0-0-dev

chmod +x build.sh rebuild.sh start-control-gr.sh start-control-rtlfm.sh start-lcn-gr.sh start-lcn-rtludp.sh start-pyedacs-gr.sh sdrpp-gqrx-udp-signal-analyzer.sh

This command will give the necessary execution permissions to our scripts for
building and quickly starting up the software without needing to remember
long strings of code.

Next, run the included build.sh script to compile all the code necesary.

./build.sh

If any build errors occur, double check all dependencies are met, and feel free to raise issue on github if build errors persist.

When complete, you can populate your group.csv and site.csv with frequencies and groups. site.csv will need proper site number in decimal with matching frequencies in Hz in order to tune properly. group.csv is purely optional, but provides a way to give groups proper names and also set modes such as DE - Digital Encrypted, A - Allow, D - Digital, and B - Block. Example lines already provided in site.csv and group.csv files. Populating group.csv is highly recommended on highly busy systems to very selectively choose who to listen to.

Choose whether you wish to run software with rtl_fm or gnuradio. gnuradio has added benefit of being able to select site, set gain, and hunt for control channel from LCNs in the site.csv file. Most users are recommended to use the gnuradio/PyEdacs solution provided. Advanced users may also wish to tinker with the provided gr files to fine tune the radio to their desired usage, or select a device type other than rtl dongles. Only support for rtl dongles is provided on the github, but other sources should be compatible, given a little advanced user tweaking to the python code. rtl_fm provides benefit of needed far lesser system resources and processing more samples faster, but is more static in nature, and relies on its outdated rtl_udp companion.

--How to run--

First, open your start-control-gr.sh and change variables to edacs-fm as required. By default, the startup script will ask you a few questions so you may not need to change anything, including:

Which site would you like to monitor?

Which type of system?

l EDACS Standard/Networked

e EDACS Standard/Networked with ESK

x EDACS ESK with Extended Adressing

And if AFS bits are going to be used on Standard/Networked systems.

Other options include

-d Univeral Denial Mode - only open voice channel to allowed groups from group.csv file using mode [A]


Site number and gain will be asked to the user upon start up if using gr. rtl_fm users will want to be sure frequencies, gain, squelch, and so on are set appropriately for their sites.

Open three terminal tabs, and in each one execute:

./start-pyedacs-gr.sh

./start-lcn-gr.sh

./start-control-gr.sh

If all is set up properly, you should see your decoding screen. 

Alternatively, you can use ./start-control-rtlfm.sh and start-lcn-rtludp.sh instead.

----Want to help the Project?-----

WAV recordings of EDACS 9600 control channels are always nice to have. 
Currently, I am in need of EDACS Narrowband systems, and any other exotic variants.
Feel like your EDACS system isn't working correctly? Then submit the WAV file!
Please don't submit more than 3 to 5 minute recordings, WAV sample sizes can become very large.
WAV Samples MUST be 48000Hz 16-bit mono. No Wonky SDR# recording please.

Also, please no baseband recordings unless you discuss it with me first.

WAV files of Control Channels can be acquired using SDR++ .

SDR++

Be sure to set your VFO to 25khz NFM, set the VFO on the control channel and select Audio under Recorder. Make sure to keep the audio in the green and not in the red under recording, turn the gain down if necessary. Thanks.

![alt text](https://raw.githubusercontent.com/lwvmobile/edacs-fm/main/sdrpp-help.png)

GQRX?? SDR#??

I don't recommend sending GQRX or SDR# samples right now, I tested a few of my own creation, and found they may have issues that prevent them from working properly. I highly recommend SDR++ for sample creation (and general use).

Samples can be uploaded to https://ufile.io/ free of charge without making a membership. File links can be sent to me under issues, I will have a rolling issue for control channel samples.

Thanks for your help.


