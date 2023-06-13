## Rootless install for Docker

This is only tested on Ubuntu 20.04. Does not appear to work on Debian 10 using apt.

There seems to be an issue with crashing if players are in the game for a while. 
This is not an issue in the root/sudo version of Docker so it is likely due to rootless not having some needed permissions.
I am looking into it.


The install script is based on the Docker docs for Ubuntu:


https://docs.docker.com/engine/security/rootless/


Note: While this is a rootless install the following privilege might still needed, try without this first:


kernel.unprivileged_userns_clone=1


Obviously a root or sudo user is still needed for the apt install requirements that rootless Docker will use. However, Docker is only installed for "testuser"


Future plans include making the halo container rootless too. Regardless its permissions should still be limited to the non-sudo "testuser"


After the install script is done:


Login as testuser

    su - testuser

    
To start Docker

    bin/dockerd-rootless.sh &


Example container run

    docker run -it -p 2302:2302/udp antimomentum/halo
