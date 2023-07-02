FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:6.0 as build

RUN apt-get update && \
  apt-get upgrade -y

RUN apt-get install -y \
  ca-certificates \
  lsb-release \
  curl \
  unzip \
  libfreetype6 \
  libopenal1 \
  liblua5.1-0 \
  libsdl2-2.0-0 \
  git \
  build-essential \
  --no-install-recommends

RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir /srv/openhv

RUN useradd openhv -r -d /srv/openhv -s /bin/bash
RUN chown openhv:openhv /srv/openhv

USER openhv
WORKDIR /srv/openhv

RUN git clone --depth=1 \
  -b 20230618 https://github.com/OpenHV/OpenHV.git \
  application

WORKDIR /srv/openhv/application

RUN make \
  RUNTIME=net6 \
  TARGETPLATFORM=unix-generic && \
  make version

RUN find mods/hv/bits/ -type f -delete
RUN rm -rf mods/hv/uibits/* sources/ OpenRA.Mods.HV/

EXPOSE 1234/tcp

FROM mcr.microsoft.com/dotnet/runtime:6.0 AS runtime

COPY --from=build /srv/openhv/application /srv/openhv/application

ENV MOD_SEARCH_PATHS=/srv/openhv/application/mods/
ENTRYPOINT ["dotnet", "/srv/openhv/application/engine/bin/OpenRA.Server.dll", "Engine.EngineDir=..", "Game.Mod=hv"]
