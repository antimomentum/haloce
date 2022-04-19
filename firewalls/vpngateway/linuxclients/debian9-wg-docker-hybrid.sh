apt-get update
wait
apt upgrade -y
wait
sleep 3
apt install unzip
wait
sleep 1
wget -O halopull.zip https://github.com/antimomentum/halopull/archive/refs/heads/master.zip && unzip halopull.zip && mv halopull-master halopull
wait
sleep 2

apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common



curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -



add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"



apt-get update



apt-get install docker-ce docker-ce-cli containerd.io
wait
sleep 3

docker pull antimomentum/halo
wait

echo "Building your wineconesole container, this may take a while...press Ctrl + C to cancel"

sleep 5

cat <<DOCK >Dockerfile
FROM i386/alpine:3.13
RUN apk add --no-cache wine freetype ncurses
DOCK

wait

docker build -t halo/wineconsole .

cat <<WEND >start-example.sh
#!/bin/bash
systemctl stop systemd-timesyncd
wait
sleep 2
systemctl stop systemd-resolved
wait
wg-quick up wg0 
wait
sleep 2
VAR1=\$(wg | grep -o latest)
VAR2="latest"
until [ "\$VAR1" = "\$VAR2" ]; do
    echo "Waiting for handshake with gateway"
    sleep 1
    VAR1=\$(wg | grep -o latest)
done
echo "Handshake established! Starting halo container..."
sleep 2
i=2304
docker run -it -v ~/halopull:/game -w /game -p \$i:\$i/udp --add-host=s1.master.hosthpc.com:34.197.71.170 --add-host=hosthpc.com:34.197.71.170 halo/wineconsole wineconsole haloceded.exe -path . -port \$i
WEND

chmod +x start-example.sh


echo "Installing Wireguard, press Ctrl + C to cancel..."
sleep 5

echo "deb http://deb.debian.org/debian/ unstable main" > \
/etc/apt/sources.list.d/unstable-wireguard.list

printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > \
/etc/apt/preferences.d/limit-unstable

apt update
wait
apt-get install wireguard-dkms wireguard-tools -y
wait

echo "Done"

sleep 3

echo "Cleanup.."

apt-get remove \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    unattended-upgrades -y

wait

apt autoremove -y


echo "Done"

sleep 1
