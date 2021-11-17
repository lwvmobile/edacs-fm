socat stdio udp-listen:2001 | aplay -t raw -f S16_LE -r 48000 -c 1 | ./edacs-lcn

