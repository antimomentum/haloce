echo 'deb http://deb.debian.org/debian stretch-backports main' >> /etc/apt/sources.list && \
     dpkg --add-architecture i386 && \
     apt-get update && \
     apt install -y wine32 libwine:i386 fonts-wine
