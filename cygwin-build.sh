#This build file is for building in cygwin
#make sure to install the following packages into cygwin first
#search for packages using setup-x86_64.exe and pick the latest versions
#git wget unzip sox libsox3 sox-fmt-ao sox-fmt-pulseaudio gcc-core gcc-debuginfo gcc-objc libgcc1 cmake make socat libusb 1.0 libusb 1.0-devel libncurses++w10 libncurses-devel libncursesw10
cp cygwin-sample-configuration/* ./
chmod 444 cygwin-sample-configuration/*
chmod +x *.sh

gcc -o edacs-fm edacs-fm.c -lncurses -Wl,--stack,900000000
gcc -o edacs-lcn edacs-lcn.c
wget https://ftp.osmocom.org/binaries/windows/rtl-sdr/rtl-sdr-64bit-20211205.zip
unzip rtl-sdr-64bit-20211205.zip
cp rtl-sdr-64bit-20211205/l* ./
cp rtl-sdr-64bit-20211205/rtl_fm.exe rtl_fm.exe
cp rtl-sdr-64bit-20211205/rtl_test.exe rtl_test.exe
rm -rf rtl-sdr-64bit-20211205

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
cp rtl-sdr-master-udp/rtl-sdr-master/build/src/cygrtlsdr-0.dll cygrtlsdr-0.dll
rm -rf rtl-sdr-master-udp
