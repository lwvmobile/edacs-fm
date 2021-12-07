
echo Which type of System?
echo l EDACS Standard or Networked
echo e EDACS Standard or Networked with ESK
echo x EDACS Extended Addressing with ESK
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

#nc -l -u -p 7355 | sox -t raw -b 16 -e signed-integer -r 48000 -c 1 - -t raw - rate 28800 | ./edacs-fm -$type -s site.csv -g group.csv -a $A -f $F
#use nc if BSD version, use socat if nc is debian or other half broken version
socat stdio udp-listen:7355 | sox -t raw -b 16 -e signed-integer -r 48000 -c 1 - -t raw - rate 28800 | ./edacs-fm -$type -s site.csv -g group.csv -a $A -f $F -v

