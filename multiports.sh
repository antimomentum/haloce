## This script creates Dockerfiles for using up to 12 different halo ports to build containers with.
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

echo "FROM i386/alpine:3.10.2" >> Dockerfile-port2316
echo "RUN apk add --no-cache wine freetype ncurses" >> Dockerfile-port2316
echo "COPY ./halopull /game" >> Dockerfile-port2316
echo "WORKDIR /game" >> Dockerfile-port2316
echo "CMD wineconsole --backend=curses haloceded -path . -port 2316" >> Dockerfile-port2316

echo "FROM i386/alpine:3.10.2" >> Dockerfile-port2318
echo "RUN apk add --no-cache wine freetype ncurses" >> Dockerfile-port2318
echo "COPY ./halopull /game" >> Dockerfile-port2318
echo "WORKDIR /game" >> Dockerfile-port2318
echo "CMD wineconsole --backend=curses haloceded -path . -port 2318" >> Dockerfile-port2318

echo "FROM i386/alpine:3.10.2" >> Dockerfile-port2320
echo "RUN apk add --no-cache wine freetype ncurses" >> Dockerfile-port2320
echo "COPY ./halopull /game" >> Dockerfile-port2320
echo "WORKDIR /game" >> Dockerfile-port2320
echo "CMD wineconsole --backend=curses haloceded -path . -port 2320" >> Dockerfile-port2320

echo "FROM i386/alpine:3.10.2" >> Dockerfile-port2322
echo "RUN apk add --no-cache wine freetype ncurses" >> Dockerfile-port2322
echo "COPY ./halopull /game" >> Dockerfile-port2322
echo "WORKDIR /game" >> Dockerfile-port2322
echo "CMD wineconsole --backend=curses haloceded -path . -port 2322" >> Dockerfile-port2322

echo "FROM i386/alpine:3.10.2" >> Dockerfile-port2324
echo "RUN apk add --no-cache wine freetype ncurses" >> Dockerfile-port2324
echo "COPY ./halopull /game" >> Dockerfile-port2324
echo "WORKDIR /game" >> Dockerfile-port2324
echo "CMD wineconsole --backend=curses haloceded -path . -port 2324" >> Dockerfile-port2324

echo "FROM i386/alpine:3.10.2" >> Dockerfile-port2326
echo "RUN apk add --no-cache wine freetype ncurses" >> Dockerfile-port2326
echo "COPY ./halopull /game" >> Dockerfile-port2326
echo "WORKDIR /game" >> Dockerfile-port2326
echo "CMD wineconsole --backend=curses haloceded -path . -port 2326" >> Dockerfile-port2326
