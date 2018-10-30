# Contributing

* PR or email
* this script is POSIX shell
* use [shellcheck](https://github.com/koalaman/shellcheck) and `checkbashisms.pl` from [debian devscripts](http://http.debian.net/debian/pool/main/d/devscripts/devscripts_2.18.4.tar.xz)
* whitespaces, no tabs

## Adding a new distro, updating GHC versions, ...

This script makes use of two files:

1. [.download-urls](https://raw.githubusercontent.com/haskell/ghcup/master/.download-urls),
   which is meta information on what binary tarball to download for the given version, architecture and distribution.
   If you know your distribution XY works with a tarball, add a `<distroname>=<distrover>` key to that line. `<distroname>`
   will be the fallback and after that `unknown`. Lines are unique per tarball url.
2. [.available-versions](https://raw.githubusercontent.com/haskell/ghcup/master/.available-versions),
   which just lists available upstream versions and tags.

## TODO

- [ ] FreeBSD support ([#4](https://github.com/haskell/ghcup/issues/4))
- [x] Make fetching tarballs more robust ([#5](https://github.com/haskell/ghcup/issues/5))
- [x] More code documentation
- [x] Allow to compile from source ([#2](https://github.com/haskell/ghcup/issues/2))
- [x] Allow to install cabal-install as well ([#3](https://github.com/haskell/ghcup/issues/3))
