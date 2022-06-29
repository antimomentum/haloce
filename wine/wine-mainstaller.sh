# Installs wine to run the halo server in Ubuntu 18.04, 20.04, 21.04, Debian 10, and Debian 11
# Ubuntu 22.04 LTS has issues, does not install in Ubuntu 16.04 LTS. See other wine installers for Debian 9 and Alpine distros
# This can also be used for Dockerfiles

dpkg --add-architecture i386 && \
    apt update && \
    apt install -y wine32 libwine:i386 fonts-wine
