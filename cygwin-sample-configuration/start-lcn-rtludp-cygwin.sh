#! /bin/bash
clear
echo EDACS-FM Florida Man Edition - LCN Channel using RTL_UDP.
echo 
./rtl_test -t
echo Caution: rtl_test.exe may display incorrect SN data in Windows if another device is already in use.
echo Device Listing Complete. 
echo
echo Which Device Number would you like to use?
read DEVICE
echo
echo RF Gain Value? 
echo Typically 0-49 for RTL2838 devices.
read GAIN
echo
echo PPM Value?
read PPM
echo
echo Parking LCN Channel on 850M. Device is Tunable.
STRING="./rtl_udp -d ${DEVICE} -f 850M -s 28.8k -p ${PPM} -g ${GAIN} 2> /dev/null | tee >(sox -t raw -b 16 -e signed-integer -r 28800 -c 1 - -t raw - 2> /dev/null | play -t raw -r 28800 -es -b 16 -c 1 - 2> /dev/null ) | ./edacs-lcn"
echo
echo Script below crafted from answers to above questions. 
echo Copy and paste into sh file if you do not wish to answer everytime.
echo Set sh file executable with command chmod +x example.sh
echo
echo "#! /bin/bash"
echo $STRING
echo
read -p "Press Enter key to start"
./rtl_udp -d $DEVICE -f 850M -s 28.8k -p $PPM -g $GAIN 2> /dev/null | tee >(sox -t raw -b 16 -e signed-integer -r 28800 -c 1 - -t raw - 2> /dev/null | play -t raw -r 28800 -es -b 16 -c 1 - 2> /dev/null ) | ./edacs-lcn
