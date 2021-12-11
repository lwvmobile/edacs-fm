#! /bin/bash
clear
echo EDACS-FM Florida Man Edition - Control Channel Interactive Startup for SDR++ UDP Signal Source.
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
echo E EDACS Extended Addressing without ESK
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
echo All Display and Logging Enabled 
echo
read -p "Press Enter key to start"
socat stdio udp-listen:7355 | sox -t raw -b 16 -e signed-integer -r 48000 -c 1 - -t raw - rate 28800 | ./edacs-fm -$type $SCSV $GCSV -a $A -f $F -S -C -P -Q -L

