#! /bin/bash
#set stack size to 16384(~16MB) to import larger csv files without segfault
#issue caused by making a large C array in the stack
#feel free to comment out ulimit if monitoring smaller systems
ulimit -s 16384
nc -l -u -p 7355 | sox -t raw -b 16 -e signed-integer -r 48000 -c 1 - -t raw - rate 28800 | ./edacs-fm -x -s site.csv -g group.csv -v
#use nc if BSD version, use socat if nc is debian or other half broken version
#socat stdio udp-listen:7355 | sox -t raw -b 16 -e signed-integer -r 48000 -c 1 - -t raw - rate 28800 | ./edacs-fm -x -s site.csv -g group.csv -v

