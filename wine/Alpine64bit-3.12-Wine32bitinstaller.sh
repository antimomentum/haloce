# Installs 32bit Wine on 64bit Alpine3.12
# NOTE: The first command makes apk install 32bit packages only, you may need to change it back for other installations!

echo "x86" > /etc/apk/arch && \
     apk add --no-cache libcurl && \
     apk add --no-cache wine freetype ncurses
