## This is a quick copy pasta file for the docker installation on Debian 9


apt-get update



apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common



curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -



add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"



apt-get update



apt-get install docker-ce docker-ce-cli containerd.io
