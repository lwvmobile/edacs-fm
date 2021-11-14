socat stdio udp-listen:2001 | tee >(sox -t raw -b 16 -e signed-integer -r 48000 -c 1 - -t raw - vol 2 sinc 0.2k-4.5k -a 110 rate 48000 2> /dev/null | aplay -t raw -f S16_LE -r 48000 -c 1 2> /dev/null ) | ./edacs-lcn

