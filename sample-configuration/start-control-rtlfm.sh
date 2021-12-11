#! /bin/bash
#set stack size to 16384(~16MB) to import csv files without segfault
#issue caused by making a large C array in the stack

ulimit -s 16384
clear
echo EDACS-FM Florida Man Edition - Control Channel Interactive Startup for RTL_FM devices.
echo 
echo Which Frequency would you like to monitor?
echo Example 851800000 or 851.8M
read FREQ
echo
rtl_test -t
echo
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
echo Name of CSV file with Site Frequencies?
echo Defaults to site.csv if no answer.
read SITE
Y=''
if [[ $Y == $SITE ]]; then
	SCSV=''
else
	SCSV="-s ${SITE}"
fi	
echo
echo Name of CSV file with Talkgroup Information?
echo Defaults to group.csv if no answer.
read GROUP
Y=''
if [[ $Y == $GROUP ]]; then
	GCSV=''
else
	GCSV="-g ${GROUP}"
fi	
echo
echo Which type of System?
echo l EDACS Standard or Networked
echo e EDACS Standard or Networked with ESK
echo x EDACS Extended Adressing with ESK
echo E EDACS Extended Adressing without ESK
read type
TYPE1='l'
TYPE2='e'
if [[ $type == $TYPE1 ]]; then
    echo Agency bit length? Default 4
    read A
    echo Fleet bit length? Default 4
    read F
elif [[ $type == $TYPE2 ]]; then
    echo Agency bit length? Default 4
    read A
    echo Fleet bit length? Default 4
    read F
else
    echo AFS settings not used for Extended Adressing
    A=4
    F=4
fi
echo 
Y='y'
echo Display Site Extra Information?
echo y/N
read S
if [[ $Y == $S ]]; then
	EXTRA='-S'
else
	EXTRA=''
fi	
echo Enable Patch Group Display - EA Systems only?
echo y/N
read P
if [[ $Y == $P ]]; then
	PATCH='-P'
else
	PATCH=''
fi
echo Display Call Matrix "History"?
echo y/N
read C
if [[ $Y == $C ]]; then
	CALL='-C'
else
	CALL=''
fi
echo Enable Voice Call Logging?
echo y/N
read L
if [[ $Y == $L ]]; then
	VLOG='-L'
else
	VLOG=''
fi
echo Enable Patch and Peer Logging?
echo y/N
read Q
if [[ $Y == $Q ]]; then
	PLOG='-Q'
else
	PLOG=''
fi 
echo   
echo Script below crafted from answers to above questions. 
echo Copy and paste into sh file if you do not wish to answer everytime.
echo Set sh file executable with command chmod +x example.sh
echo
echo "#! /bin/bash"
echo "ulimit -s 16384"
STRING="rtl_fm -d ${DEVICE} -f ${FREQ} -s 28.8k -p ${PPM} -g ${GAIN} | ./edacs-fm -${type} ${SCSV} ${GCSV} -a ${A} -f ${F} ${EXTRA} ${PATCH} ${CALL} ${VLOG} ${PLOG}"
echo $STRING
echo
read -p "Press Enter key to start"
rtl_fm -d $DEVICE -f $FREQ -s 28.8k -p $PPM -g $GAIN | ./edacs-fm -$type $SCSV $GCSV -a $A -f $F $EXTRA $PATCH $CALL $VLOG $PLOG
