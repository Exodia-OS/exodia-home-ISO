# exodia-ISO
Home Edition source ISO

> **_NOTE:_** 
> 
> **if you want to build this ISO you have to build it on an Arch/Arch-based distro.
> as many users have tried to build the ISO on non-arch-based distros and run into issues.**

### before building download [eDEX-UI](https://github.com/GitSquared/edex-ui/releases)

#### copy [**`eDEX-UI-Linux-x86_64.AppImage`**](https://github.com/GitSquared/edex-ui/releases) to `src/airootfs/usr/local/bin/`

# building

~~~bash

mkdir {work,out} 

sudo mkarchiso -v -w work -o out src 

~~~

# Contributing

- fork 
- change to dev branch `git checkout dev`
- commit your changes
- create a pull request