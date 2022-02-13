# Pull ubuntu image
FROM amd64/debian

# Set environment variables
ENV CONTAINER_VERSION=0.1 \
    DISPLAY=:1 \
    DEBIAN_FRONTEND=noninteractive \
    PUID=0 \
    PGID=0

# Install temporary packages
RUN echo 'deb http://deb.debian.org/debian stretch-backports main' >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y apt-transport-https && apt-get install -y wget && apt-get install -y && dpkg --add-architecture i386 && apt-get update && apt install -y wine wine32 wine64 libwine libwine:i386 fonts-wine

# Set start command to execute the start script
CMD wineconsole haloceded.exe
COPY ./halopull /game
COPY ["./Halo CE", "/root/My Games/Halo CE"]
# Set working directory into the game directory
WORKDIR /game

# Expose necessary ports
EXPOSE 2302/udp 2303/udp

# Set volumes
VOLUME /game
