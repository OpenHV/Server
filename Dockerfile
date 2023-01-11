FROM debian:11-slim AS base

ARG DEBIAN_FRONTEND=noninteractive

ARG LANG_ARG
ARG TIMEZONE_ARG
ARG MINETEST_VERSION_ARG
ARG IRRLICHT_VERSION_ARG
ARG MINECLONE2_VERSION_ARG

ENV LANG=$LANG_ARG
ENV TIMEZONE=$TIMEZONE_ARG
ENV MINETEST_VERSION=$MINETEST_VERSION_ARG
ENV IRRLICHT_VERSION=$IRRLICHT_VERSION_ARG
ENV MINECLONE2_VERSION=$MINECLONE2_VERSION_ARG

RUN apt-get update && \
  apt-get upgrade -y

RUN apt-get install -y locales && \
  sed -i -e "s/# $LANG.*/$LANG UTF-8/" /etc/locale.gen && \
  dpkg-reconfigure locales && \
  update-locale LANG=$LANG

RUN apt-get install -y tzdata && \ 
  ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime && \
  dpkg-reconfigure tzdata

RUN apt-get install -y \
  ca-certificates \
  lsb-release \
  --no-install-recommends

RUN mkdir /srv/minetest

RUN useradd minetest -r -d /srv/privacyidea -s /bin/bash
RUN chown minetest:minetest /srv/minetest

FROM base AS builder

RUN apt-get install -y \
  git \
  g++ \
  make \
  libc6-dev \
  cmake \
  libpng-dev \
  libjpeg-dev \
  libxi-dev \
  libgl1-mesa-dev \
  libsqlite3-dev \
  libpq-dev \
  libhiredis-dev \
  libogg-dev \
  libvorbis-dev \
  libopenal-dev \ 
  libcurl4-gnutls-dev \
  libfreetype6-dev \
  zlib1g-dev \
  libgmp-dev \
  libjsoncpp-dev \
  libzstd-dev \
  libluajit-5.1-dev \
  --no-install-recommends

USER minetest
WORKDIR /srv/minetest

RUN git clone --depth=1 -b $MINETEST_VERSION https://github.com/minetest/minetest.git application
RUN git clone --depth=1 -b $IRRLICHT_VERSION https://github.com/minetest/irrlicht.git application/lib/irrlichtmt

WORKDIR /srv/minetest/application

RUN cmake . -DRUN_IN_PLACE=TRUE \
  -DBUILD_SERVER=TRUE \
  -DBUILD_CLIENT=FALSE \
  -DIRRLICHT_INCLUDE_DIR=lib/irrlichtmt/include/
  
RUN make -j$(nproc)

FROM base AS final

RUN apt-get install -y \
  wget2 \
  libxi6 \
  libsqlite3-0 \
  libpq5 \
  libhiredis0.14 \
  libcurl3-gnutls \
  zlib1g \
  libgmp10 \
  libjsoncpp24 \
  libzstd1 \
  libluajit-5.1-2 \
  --no-install-recommends
  
RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/*

USER minetest
WORKDIR /srv/minetest

RUN mkdir /srv/minetest/application \
  /srv/minetest/application/games \
  /srv/minetest/data
  
COPY --from=builder \
  /srv/minetest/application/bin /srv/minetest/application/bin
COPY --from=builder \
  /srv/minetest/application/builtin /srv/minetest/application/builtin
  
RUN cd application/games/ && \
  wget2 https://git.minetest.land/MineClone2/MineClone2/archive/$MINECLONE2_VERSION.tar.gz && \
  tar -xvf $MINECLONE2_VERSION.tar.gz && \
  rm $MINECLONE2_VERSION.tar.gz

USER root

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER minetest

EXPOSE 30000/udp 30000/tcp
VOLUME /srv/minetest/data

ENTRYPOINT /entrypoint.sh
