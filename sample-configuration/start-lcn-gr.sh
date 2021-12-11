#! /bin/bash
clear
socat stdio udp-listen:2001 | tee >(sox -t raw -b 16 -e signed-integer -r 28800 -c 1 - -t raw - 2> /dev/null | aplay -t raw -f S16_LE -r 28800 -c 1 2> /dev/null ) | ./edacs-lcn

