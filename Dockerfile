FROM mono:6

ARG DEBIAN_FRONTEND=noninteractive

ARG LANG_ARG
ARG TIMEZONE_ARG
ARG OPENHV_VERSION_ARG

ENV LANG=$LANG_ARG
ENV TIMEZONE=$TIMEZONE_ARG
ENV OPENHV_VERSION=$OPENHV_VERSION_ARG

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
  curl \
  unzip \
  python3 \
  libfreetype6 \
  libopenal1 \
  liblua5.1-0 \
  libsdl2-2.0-0 \
  git \
  build-essential \
#  libgeoip1 \
  --no-install-recommends

RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir /srv/openhv

RUN useradd openhv -r -d /srv/openhv -s /bin/bash
RUN chown openhv:openhv /srv/openhv

USER openhv
WORKDIR /srv/openhv

RUN git clone --depth=1 \
  -b $OPENHV_VERSION https://github.com/OpenHV/OpenHV.git \
  application

WORKDIR /srv/openhv/application

RUN make \
  RUNTIME=mono \
  TARGETPLATFORM=unix-generic && \
  make version

EXPOSE 1234/tcp

ENTRYPOINT /srv/openhv/application/launch-dedicated.sh
