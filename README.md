# Minetest MineClone2

Minetest MineClone2 server Linux builds.

## Description  

This project is motivated by the lack of support from Minetest to provide (GNU/)Linux builds for both Minetest and Minetestserver.

It is focused in providing a minimal build over stable versions of Minetestserver with MineClone2 game.

## Releases

Each released build is dependent on the 3 main dependencies of this project:  
* [Minetest](https://github.com/minetest/minetest)
* [IrrLicht](https://github.com/minetest/irrlicht/) (Minetest variant)
* [MineClone2](https://git.minetest.land/mineclone2/mineclone2)

It is focused in order of importance, being the MineClone2 game first, as a guide for releasing, or not, a new build based in a new version of each component.

Additionally, for the container image, if some vulnerability is found for some component external to these dependencies, a new build will be providing indicating it in the tag and replacing the `latest` version.
