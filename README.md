![stability-wip](https://img.shields.io/badge/stability-unstable-lightgrey.svg)
<img src="https://i.imgur.com/zRXWDEK.png" width="190" height="164" align="right"/>

# Halo CE dedicated server dockerized

## About

This is a Dockerfile for running the Halo CE dedicated server under Linux. The container uses Wine to run the Windows application and xvfb to create a virtual desktop.

The container is running 100% headless - no GUI is required for installation, execution or configuration.

To install docker:

apt-update

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
