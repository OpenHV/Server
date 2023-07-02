# OpenHV Server

[OpenHV](https://github.com/OpenHV/OpenHV) Docker container based on [Microsoft .NET image](https://hub.docker.com/_/microsoft-dotnet) makes it easier to deploy OpenHV dedicated servers on Linux with graphics and sound files stripped away.

## Usage

```
docker run -it -p 1234:1234 ghcr.io/openhv/server:latest "Server.Name=My Server"
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
docker run -it -p 4711:4711 openhv:latest "Server.Name=Docker Test Server" "Server.ListenPort=4711"
```

to change server name and TCP network port.

## Configuration

* `Server.Name=` sets the server name.
* `Server.Map=` sets the UID of the initial map.
* `Server.ListenPort` changes the TCP port.
* `Server.AdvertiseOnline=False` disables master server registration.
* `Server.Password=` sets the password for a private server.
* `Server.RecordReplays=True` stores replays server side.
* `Server.RequireAuthentication=True` enforces every player to register at [forum.openra.net](https://forum.openra.net).
* `Server.ProfileIDBlacklist=` permanently bans players from the server when authentication is required.
* `Server.ProfileIDWhitelist=` only allows these players when authentication is required for a private server.
* `Server.EnableSingleplayer=True` allows matches against bots with only one player.
* `Server.EnableSyncReports=True` creates reports on network desync errors.
* `Server.EnableGeoIP=False` disables the feature where country names are fetched based on network addresses.
* `Server.EnableLintChecks=False` disables checks for invalid game rules.
* `Server.ShareAnonymizedIPs=False` removes anonymized network addresses from the lobby completely.
* `Server.FloodLimitJoinCooldown=1000` sets the cooldown for chat after joining in miliseconds.
* `Engine.SupportDir=` sets the folder where [settings](https://github.com/OpenHV/OpenHV/wiki/Settings), logs, maps and replays are saved.
