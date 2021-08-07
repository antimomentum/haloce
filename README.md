![stability-wip](https://img.shields.io/badge/stability-unstable-lightgrey.svg)
<img src="https://i.imgur.com/zRXWDEK.png" width="190" height="164" align="right"/>

# Halo CE dedicated server dockerized

## About

This is a Dockerfile for running the Halo CE dedicated server under Linux. The container uses Wine to run the Windows application and xvfb to create a virtual desktop.

The container is running 100% headless - no GUI is required for installation, execution or configuration.

To install docker:

apt update

apt-get install docker.io

## Usage

SAPP 10.2.x is working! (UPX and no UPX versions for sapp 10.2 and 10.2.1) It is much more stable than 10.1 that the previous container used. Note: you can drop privileges! Example: sudo docker run -it -p 2302:2302/udp --cap-drop NET_RAW --cap-drop NET_BIND_SERVICE antimomentum/haloce
 
    docker run -it -p 2302:2302/udp antimomentum/haloce


No lead Team slayer server. Assult Rifle and Pistol starting weapons. Some of the regular Halo maps are used in the mapcycle:

docker run -it -p 2302:2302/udp antimomentum/noleadts

## To install custom server/sapp files!

git clone https://github.com/antimomentum/haloce

cd haloce

mkdir halopull

mkdir 'Halo CE'


Now copy in the haloceded.exe, Strings.dll, sapp.dll (basically whatever is from you Program Files\Micorosft Games\Halo Custom Edition folder) in the halopull folder.
For sapp, also copy your My Documents\My Games\Halo CE stuff in the 'Halo CE' folder.


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

## But wait! There's more! Automated Installs of YOUR server files!

So if you sucessfully built and ran a container with your own custom server files you might be wondering: "Well, if I buillt my own container what do I need the antimomentum/haloce container for?"

The answer is you don't!

To push your own container image to Docker make a docker account on the docker website. A free account is fine and is what I'm using.


Make sure your container halo server isn't currently running. docker ps will show running containers. docker stop containerid will close the container.


Now tag your image. 

docker build -t dockerusername/imagename .


Don't forget the . there! Also, the imagename can be whatever you make up for it.


next install this:


apt-get install gnupg


Then login to docker:


docker login


then push your custom server image to docker!


docker push dockerusername/imagename


To download your image to a new server:


apt update


apt-get install docker.io


docker run -it -p 2302:2302/udp dockerusname/imagename


Done :)


Want to run multiple servers?


apt-get install -y screen


screen -S halo1 docker run -it -p 2304:2304 dockerusername/imagename wineconsole haloceded.exe -port 2304

You'll notice all the ports match each other. (In order it's: hostport:dockerport and at the end of the command is wineconsole telling halo which port it needs). For the next server make sure it has its own port that matches too, and just repeat


screen -S halo2 docker run -it -p 2308:2308 dockerusername/imagename2 wineconsole haloceded.exe -port 2308


In other words all you have to do is make an image for EACH halo server once. After that you can run them simply by specifying the image name and port like we just did here!


Side Note: Some cloud providers already use Screen for the web interface. IF screen is already installed and you're using Windows, download Putty and try apt-get install screen
You'll notice screen actually installed itself this time, and that will allow you to use the screen keyboard shortcuts! :)


## Thanks and Resources ##

Special thanks to:

AugusDogus

Chalwk77 https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Devieth
http://halopc.com/sv_extensions/

.þsϵυdø.þrø×϶n

Crash
https://theashclan.org/

Chimera http://vaporeon.io/hosted/halo/chimera/ 

Everyone else involved in helping make Halo more awesome
