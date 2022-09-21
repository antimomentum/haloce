# wineconsole builder
# This script does three things, it does not run automatically
# requires cat, chmod, and docker

# 1. Creates a local wineconsole container Dockerfile:
cat <<DOCK >Dockerfile
FROM i386/alpine:3.13
RUN apk add --no-cache wine freetype ncurses
FROM scratch
COPY --from=0 / /
DOCK

# 2. Builds from the local Dockerfile
docker build -t wineconsole/lite .

# 3. It creates a start example script. This allows you to customize the docker run AND haloceded.exe command more personally :)

cat <<DRUN >start-example.sh
HPORT=2302 && \\
docker run -it \\
-v \$(pwd)/halopull:/game \\
-w /game \\
-e INTERNAL_PORT=\$HPORT \\
-p \$HPORT:\$HPORT/udp \\
--add-host=s1.master.hosthpc.com:34.197.71.170 \\
--add-host=hosthpc.com:34.197.71.170 \\
wineconsole/lite \\
wineconsole --backend=curses haloceded.exe -path . -port \$HPORT
DRUN

chmod +x start-example.sh
