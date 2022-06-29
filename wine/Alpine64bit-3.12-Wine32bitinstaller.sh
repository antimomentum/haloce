echo "x86" > /etc/apk/arch
wait
apk add --no-cache libcurl
wait
apk add --no-cache wine freetype ncurses
