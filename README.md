# exodia-ISO
Home Edition source ISO

### before building download [eDEX-UI](https://github.com/GitSquared/edex-ui/releases)

#### copy [**`eDEX-UI-Linux-x86_64.AppImage`**](https://github.com/GitSquared/edex-ui/releases) to `src/airootfs/usr/local/bin/`

# building

~~~bash

mkdir {work,out} 

sudo mkarchiso -v -w work -o out src 

~~~
