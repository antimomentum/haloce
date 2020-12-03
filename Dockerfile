
# Pull ubuntu image
FROM ubuntu:18.04

# Set environment variables
ENV CONTAINER_VERSION=0.1 \
    DISPLAY=:1 \
    DEBIAN_FRONTEND=noninteractive \
    PUID=0 \
    PGID=0

# Install temporary packages
RUN apt-get update && apt-get install -y apt-transport-https && apt-get install -y wget && apt-get install -y apt-utils && apt-get install -y gnupg && apt-get install -y software-properties-common && apt-get install -y aptitude && apt-get install -y wget && dpkg --add-architecture i386 && wget -nv https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/Release.key -O Release.key && apt-key add - < Release.key && apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./' && apt-get update && apt install --install-recommends -y winehq-stable && apt-get install -y unzip && apt autoremove

# Cleanup
RUN apt-get remove -y software-properties-common apt-transport-https cabextract && \
    rm -rf /var/lib/apt/lists/* && \
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
COPY ./halopull /game
COPY ["./Halo CE", "/root/My Games/Halo CE"]
# Set working directory into the game directory
WORKDIR /game

# Expose necessary ports
EXPOSE 2302/udp 2303/udp

# Set volumes
VOLUME /game

# update me
