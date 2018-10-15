[![GitHub release](https://img.shields.io/github/release/hasufell/ghcup.svg)](https://github.com/hasufell/ghcup/releases)
[![Build Status](https://travis-ci.org/hasufell/ghcup.svg?branch=master)](https://travis-ci.org/hasufell/ghcup)
[![license](https://img.shields.io/github/license/hasufell/ghcup.svg)](COPYING)

# GHC up

Installs a specified GHC version into `~/.ghcup/ghc/<ver>`,
and places `ghc-<ver>` etc. symlinks in `~/.ghcup/bin/`.
Additionally allows to manage currently selected ghc
via unversioned symlinks.

This uses precompiled GHC binaries that have been
compiled on fedora/debian by
[upstream GHC](https://www.haskell.org/ghc/download_ghc_8_6_1.html#binaries).

Alternatively, you can also tell it to compile from source (note that this might
fail due to missing requirements).

In addition this script can also install `cabal-install`.

## Table of Contents

   * [Why](#why)
   * [Installation](#installation)
   * [Usage](#usage)
   * [Contributing](#contributing)
   * [TODO](#todo)
   * [Known problems](#known-problems)

## Why

I don't use stack, but `cabal new-*` and system GHC versions
are often either outdated or cannot be installed in parallel
with proper symlink management.

Inspired by [rustup](https://github.com/rust-lang-nursery/rustup.rs).

## Installation

Just place the `ghcup` shell script into your `PATH` anywhere.

E.g.:

```sh
mkdir -p ~/.local/bin
curl https://raw.githubusercontent.com/hasufell/ghcup/master/ghcup > ~/.local/bin/ghcup
chmod +x ~/.local/bin/ghcup
```

Then adjust your `PATH` in `~/.bashrc` (or similar, depending on your shell) like so, for example:

```sh
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$HOME/.local/bin:$PATH"
```


## Usage

See `ghcup --help`.

## Contributing

* PR or email
* this script is POSIX shell
* use [shellcheck](https://github.com/koalaman/shellcheck) and `checkbashisms.pl` from [debian devscripts](http://http.debian.net/debian/pool/main/d/devscripts/devscripts_2.18.4.tar.xz)
* whitespaces, no tabs

## TODO

- [ ] FreeBSD support ([#4](https://github.com/hasufell/ghcup/issues/4))
- [ ] Make fetching tarballs more robust ([#5](https://github.com/hasufell/ghcup/issues/5))
- [x] More code documentation
- [x] Allow to compile from source ([#2](https://github.com/hasufell/ghcup/issues/2))
- [x] Allow to install cabal-install as well ([#3](https://github.com/hasufell/ghcup/issues/3))

## Known problems

### Precompiled binaries

Since this uses precompiled binaries you may run into
problems with *ncurses* and **missing libtinfo**, in case
your distribution doesn't use the legacy way of building
ncurses and has no compatibility symlinks in place.

Ask your distributor on how to solve this or
try to compile from source via `ghcup compile <version>`.

### Unreliable download location

There is no single reliable URL where to download future
GHC binary releases from, since the tarball names contain
the distro name and version they were built on. As such,
we cannot foresee what will be the next tarball name.

In such a case, consider to update this script via
`ghcup self-update`.

### Compilation

Although this script can compile GHC for you, it's just a very thin
wrapper around the build system. It makes no effort in trying
to figure out whether you have the correct toolchain and
the correct dependencies. Refer to [the official docs](https://ghc.haskell.org/trac/ghc/wiki/Building/Preparation/Linux)
on how to prepare your environment for building GHC.
