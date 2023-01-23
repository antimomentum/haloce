#!/bin/bash

# Rootless Docker install docs:
# https://docs.docker.com/engine/security/rootless/

# wget, curl, nano, unzip, and sudo are NOT required. You could technically install everything without those 5 tools, but they will make the install easy
apt-get update -y && \
  apt-get -y install \
  iptables \
  sudo \
  unzip \
  wget \
  ipset \
  curl \
  nano \
  uidmap \
  dbus-user-session

wait
sleep 1

# echo "kernel.unprivileged_userns_clone=1" >> /etc/sysctl.conf
wait
useradd -m testuser
usermod --shell /bin/bash testuser


sudo -H -u testuser bash -c 'echo "I am $USER, with uid $UID"'
sudo -H -u testuser bash -c 'curl -fsSL https://get.docker.com/rootless | sh'
wait
sudo -i -u testuser sh -c 'echo "export XDG_RUNTIME_DIR=/home/testuser/.docker/run" >> .bashrc'
sudo -i -u testuser sh -c 'echo "export PATH=/home/testuser/bin:$PATH" >> .bashrc'
sudo -i -u testuser sh -c 'echo "export DOCKER_HOST=unix:///home/testuser/.docker/run/docker.sock" >> .bashrc'

# Since Docker is NOT installed to your current prvileged account running this script,
# create an alias for your current user to run docker commands from the non-privileged testuser account:

cat <<WUSH >>$HOME/.bashrc
docker() {
    su - testuser -c "docker \$*"
}
WUSH

cat <<TU >>$HOME/.bashrc
testuser() {
su - testuser -c "\$*"
}
TU

# The following halopull.zip is not required. But shows chown may be necessary regardless:
sudo -H -u testuser bash -c 'cd && wget -O halopull.zip https://github.com/antimomentum/halopull/archive/refs/heads/master.zip && unzip halopull.zip && mv halopull-master halopull'
wait
# In case you download halo files through an account that isn't testuser:
# chown -R testuser: /home/testuser/halopull


cat <<EXAMPLE >>$HOME/.bashrc
halopull() {
    echo "\$*" >> /home/testuser/halopull/input.txt
}
EXAMPLE

# Grab the firewall and make it executable:
wget https://raw.githubusercontent.com/antimomentum/haloce/master/firewalls/firewall-newtest-rawtrack.sh && \
chmod +x firewall-newtest-rawtrack.sh && \
mv firewall-newtest-rawtrack.sh $HOME/firewall.sh

# Create an example start script with a function to pass docker commands to the non-privileged testuser account:
cat <<DRUN >start-example.sh
docker() {
su - testuser -c "docker \$*"
}

# the rootless port won't actually be 2308
i=2308 && \\
docker run -itd --rm \\
--name=\$i \\
-e INTERNAL_PORT=\$i \\
-v /home/testuser/halopull:/game \\
-p \$i:\$i/udp \\
--add-host=s1.master.hosthpc.com:34.197.71.170 \\
--add-host=hosthpc.com:34.197.71.170 \\
wineconsole/halo
DRUN

chmod +x start-example.sh


cat <<CONSOLE >nohup-start.sh
docker() {
su - testuser -c "docker \$*"
}

# the rootless port won't actually be 2304
i=halopull && \\
p=2304 && \\
docker run -itd --rm \\
--name=\$i \\
-v /home/testuser/\$i:/game \\
-e INTERNAL_PORT=\$p \\
-p \$p:\$p/udp \\
--add-host=s1.master.hosthpc.com:34.197.71.170 \\
--add-host=hosthpc.com:34.197.71.170 \\
antimomentum/nohup-haloce
CONSOLE

chmod +x nohup-start.sh

sleep 1

# Reboot may not be necessary if you logout and log back in to your own user.
reboot
