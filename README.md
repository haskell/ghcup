[![GitHub release](https://img.shields.io/github/release/haskell/ghcup.svg)](https://github.com/haskell/ghcup/releases)
[![Build Status](https://travis-ci.org/haskell/ghcup.svg?branch=master)](https://travis-ci.org/haskell/ghcup)
[![license](https://img.shields.io/github/license/haskell/ghcup.svg)](COPYING)

[`cabal-install`](https://hackage.haskell.org/package/cabal-install) follows the UNIX philosophy of [do one thing and do it well](https://en.wikipedia.org/wiki/Unix_philosophy#Do_One_Thing_and_Do_It_Well): it builds your project by managing your dependencies. However, `cabal-install` does not download `ghc` if one is needed, although it can demand that [a specific version](https://cabal.readthedocs.io/en/latest/nix-local-build.html#cfg-flag---with-compiler)  of `ghc` is available. Unfortunately, many operating systems do not offer a way to install multiple versions of `ghc`.

`ghcup` makes it easy to install specific versions of `ghc` on GNU/Linux, and can also bootstrap a fresh Haskell developer environment from scratch.

Similar in scope to [rustup](https://github.com/rust-lang-nursery/rustup.rs), [pyenv](https://github.com/pyenv/pyenv) and [jenv](http://www.jenv.be).

*OS X users may prefer [futurice](https://haskell.futurice.com/) and Ubuntu users may prefer [hvr's ppa](https://launchpad.net/~hvr/+archive/ubuntu/ghc).*

## Table of Contents

   * [Installation](#installation)
   * [Usage](#usage)
   * [How](#how)
   * [Contributing](#contributing)
   * [Known problems](#known-problems)

## Installation

Just place the `ghcup` shell script into your `PATH` anywhere.

E.g.:

```sh
mkdir -p ~/.local/bin
curl https://raw.githubusercontent.com/haskell/ghcup/master/ghcup > ~/.local/bin/ghcup
chmod +x ~/.local/bin/ghcup
```

Then adjust your `PATH` in `~/.bashrc` (or similar, depending on your shell) like so, for example:

```sh
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$HOME/.local/bin:$PATH"
```

## Usage

See `ghcup --help`.

## How

Installs a specified GHC version into `~/.ghcup/ghc/<ver>`, and places `ghc-<ver>` symlinks in `~/.ghcup/bin/`.

Optionally, an unversioned `ghc` link can point to a default version of your choice.

This uses precompiled GHC binaries that have been compiled on fedora/debian by [upstream GHC](https://www.haskell.org/ghc/download_ghc_8_6_1.html#binaries).

Alternatively, you can also tell it to compile from source (note that this might fail due to missing requirements).

In addition this script can also install `cabal-install`.

## Contributing

* PR or email
* this script is POSIX shell
* use [shellcheck](https://github.com/koalaman/shellcheck) and `checkbashisms.pl` from [debian devscripts](http://http.debian.net/debian/pool/main/d/devscripts/devscripts_2.18.4.tar.xz)
* whitespaces, no tabs

## Known problems

### Limited distributions supported

Currently only GNU/Linux distributions compatible with the [upstream GHC](https://www.haskell.org/ghc/download_ghc_8_6_1.html#binaries) binaries are supported.

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
