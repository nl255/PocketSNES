# PocketSNES for Miyoo

PocketSNES for [MiyooCFW](https://github.com/TriForceX/MiyooCFW) devices.
Should run in both BittBoy and PocketGo, however it is only tested on
PocketGo v1.

## Bulding

Follow those steps to setup Debian 9 environment with compatible toolchain:
<https://github.com/steward-fu/miyoo>.

Afterwards, run:

    $ make -f Makefile.miyoo

It will generate a directory `pocketsnes` with the resulting files. You can
them substitute `sd://emus/pocketsnes` contents with the ones in the generated
directory.
