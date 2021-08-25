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
 
    docker run -it -p 2302:2302/udp antimomentum/halo


No lead Team slayer server. Assult Rifle and Pistol starting weapons. Some of the regular Halo maps are used in the mapcycle:

docker run -it -p 2302:2302/udp antimomentum/noleadts

## To install custom server/sapp files!

git clone https://github.com/antimomentum/haloce

cd haloce

Now copy in your halo server files, all in one folder named "halopull"

Then do:

docker build . 

You should see something like: "Successfully built f01ecb978acc" <---- the f01ecb is the docker image you need to start the container. So do:

docker run -it -p 2302:2302/udp f01ecb978acc 

with the f01ecb replaced with whatever ID you got from the docker build :) 

##  Push your halo server images to docker!

docker build -t YourDockerUsername/MadeUpImageName . 

apt-get install gnupg

docker login

docker push YourDockerUsername/MadeUpImageName

## If not using default port 2302 ## 

To use a different port for the Halo Custom Edition server two changes must be made:

1. In the Dockerfile the last line must be given a port switch at the end to build the container, example:

CMD wineconsole --backend=curses haloceded -path . -port 2304

2. Then when running it, the port switch must also use 2304. Example:

docker run -it -p 2304:2304/udp antimomentum/icelandic-tundra-port2304

## Docker Compose ##

Docker compose can be used to quickly bring up multiple halo containers after they've been built. If you plan on using docker compose, you must build your containers with the compatible "Dockerfile-compose" file rather than "Dockerfile"

You can also delete the main Dockerfile and rename Dockerfile-compose to Dockerfile.

By default Docker uses "Dockerfile" for the build instructions, or you can build them like so:

docker build -t yourdockerID/yourcontainer -f Dockerfile-compose .

-f specifies the file for Docker to build with if not using "Dockerfile"

I have provided an example docker-compose.yml file. Once you have your own containers built you can use yours in the yml instead. To use compose:

docker-compose -d

This brings up all containers in the yml.

To attack to a running container get a list of the *running* containers:

docker ps

Then something like this to attach:

docker attach --detach-keys z haloce_halo_1

haloce_halo_1 is just an example name you might see from docker ps

press z to leave the halo console without closing the container you attached too.

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
