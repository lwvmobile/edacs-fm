#! /bin/bash
#set stack size to 16384(~16MB) to import larger csv files without segfault
#issue caused by making a large C array in the stack
#feel free to comment out ulimit if monitoring smaller systems
ulimit -s 16384


echo Which site would you like to monitor?
read sitevariable
echo Which RF Gain Value?
read rfgain
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

socat stdio udp-listen:2000 | sox -t raw -b 16 -e signed-integer -r 48000 -c 1 - -t raw - rate 28800 | ./edacs-fm -$type -s site.csv -g group.csv -c $sitevariable -r $rfgain -a $A -f $F
