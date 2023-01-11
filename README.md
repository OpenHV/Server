# OpenHV

OpenHV server Linux builds.

## Description  

This project is motivated by the idea to make easy to deploy OpenHV servers on (GNU/)Linux and provide a base for building in different architectures.

It is focused in providing a minimal build over each release of OpenHV.

## Releases

Each released build is dependent on 2 main dependencies:
* [OpenHV](https://github.com/OpenHV/OpenHV)
* [Mono](https://github.com/mono/mono)

It is focused in order of importance, being the OpenHV game first, as a guide for releasing, or not, a new build based in a new version of each component.

Additionally, for the container image, if some vulnerability is found for some component external to these dependencies, a new build will be providing indicating it in the tag and replacing the `latest` version.
