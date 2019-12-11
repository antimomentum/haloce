![stability-wip](https://img.shields.io/badge/stability-work_in_progress-lightgrey.svg)
<img src="https://i.imgur.com/zRXWDEK.png" width="190" height="164" align="right"/>

# Halo CE dedicated server dockerized

## About

This is a Dockerfile for running the Halo CE dedicated server under Linux. The container uses Wine to run the Windows application and xvfb to create a virtual desktop.

The container is running 100% headless - no GUI is required for installation, execution or configuration.

The game files are required in order to start this container. They are not bundled within the container and you will have to provide them.

## Usage

See the docker-compose [here](https://github.com/DomiStyle/docker-eldewrito/blob/master/docker-compose.yml)  (recommended) or manually start the container with the following command:

    docker run -d -p 11774:11774/udp -p 11775:11775/tcp -p 11776:11776/tcp -p 11777:11777/tcp -v /path/to/game:/game -v /path/to/config:/config -v /path/to/logs:/logs --cap-add=SYS_PTRACE domistyle/eldewrito

**The capability SYS_PTRACE is required due to how ElDewrito works. The server won't start without it.**

A [default configuration file](https://github.com/DomiStyle/docker-eldewrito/blob/master/defaults/dewrito_prefs.cfg) and veto/voting rules will be created automatically if no configuration exists in the game directory. If you do not want to use this configuration you can override this behavior by creating your own dewrito_prefs.cfg before starting the container.

### Tags

The following tags are available:

| Name       | Description |
|------------|-------------|
| `latest` | Direct build from master branch. Generally not recommended. |
| `X.Y-testZ` | Tagged builds taken from master branch. Used for testing. |
| `X.Y` | Stable tags. Everything was tested and is working. (not available yet) |

## Tutorial (for Ubuntu hosts)

1. Prepare a Ubuntu host
2. Install Docker for Ubuntu by following [this guide](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
3. Make sure Docker is working by running `docker -v`
4. Install docker-compose with `sudo apt-get install docker-compose`
5. Grab the latest compose file from the git repository [here](https://raw.githubusercontent.com/DomiStyle/docker-eldewrito/master/docker-compose.yml)
6. Put the docker-compose.yml in a folder called eldewrito
7. Switch into the folder and open the file with `nano docker-compose.yml`
8. Adjust `/path/to/game`, `/path/to/config`, `/path/to/logs` accordingly
9. Adjust the image you want to use if necessary, e.g. change domistyle/eldewrito to domistyle/eldewrito:0.6-test5
10. Put your Eldewrito game files into the folder you specified for /game
11. Remove the dewrito_prefs.cfg from your game folder to let the container generate a known working one for you
12. Run `docker-compose up -d`

You're done. Your container will now be running and you can check if it is working by visting http://server_ip:11775 in your browser.

You can use `docker ps` to view running containers.

To update the container either change the image tag inside of your docker-compose.yml and run `docker-compose up -d` or use `docker-compose pull` followed by `docker-compose up -d` if you are using the latest tag.

You can use `docker-compose logs` to view the logs inside of the container.

## Configuration

### Ports
| Port       | Protocol | Description |
|------------|----------|-------------|
| `11774` | UDP | Used for the game traffic |
| `11775` | TCP | Runs the HTTP server used for communication with clients |
| `11776` | TCP | Used for controlling the server via RCon |
| `11777` | TCP | VoIP |

### Volumes

| Path       | Description | Required |
|------------|-------------|----------|
| `/game` | Has to be mounted with the ElDewrito game files in place. | Yes |
| `/config` | Contains the veto.json and voting.json if the default configuration is used. | No |
| `/logs` | Contains the dorito.log and chat.log if the default configuration is used. | No |

### Environment variables

| Variable  | Description | Default  | Required |
|-----------|-------------|----------|----------|
| `RUN_AS_USER` | Set to true or 1 to run as user instead of root. | - | No |
| `PUID` | The user that the game server should be started as. You also need to set RUN_AS_USER. | 1000 | No |
| `PGID` | The group that should own the game, config and logs directories. You also need to set RUN_AS_USER. | 1000 | No |
| `INSTANCE_ID` | Starts the server in multi instance mode when set. Uses the configuration from /config/dewrito_prefs.cfg. Do not edit any config in your game directory in this mode, they will not be used. Instance identifier must be unique. | - | No |
| `SKIP_CHECKSUM_CHECK` | Set to true or 1 to disable the checksum check performed on container start. (not recommended) | - | No |
| `SKIP_CHOWN` | Skips the chowning on container startup. Speeds up container startup but requires proper directory permissions. | - | No |
| `WAIT_ON_EXIT` | Set to true or 1 to wait before the container exits. | - | No |
| `WINE_DEBUG` | Set to true or 1 to get verbose output from Wine. | - | No |

## Issues & limitations

* The announce port(s) and listening port(s) can't be configured separately
  * This means you can't take advantage of container/host ports in Docker yet
  * Only 1:1 binding like 11774:11774 is possible for now
* ~~The server is running as root~~
  * ~~Not a security issue by itself, just bad practice and laziness~~
* ~~The dewrito_prefs.cfg can't be placed outside of the game directory~~ I'm working around this issue for now. Take a look at INSTANCE_ID for more details.
* The banlist.txt can't be placed outside of the game directory
* The server.json can't be placed outside of the game directory
* ~~The DedicatedServer.log can't be placed outside of the game directory~~
