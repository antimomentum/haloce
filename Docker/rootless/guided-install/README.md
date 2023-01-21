# Rootless Docker installation for Halo

Requirements:

Ubuntu20.04LTS that does not have Docker installed. 
Bash

It is also recommended not to install Wine to the host. This install will cause Docker to run without root/sudoer privileges, unlike normal Docker or wine.


This assumes you're not using another firewall such as ufw. This firewall will automatically block non-established ips while still allowing things like apt update to work at the same time as halo packets are filtered :)


The "halopull" folder containing halo server files is NOT required. You can replace this with your own server files.


# Instructions:


After running the installer like so:

    ./installer.sh

assuming everything was successful first add your ip to the firewall.sh file it made so that you don't lose remote access to your server. You can simply add a line with your ip like the following example to the bottom of the file with 1.1.1.1 as an example ip:

    ipset add WHITELIST 1.1.1.1


Next you must specify the public interface for the firewall before running it. The ip command should show your interface names:

    ip a


Assuming your public interface name (the interface getting packets from the internet) is named eth0, here is an example to run the firewall:

    $HOME/firewall.sh eth0


Then start the rootless Docker service. First log into the rootless testuser account:

    su - testuser
    
Then start Docker:

    bin/dockerd-rootless.sh &

You can then log back out of testuser and the rootless Docker service will remain running:

    logout

Now you should be able to run the start-example script. If everything was successful so far this should be able to both download and run the image from Docker while the firewall is running. As mentioned already you can change "halopull" to your own halo files.


You can attach to the container by doing:

    docker attach --detach-keys z 2308
