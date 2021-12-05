#! /bin/bash
#set stack size to 16384(~16MB) to import larger csv files without segfault
#issue caused by making a large C array in the stack
#feel free to comment out ulimit if monitoring smaller systems
ulimit -s 16384

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

    
#for single frequency, uncomment below and use
#rtl_fm -d 0 -f 851375000 -s 28.8k -p -2.0 -g 42 | ./edacs-fm -$type -s site.csv -g group.csv -a $A -f $F

#for multiple frequencies, uncomment below and use
#be sure to tweak gain -g and squelch -l appropriately
rtl_fm -d 0 -f 851.8M -f 855.9875M -f 858.4875M -f 851.375M -l 150 -s 28.8k -p -2.0 -g 42 | ./edacs-fm -$type -s site.csv -g group.csv -a $A -f $F


