
#!/bin/bash

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
wait


cat <<WUSH >>$HOME/.bashrc
docker() {
    su - testuser -c "docker \$*"
}
WUSH

wget -O halopull.zip https://github.com/antimomentum/halopull/archive/refs/heads/master.zip && \
unzip halopull.zip && \
mv halopull-master halopull && \
mv halopull /home/testuser/ && \
chown -R testuser: /home/testuser/halopull && \
wget https://raw.githubusercontent.com/antimomentum/haloce/master/firewalls/firewall-newtest-rawtrack.sh && \
chmod +x firewall-newtest-rawtrack.sh && \
mv firewall-newtest-rawtrack.sh $HOME/firewall.sh

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

sleep 1
reboot
