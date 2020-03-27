![stability-wip](https://img.shields.io/badge/stability-unstable-lightgrey.svg)
<img src="https://i.imgur.com/zRXWDEK.png" width="190" height="164" align="right"/>

# Halo CE dedicated server dockerized

## About

This is a Dockerfile for running the Halo CE dedicated server under Linux. The container uses Wine to run the Windows application and xvfb to create a virtual desktop.

The container is running 100% headless - no GUI is required for installation, execution or configuration.

The game files are required in order to start this container. They are not bundled within the container and you will have to provide them.

## Usage

    docker run -d -p 2302:2302/udp -p 2303:2303/udp -v /path/to/game:/game -v /path/to/config:/config -v /path/to/logs:/logs augusdogus/docker-haloce-sapp

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
