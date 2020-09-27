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

SAPP is working! Note: --privileged gives the container full root access to the host OS. Feel free to try different docker run commands for more secure execution!
 
    docker run -it -p 2302:2302/udp -p 2303:2303/udp -p 80:80 --privileged antimomentum/haloce


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

docker run -it -p 2302:2302/udp -p 2303:2302/udp -p 80:80 --privileged f01ecb978acc 

with the f01ecb replaced with whatever ID you got from the docker build :) 

## What's that? Copy files to a linux server?

If you're not familiar with command line linux and aren't sure how to get your custom files
to your server, Filezilla makes this pretty easy. Most cloud providers like Linode and DigitalOcean provide ssh access
and port access by default. 
So in Filezilla on your Windows PC enter do this:
For host enter the IP address of your server
Username: root
password is whatever root password you made on your cloud provider dashboard
port is 22
The haloce folder is probably under /root/haloce


## Step by step example 


At cloud.linode.com/linodes click Add a Linode

Under Choose a Distribution pick Ubuntu 18 LTS

For Linode plan pick Nanode 1GB

Type in a Root Password and then click create

After it provisions and boots up click on it. You should see "Launch Console" to the right of the page. Click that

Login as: root

with the password you typed in

Then issue:

apt update

apt upgrade

apt-get install docker.io

docker run -it -p 2302:2302/udp -p 2303:2303/udp -p 80:80 --privileged antimomentum/haloce

Wait for it to build and boot

sv_name "Test Container"

You can now find it in the game server list from the game client :)  Make sure your halo server list isn't filtering empty servers!

Here are some sapp commands:

pl

map


## But wait! There's more! Automated Installs of YOUR server files!

So if you sucessfully built and ran a container with your own custom server files you might be wondering: "Well, if I buillt my own container what do I need the antimomentum/haloce container for?"

The answer is you don't!

To push your own container to Docker make a docker account on the docker website. A free account is fine and is what I'm using.


Make sure your container halo server isn't currently running. docker ps will show running containers. docker stop containerid will close the container.


Now tag your image. Remember the image ID you got when you succesfully built your custom container image? You needed it to use the docker run command for your files. Good. Give it a name.


docker tag imageid dockerusername/containername


containerid is the id you got from the docker build . command. dockerusername is your docker user name. And containername is whatever name you want to give it :)


next install this:


apt-get install gnupg


Then login to docker:


docker login


then push your custom server image to docker!


docker push -t dockerusername/containername


To download your image to a new server:


apt update


apt-get install docker.io


docker run -t -p 2302:2302/udp -p 2303:2303/udp -p 80:80 --privileged dockerusname/containername


Done :)


## Configuration

### Ports
| Port       | Protocol | Description |
|------------|----------|-------------|
| `2302` | UDP | The host listener port.  |
| `2303` | UDP | The client connection port. |

### Volumes

| Path       | Description | Required |
|------------|-------------|----------|
| `/game` | Has to be mounted with the HaloCE Custom Edition game files in place. | Yes |
| `/config` | Contains config files, if not supplied the default configuration is used. | No |
| `/logs` | Contains the server logs. | No |
