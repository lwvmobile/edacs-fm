#rebuild for cygwin builds only
git pull
sleep 2

gcc -o edacs-fm edacs-fm.c -lncurses -Wl,--stack,900000000
gcc -o edacs-lcn edacs-lcn.c

chmod +x *.sh
