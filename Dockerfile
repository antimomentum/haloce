FROM i386/alpine:3.10.2

RUN apk add --no-cache wine freetype ncurses

COPY ./halopull /game

WORKDIR /game

CMD wineconsole --backend=curses haloceded -path .
