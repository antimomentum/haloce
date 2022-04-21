## This is a quick copy pasta file for the docker installation on Debian 9 on amd64 systems
## Update to also build a local "wineconsole/lite" container
## And unzip
## Creates unrequired start-example.sh script, replace "halopull" files with your own files :)


apt-get update
wait

apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    unzip \
    software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
wait

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

apt-get update
wait
apt-get install docker-ce docker-ce-cli containerd.io
wait
sleep 3
echo "Building your wineconesole/lite container"

sleep 5

# Create Dockerfile

cat <<DOCK >Dockerfile
FROM i386/alpine:3.13
RUN apk add --no-cache wine freetype ncurses
DOCK

wait

# Build fresh wineconsole container :)

docker build -t wineconsole/lite .

# Create wineconsole/lite start-example.sh script:

cat <<WEND >start-example.sh
#!/bin/bash
# Expects a halo server directory named "halopull":
wget -O halopull.zip https://github.com/antimomentum/halopull/archive/refs/heads/master.zip && unzip halopull.zip && mv halopull-master halopull
wait 
i=2302
docker run -it -v ~/halopull:/game -w /game -p \$i:\$i/udp --add-host=s1.master.hosthpc.com:34.197.71.170 --add-host=hosthpc.com:34.197.71.170 wineconsole/lite wineconsole haloceded.exe -path . -port \$i
WEND

chmod +x start-example.sh
