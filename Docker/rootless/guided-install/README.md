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
    
    

# But docker attach is slow and isn't good for scripts

So we can use nohup instead. The nohup-start.sh example runs a container that sends the halo console output to a file named nohup.out. We can then
just tail the file. The installer also creates a bashrc alias for the example "halopull" halo server in the unprivileged testuser account (to send halo commands to input.txt), feel free to make aliases for your own halo servers!

So instead of running start-example.sh run the nohup version:

    ./nohup-start.sh


Then you can view the output like so:

    tail -f /home/testuser/halopull/nohup.out

OR

    testuser tail -f halopull/nohup.out


You can issue halo commands like so from your main account you ran the installer from:

    halopull sv_players

One nuance is halo commands that have quotes, for instance: sv_password "test" must be entered like this if using the alias:

    halopull sv_password \"test\"


This allows for bash scripting with your halo server(s) and is much faster than docker attach. One input could even be used to manage multiple containers depending on how you setup your own builds.


You can get the public port(s) of the halo server(s) by doing:

    lsof |grep vpnkit| grep UDP| grep ':' | sed 's/^.*://'| head -1


To stop the halo server and container gracefully:

    halopull quit && docker stop halopull


You can read about some uses for this here:

https://github.com/antimomentum/haloce/tree/master/wine/nohup-aliases


This is the Dockerfile that's used for antimomentum/nohup-haloce in the nohup-start.sh script:

https://github.com/antimomentum/haloce/blob/master/Docker/Dockerfile-nohup-haloce


# docker-compose

 If the install was successful you can also go ahead and install docker-compose:
 
    testuser curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o bin/docker-compose && \
    testuser chmod +x bin/docker-compose && \
    testuser docker-compose --version

The current docker-compose.yml will work in rootless as well, but you may want to replace the containers with antimomentum/nohup-haloce if you want the nohup benefits.
