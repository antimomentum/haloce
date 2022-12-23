## This is a quick copy pasta file for the docker installation on Debian 9 on amd64 systems

apt-get update
wait
sleep 1

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
