#!/bin/sh

NC='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'

# Function to create default configuration depending on path
create_default_config()
{
    echo "${YELLOW}Could not find an existing configuration file. Creating one for you.${NC}"
    echo "${YELLOW}Make sure to adjust important settings like your RCon password!${NC}"

    sleep 2

    echo "Copying default init.txt."
    cp /defaults/init.txt $1
}

echo "Initializing v${CONTAINER_VERSION} for HaloCE SAPP v10.1"

# Search for haloceded.exe in game directory
if [ ! -e /game/haloceded.exe ]; then
    echo "${RED}Could not find haloceded.exe. Did you mount the game directory to /game?${NC}"
    sleep 2
    exit 1
fi

# Search for SAPP in game directory
# if [ ! -e /game/sapp.dll ]; then
#    echo "${YELLOW}Could not find SAPP. Downloading it for you.${NC}"
#    sleep 2
#    # Download SAPP v10.1 for Halo CE to game directory
#    wget https://opencarnage.net/misc/sapp_ce.zip -P /game && \
#    unzip sapp_ce.zip && \
#    mv sapp_ce/*.dll . && \
#    # Cleanup
#    rm -rf sapp_ce/ sapp_ce.zip && \
#    echo "${GREEN}SAPP download complete.${NC}"
#fi

# Create user if container should run as user
if [ -z "${RUN_AS_USER}" ]; then
    echo "Running as root"
    user=root

    if [ $PUID -ne 0 ] || [ $PGID -ne 0 ]; then
        echo "${RED}Tried to set PUID OR PGID without setting RUN_AS_USER.${NC}"
        echo "${RED}Please set RUN_AS_USER or remove PUID & PGID from your environment variables.${NC}"

        sleep 2
        exit 40
    fi
else
    echo "Running as haloce"
    user=haloce

    if [ $PUID -lt 1000 ] || [ $PUID -gt 60000 ]; then
        echo "${RED}PUID is invalid${NC}"

        sleep 2
        exit 20
    fi

    if [ $PGID -lt 1000 ] || [ $PGID -gt 60000 ]; then
        echo "${RED}PGID is invalid${NC}"

        sleep 2
        exit 30
    fi

    if ! id -u haloce > /dev/null 2>&1; then
        echo "Creating user"
        useradd -u $PUID -m -d /tmp/home haloce
    fi
fi

# Search for init.txt in /game directory
if [ ! -e "init.txt" ]; then
    create_default_config "/game"
fi

if [ -z "${SKIP_CHOWN}" ]; then
    echo "Taking ownership of folders"
    chown -R $PUID:$PGID /game /wine

    echo "Changing folder permissions"
    find /game -type d -exec chmod 775 {} \;

    echo "Changing file permissions"
    find /game -type f -exec chmod 664 {} \;
fi

echo "${GREEN}Starting dedicated server${NC}"

Xvfb :1 -screen 0 1280x960x24 

# Start the server
su -c "DISPLAY=:0 wineconsole /game/haloceded.exe" $user

if [ -z "${WAIT_ON_EXIT}" ]; then
    echo "${RED}Server terminated, exiting${NC}"
else
    echo "${RED}Server terminated, waiting${NC}"
    sleep infinity
fi
