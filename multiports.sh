## This script creates Dockerfiles for using up to 6 different halo ports to build containers with.
## You can repeat the process for more ports.
## When using the docker build command use -f Dockerfile-port2304 as an example to use one of the files


echo "FROM i386/alpine:3.10.2" >> Dockerfile-port2304
echo "RUN apk add --no-cache wine freetype ncurses" >> Dockerfile-port2304
echo "COPY ./halopull /game" >> Dockerfile-port2304
echo "WORKDIR /game" >> Dockerfile-port2304
echo "CMD wineconsole --backend=curses haloceded -path . -port 2304" >> Dockerfile-port2304

echo "FROM i386/alpine:3.10.2" >> Dockerfile-port2306
echo "RUN apk add --no-cache wine freetype ncurses" >> Dockerfile-port2306
echo "COPY ./halopull /game" >> Dockerfile-port2306
echo "WORKDIR /game" >> Dockerfile-port2306
echo "CMD wineconsole --backend=curses haloceded -path . -port 2306" >> Dockerfile-port2306

echo "FROM i386/alpine:3.10.2" >> Dockerfile-port2308
echo "RUN apk add --no-cache wine freetype ncurses" >> Dockerfile-port2308
echo "COPY ./halopull /game" >> Dockerfile-port2308
echo "WORKDIR /game" >> Dockerfile-port2308
echo "CMD wineconsole --backend=curses haloceded -path . -port 2308" >> Dockerfile-port2308

echo "FROM i386/alpine:3.10.2" >> Dockerfile-port2310
echo "RUN apk add --no-cache wine freetype ncurses" >> Dockerfile-port2310
echo "COPY ./halopull /game" >> Dockerfile-port2310
echo "WORKDIR /game" >> Dockerfile-port2310
echo "CMD wineconsole --backend=curses haloceded -path . -port 2310" >> Dockerfile-port2310

echo "FROM i386/alpine:3.10.2" >> Dockerfile-port2312
echo "RUN apk add --no-cache wine freetype ncurses" >> Dockerfile-port2312
echo "COPY ./halopull /game" >> Dockerfile-port2312
echo "WORKDIR /game" >> Dockerfile-port2312
echo "CMD wineconsole --backend=curses haloceded -path . -port 2312" >> Dockerfile-port2312

echo "FROM i386/alpine:3.10.2" >> Dockerfile-port2314
echo "RUN apk add --no-cache wine freetype ncurses" >> Dockerfile-port2314
echo "COPY ./halopull /game" >> Dockerfile-port2314
echo "WORKDIR /game" >> Dockerfile-port2314
echo "CMD wineconsole --backend=curses haloceded -path . -port 2314" >> Dockerfile-port2314
