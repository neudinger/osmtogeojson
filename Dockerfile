FROM debian:latest
LABEL MAINTAINER="Barre Kevin"
LABEL version="1.0"
LABEL IMAGE=https://hub.docker.com/u/neudinger/dub/dmd
LABEL SRC=https://github.com/neudinger/osmtogeojson \
      DESCRIPTION="Image with dmd and dub. \
                With one dlang project compatible.\
                On github"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /bin:/sbin:/usr/bin:$PATH

RUN apt update && apt upgrade -y
RUN apt-get install wget -y
RUN wget https://netcologne.dl.sourceforge.net/project/d-apt/files/d-apt.list -O /etc/apt/sources.list.d/d-apt.list
RUN apt-get update --allow-insecure-repositories && apt-get -y --allow-unauthenticated install --reinstall d-apt-keyring && apt-get update
RUN apt-get install dub -y

ENV SRC=/home/src

# release or debug
ARG buildtypes="release"

# ARG is not persistent
ENV buildTypes=${buildtypes}
ENV DFLAGS=--build" "${buildTypes}

RUN addgroup -gid 1000 dub
RUN useradd --uid 1000 --gid dub --shell /bin/bash -d $SRC dlang

USER  dlang

WORKDIR $SRC


# Loock the dub.json for build toolchain and execute
# docker build . -t dub/dmd:latest
# docker build --rm . --build-arg buildtypes=debug -t dub/dmd:latest
# docker run --rm -ti -v $(pwd):/home/src dub/dmd
CMD dub ${DFLAGS}