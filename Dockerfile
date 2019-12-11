# Pull ubuntu image
FROM ubuntu:18.04

# Set environment variables
ENV CONTAINER_VERSION=0.1 \
    DISPLAY=:1 \
    DEBIAN_FRONTEND=noninteractive \
    PUID=0 \
    PGID=0

# Install temporary packages
RUN apt-get update && \
    apt-get install -y wget unzip software-properties-common apt-transport-https cabextract

# Install Wine stable
RUN dpkg --add-architecture i386 && \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && \
    rm winehq.key && \
    apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' && \
    apt-get update && \
    apt-get install -y winehq-stable

# Download winetricks from source
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x ./winetricks

# Install X virtual frame buffer and winbind
RUN apt-get install -y xvfb winbind

# Cleanup
RUN apt-get remove -y software-properties-common apt-transport-https cabextract && \
    rm -rf /var/lib/apt/lists/* && \
    rm winetricks && \
    rm -rf .cache/

# Add the start script
ADD start.sh .

# Add the default configuration files
ADD defaults defaults

# Make start script executable and create necessary directories
RUN chmod +x start.sh && \
    mkdir logs

# Set start command to execute the start script
CMD /start.sh

# Set working directory into the game directory
WORKDIR /game

# Expose necessary ports
EXPOSE 2302/udp 2303/tcp

# Set volumes
VOLUME /game