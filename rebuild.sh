#comment out git pull if you are rebuilding on your own code, else leave if you want to update your own install
git checkout .
git pull
#gcc -o ledacs-esk-analyzer ledacs-esk-analyzer.c
#not sure if analyzer will return or not
gcc -o edacs-fm edacs-fm.c $(ncursesw5-config --cflags --libs)
#uncomment line above and comment below line if ncurses produces garbled ascii art, or you have newer than ncurses5, i.e. ARCH LINUX
#gcc -o edacs-fm edacs-fm.c -lncurses
gcc -o edacs-lcn edacs-lcn.c

