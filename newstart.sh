# This newstart.sh file should only be run once if ever. Here's what it does:

# 1. It installs unzip and builds a fresh wineconsole container:

apt install unzip -y
wait
cat <<DOCK >Dockerfile
FROM i386/alpine:3.13
RUN apk add --no-cache wine freetype ncurses
DOCK

docker build -t wineconsole/lite .
wait

# 2. It pulls working halo files and saves them into a directory named "halopull"

wget -O halopull.zip https://github.com/antimomentum/halopull/archive/refs/heads/master.zip && \\
unzip halopull.zip && mv halopull-master halopull && rm halopull.zip


# 3. It creates a start example script. This allows you to customize the docker run AND haloceded.exe command more personally :)

cat <<DRUN >start-example.sh
HPORT=2310 && \\
docker run -it \\
-v \$(pwd)/halopull:/game \\
-w /game \\
-e INTERNAL_PORT=\$HPORT \\
-p \$HPORT:\$HPORT/udp \\
wineconsole/lite \\
wineconsole --backend=curses haloceded.exe -path . -port \$HPORT
DRUN

chmod +x start-example.sh

# 4. Finally it attempts the docker run command and removes itself (newstart.sh) since it should only be run once as mentioned.
# start-example can be run any number of times

./start-example.sh && rm newstart.sh
