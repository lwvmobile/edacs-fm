#comment out git commands if you are rebuilding on your own code, sometimes git commands do strange things
git stash
git pull
git stash pop
#gcc -o ledacs-esk-analyzer ledacs-esk-analyzer.c
#not sure if analyzer will return or not
gcc -o edacs-fm edacs-fm.c $(ncursesw5-config --cflags --libs)
#uncomment line above and comment below line if ncurses produces garbled ascii art, or you have newer than ncurses5, i.e. ARCH LINUX
#gcc -o edacs-fm edacs-fm.c -lncurses
gcc -o edacs-lcn edacs-lcn.c

