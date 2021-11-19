#These are the steps to compile the included software
#make sure to have 'build-essential' software already 
#installed. Debian/*Buntu: sudo apt update && install build-essential
#feel free to customize this script to your liking or cherry pick
#if you can't get this script to run, make sure to run:
#chmod +x build.sh rebuild.sh 
#then run: ./build.sh to start script.
cp sample-configuration/* ./
chmod 444 sample-configuration/*
chmod +x build.sh rebuild.sh start-control-gr.sh start-control-rtlfm.sh start-lcn-gr.sh start-lcn-rtludp.sh start-pyedacs-gr.sh start-sdrpp-gqrx-udp-signal.sh
#comment out below comments if you do not use a debian/ubuntu based system, will need to install prerequisites yourself i.e. pacman, dnf, etc.
sudo apt update
sudo apt install git sox cmake build-essential socat libusb-1.0-0-dev libncurses5 libncurses5-dev gnuradio gr-osmosdr rtl-sdr libusb-1.0-0-dev
gcc -o edacs-fm edacs-fm.c $(ncursesw5-config --cflags --libs)
#comment line above and uncomment below line if ncurses produces garbled ascii art, or you have newer than ncurses5, i.e. ARCH LINUX
#gcc -o edacs-fm edacs-fm.c -lncurses
gcc -o edacs-lcn edacs-lcn.c
tar -xvf rtl-sdr-master-udp.tar.xz
cd rtl-sdr-master-udp/rtl-sdr-master
mkdir build
cd build
cmake .. -DDETACH_KERNEL_DRIVER=ON
make
cd ..
cd ..
cd ..
cp rtl-sdr-master-udp/rtl-sdr-master/build/src/rtl_udp rtl_udp
rm -rf rtl-sdr-master-udp
