#comment out git commands if you are rebuilding on your own code, sometimes git commands do strange things
#git pull
#sleep 2
gcc -o edacs-fm edacs-fm.c $(ncursesw5-config --cflags --libs)
gcc -o edacs-fm-single edacs-fm-single.c $(ncursesw5-config --cflags --libs)
gcc -o edacs-lcn edacs-lcn.c
#comment lines above and uncomment below lines if ncurses produces garbled ascii art, or you have newer than ncurses5, i.e. ARCH LINUX
#gcc -o edacs-fm edacs-fm.c -lncurses
#gcc -o edacs-fm-single edacs-fm-single.c -lncurses

#adding line to make these all executable again in case git pull changes it 
#chmod +x build.sh rebuild.sh start-control-gr.sh start-control-rtlfm.sh start-lcn-gr.sh start-lcn-rtludp.sh start-pyedacs-gr.sh start-sdrpp-gqrx-udp-signal.sh
#chmod +x *.sh
