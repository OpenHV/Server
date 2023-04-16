# OpenHV Server

[OpenHV](https://github.com/OpenHV/OpenHV) Docker container based on [Microsoft .NET image](https://hub.docker.com/_/microsoft-dotnet) makes it easier to deploy OpenHV dedicated servers on Linux with graphics and sound files stripped away.

## Usage

```
docker run -it -p 1234:1234 -e "Name=My Server" ghcr.io/openhv/server:latest
```

## Build

Run

```
docker build -t openhv:latest .
```

to compile and

```
docker run -it -p 1234:1234 openhv:latest .
```

to start an instance with TCP 1234 as the default port.

```
docker run -it -p 4711:4711 -e "Name=Docker Test Server" -e "ListenPort=4711" openhv:latest
```

to change server name and TCP network port.

## Configuration

* `-e "Name="` sets the server name.
* `-e "Map="` sets the UID of the initial map.
* `-e "ListenPort"` changes the TCP port.
* `-e "AdvertiseOnline=False"` disables master server registration.
* `-e "Password="` sets the password for a private server.
* `-e "RecordReplays=True"` stores replays server side.
* `-e "RequireAuthentication=True"` enforces every player to register at [forum.openra.net](https://forum.openra.net).
* `-e "ProfileIDBlacklist="` permanently bans players from the server when authentication is required.
* `-e "ProfileIDWhitelist="` only allows these players when authentication is required for a private server.
* `-e "EnableSingleplayer=True"` allows matches against bots with only one player.
* `-e "EnableSyncReports=True"` creates reports on network desync errors.
* `-e "EnableGeoIP=False"` disables the feature where country names are fetched based on network addresses.
* `-e "EnableLintChecks=False"` disables checks for invalid game rules.
* `-e "ShareAnonymizedIPs=False"` removes anonymized network addresses from the lobby completely.
* `-e "FloodLimitJoinCooldown=1000"` sets the cooldown for chat after joining in miliseconds.
