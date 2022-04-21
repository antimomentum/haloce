![stability-wip](https://img.shields.io/badge/stability-unstable-lightgrey.svg)
<img src="https://i.imgur.com/zRXWDEK.png" width="190" height="164" align="right"/>

# Halo CE dedicated server dockerized

## About

This is a Dockerfile for running the Halo CE dedicated server under Linux.

The container is running 100% headless - no GUI is required for installation, execution or configuration.

To install docker:

    apt update
    apt-get install docker.io

## Usage

SAPP 10.2.x is working! (UPX and no UPX versions for sapp 10.2 and 10.2.1) It is much more stable than 10.1 that the previous container used. Note: you can drop privileges! Example: sudo docker run -it -p 2302:2302/udp --cap-drop NET_RAW --cap-drop NET_BIND_SERVICE antimomentum/halo
 
    docker run -e INTERNAL_PORT=2302 -it -p 2302:2302/udp antimomentum/halo


No lead Team slayer server. Assult Rifle and Pistol starting weapons. Some of the regular Halo maps are used in the mapcycle:

    docker run -e INTERNAL_PORT=2302 -it -p 2302:2302/udp antimomentum/noleadts

## Run your own halo files:
Put your halo files into one directory named "halopull"

Example halo server file structure can be found here:


https://github.com/antimomentum/halopull



Use the Dockerfile to build a local wineconsole container:

    cd Dockerfiles
    docker build -t wineconsole/lite .


Then run your server!

    docker run -v ~/halopull:/game -e INTERNAL_PORT=2302 -it -p 2302:2302/udp wineconsole-lite


##  Push your halo server images to docker!

docker build -t YourDockerUsername/MadeUpImageName . 

    apt-get install gnupg
    docker login
    docker push YourDockerUsername/MadeUpImageName

## If not using default port 2302 ## 

INTERNAL_PORT is simply the -port number you give to Halo. 

For instance, in Windows if you started the halo server by doing:

haloceded.exe -port 2312

then INTERNAL_PORT=2312


also -p Docker ports must match. So: docker run -e INTERNAL_PORT=2312 -p 2312:2312/udp

## Docker Compose ##

Docker compose can be used to quickly bring up multiple halo containers after they've been built. If you plan on using docker compose, you must build your containers with the compatible "Dockerfile-compose" file rather than "Dockerfile"

I have provided an example docker-compose.yml file. Once you have your own containers built you can use yours in the yml instead. To use compose:

    docker-compose up -d

This brings up all containers in the yml.

To attach to a running container get a list of the *running* containers:

    docker ps

Then something like this to attach:

    docker attach --detach-keys z halo_first_1


press z to leave the halo console without closing the container you attached too.

To stop all containers that docker-compose started:

    docker-compose down


## Thanks and Resources ##

Special thanks to:

Haloss1

AugusDogus

Chalwk77 https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Devieth
http://halopc.com/sv_extensions/

.þsϵυdø.þrø×϶n

Crash
https://theashclan.org/

Chimera http://vaporeon.io/hosted/halo/chimera/ 

Everyone else involved in helping make Halo more awesome
