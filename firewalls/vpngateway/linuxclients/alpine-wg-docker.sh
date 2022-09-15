# service sshd stop
# Wireguard Gateway install

apk update
apk upgrade

echo "Installing Wireguard, press Ctrl + C to cancel..."
sleep 5
apk add wireguard-tools
wait
sleep 3
apk add unzip
wait
sleep 3
apk add wget
wait
sleep 1

wget -O halopull.zip https://github.com/antimomentum/halopull/archive/refs/heads/master.zip && unzip halopull.zip && mv halopull-master halopull
wait
sleep 2

apk add docker
wait
sleep 3
service docker start

docker pull antimomentum/halo
wait

echo "Building your wineconesole container, this may take a while...press Ctrl + C to cancel"

sleep 5

cat <<DOCK >Dockerfile
# Pull ubuntu image
FROM i386/alpine:3.13
RUN apk add --no-cache wine freetype ncurses
DOCK

wait

docker build -t wineconsole/lite .

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
Here=\$(pwd)
wait
docker run -it -v \$Here/halopull:/game \\
-w /game -p \$i:\$i/udp \\
--add-host=s1.master.hosthpc.com:34.197.71.170 \\
--add-host=hosthpc.com:34.197.71.170 \\
wineconsole/lite \\
wineconsole haloceded.exe -path . -port \$i
WEND

chmod +x start-example.sh


echo "Done"

sleep 3

echo "Cleanup.."



echo "Done"

sleep 1
