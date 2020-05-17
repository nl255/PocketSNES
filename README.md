# PocketSNES for Miyoo

PocketSNES for [MiyooCFW](https://github.com/TriForceX/MiyooCFW) devices.
Should run in both BittBoy and PocketGo, however it is only tested on
PocketGo v1.

## Bulding

Follow those steps to setup Debian 9 environment with compatible toolchain:
<https://github.com/steward-fu/miyoo>.

Afterwards, run:

    $ make

It will generate a directory `pocketsnes` with the resulting files. You can
them substitute `sd://emus/pocketsnes` contents with the ones in the generated
directory.

You can build this binary using
[PGO](https://en.wikipedia.org/wiki/Profile-guided_optimization).
To do this, first:

    $ make PGO=GENERATE

To generate a binary with instrumentation. Put this in your Miyoo and play a
little, but keep in mind that a PGO binary is very slow (so be patient, it
is worth it). Afterwards, copy  `profile` directory from `sd://emus/pocketsnes`
to the root of the project and run:

    $ make PGO=APPLY

To apply optimizations. A `profile.zip` file is included with each release with
a playthrough of some game, but it may not be updated with `master` branch.
Also, keep in mind that if you want the best performance in your
specific game it may be better to generate your playthrough of it.
