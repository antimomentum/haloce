apt update && apt-get install -y uidmap dbus-user-session
wait
sleep 1

# The following sysctl kernel setting does not seem to be required, commenting out:
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
reboot
