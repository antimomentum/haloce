
apt-get update
wait
# apt upgrade -y
wait
sleep 3
apt install unzip
wait
sleep 1

# Downloads example working sapp 10.2.1 halo files for troubleshooting. The next line is not required.
wget -O halopull.zip https://github.com/antimomentum/halopull/archive/refs/heads/master.zip && unzip halopull.zip && mv halopull-master halopull
wait
sleep 2

echo "Installing Wireguard, press Ctrl + C to cancel..."

apt install wireguard -y
wait
sleep 5

echo "Installing Docker. Press Ctrl C to cancel"

apt-get install docker.io
wait
sleep 1

# docker pull antimomentum/halo

echo "Building your wineconesole container"

sleep 1

# Create Dockerfile

cat <<DOCK >Dockerfile
FROM i386/alpine:3.13
RUN apk add --no-cache wine freetype ncurses
DOCK

wait

# Build fresh wineconsole container :)

docker build -t wineconsole/lite .

# Creates an example start script

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
Here=\$(pwd)
i=2302
docker run -it -v \$Here/halopull:/game \\
-w /game -p \$i:\$i/udp \\
--add-host=s1.master.hosthpc.com:34.197.71.170 \\
--add-host=hosthpc.com:34.197.71.170 \\
wineconsole/lite \\
wineconsole haloceded.exe -path . -port \$i
WEND

chmod +x start-example.sh

echo "Done"
sleep 5
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
wait
echo "Done"
sleep 1
