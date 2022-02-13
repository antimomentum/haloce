<img src="https://cdn2.steamgriddb.com/file/sgdb-cdn/logo_thumb/a4c42bfd5f5130ddf96e34a036c75e0a.png" width="190" align="right"/>

# Halo CE dedicated server dockerized

[DockerHub](https://hub.docker.com/r/antimomentum/halo)

## About

This is a [Dockerfile](https://docs.docker.com/engine/reference/builder/) for running the Halo CE dedicated server under Linux.

The [container](https://www.docker.com/resources/what-container) is running 100% headless - no GUI is required for installation, execution or configuration.

## To install Docker:

Follow the [Docker install documentation](https://docs.docker.com/get-docker/) for your platform and distro.

## Usage

SAPP 10.2.x is working! (UPX and no UPX versions for sapp 10.2 and 10.2.1) It is much more stable than 10.1 that the previous container used. 

``` 
docker run -it -p 2302:2302/udp antimomentum/halo
```

**_NOTE:_** you can drop privileges! 

**_Example:_** 
```
$ docker run -it -p 2302:2302/udp --cap-drop NET_RAW --cap-drop NET_BIND_SERVICE antimomentum/halo
```

## To install custom server/sapp files!

```
$ git clone https://github.com/antimomentum/haloce
```
```
$ cd haloce
```
Now copy in your halo server files, all in one folder named `halopull`

Then do:
```
docker build . 
```
You should see something like: 
```
"Successfully built f01ecb978acc" 
```
The `f01ecb` is the docker image you need to start the container.

So do:
```
docker run -it -p 2302:2302/udp f01ecb978acc 
```
With the `f01ecb` replaced with whatever `ID` you got from the `docker build` :) 

##  Push your halo server images to docker!
```
docker build -t YourDockerUsername/MadeUpImageName . 
```
```
apt-get install gnupg
```
```
docker login
```
```
docker push YourDockerUsername/MadeUpImageName
```
## Example custom image:

### No lead Team slayer server.

Assult Rifle and Pistol starting weapons. 
Some of the regular Halo maps are used in the mapcycle:
```
docker run -it -p 2302:2302/udp antimomentum/noleadts
```
## If not using default port 2302 ## 

To use a different port for the Halo Custom Edition server two changes must be made:

1. In the `Dockerfile` the last line must be given a port switch at the end to build the container.

Example:

DockerFile
```
CMD wineconsole --backend=curses haloceded -path . -port 2304
```

2. Then when running it, the port switch must also use 2304. 

Example:
```
docker run -it -p 2304:2304/udp antimomentum/icelandic-tundra-port2304
```

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
