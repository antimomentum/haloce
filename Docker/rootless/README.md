## Rootless install for Docker

This is only succesfully tested on Ubuntu 20.04. Does not appear to work on Debian 10 using apt.


The install script is based on the Docker docs for Ubuntu:


https://docs.docker.com/engine/security/rootless/


Note: While this is a rootless install the following privilege is still needed:


kernel.unprivileged_userns_clone=1


Obviously a root or sudo user is still needed for the apt install requirements that rootless Docker will use. However, Docker is only installed for "testuser"


Future plans include making the halo container rootless too. Regardless its permissions should still be limited to the non-sudo "testuser"
