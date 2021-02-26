echo 'deb http://deb.debian.org/debian stretch-backports main' >> /etc/apt/sources.list
apt-get update
wait
apt-get install -y apt-transport-https
wait
apt-get install -y wget && apt-get install -y && dpkg --add-architecture i386
wait
apt-get update
wait
apt install -y wine wine32 wine64 libwine libwine:i386 fonts-wine
wait
