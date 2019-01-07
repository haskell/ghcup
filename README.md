[![GitHub release](https://img.shields.io/github/release/haskell/ghcup.svg)](https://github.com/haskell/ghcup/releases)
[![Build Status](https://travis-ci.org/haskell/ghcup.svg?branch=master)](https://travis-ci.org/haskell/ghcup)
[![license](https://img.shields.io/github/license/haskell/ghcup.svg)](COPYING)

`ghcup` makes it easy to install specific versions of `ghc` on GNU/Linux as well as MacOS (aka Darwin), and can also bootstrap a fresh Haskell developer environment from scratch.
It follows the unix UNIX philosophy of [do one thing and do it well](https://en.wikipedia.org/wiki/Unix_philosophy#Do_One_Thing_and_Do_It_Well).

Similar in scope to [rustup](https://github.com/rust-lang-nursery/rustup.rs), [pyenv](https://github.com/pyenv/pyenv) and [jenv](http://www.jenv.be).

*OS X users may prefer [futurice](https://haskell.futurice.com/) and Ubuntu users may prefer [hvr's ppa](https://launchpad.net/~hvr/+archive/ubuntu/ghc).*

## Table of Contents

   * [Installation](#installation)
   * [Usage](#usage)
   * [Design goals](#design-goals)
   * [How](#how)
   * [Known problems](#known-problems)

## Installation

### Simple bootstrap of ghcup, GHC and cabal-install

```sh
# complete bootstrap
curl https://raw.githubusercontent.com/haskell/ghcup/master/bootstrap-haskell -sSf | sh

# prepare your environment
. "$HOME/.ghcup/env"
echo '. $HOME/.ghcup/env' >> "$HOME/.bashrc" # or similar

# now create a project, such as:
mkdir myproject && cd myproject
cabal init -n --is-executable
cabal v2-run
```

### Manual install

Just place the `ghcup` shell script into your `PATH` anywhere.

E.g.:

```sh
( mkdir -p ~/.ghcup/bin && curl https://raw.githubusercontent.com/haskell/ghcup/master/ghcup > ~/.ghcup/bin/ghcup && chmod +x ~/.ghcup/bin/ghcup) && echo "Success"
```

Then adjust your `PATH` in `~/.bashrc` (or similar, depending on your shell) like so, for example:

```sh
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"
```

## Usage

See `ghcup --help`.

Common use cases are:

```sh
# install the last known "best" GHC version
ghcup install
# install a specific GHC version
ghcup install 8.2.2
# set the currently "active" GHC version
ghcup set 8.4.4
# install cabal-install
ghcup install-cabal
# update cabal-install
cabal new-install cabal-install
```

Generally this is meant to be used with [`cabal-install`](https://hackage.haskell.org/package/cabal-install), which
handles your haskell packages and can demand that [a specific version](https://cabal.readthedocs.io/en/latest/nix-local-build.html#cfg-flag---with-compiler)  of `ghc` is available, which `ghcup` can do.

## Design goals

1. simplicity
2. non-interactive
3. portable
4. do one thing and do it well (UNIX philosophy)

### Non-goals

1. invoking `sudo`, `apt-get` or *any* package manager
2. handling system packages
3. handling cabal projects
4. being a stack alternative

## How

Installs a specified GHC version into `~/.ghcup/ghc/<ver>`, and places `ghc-<ver>` symlinks in `~/.ghcup/bin/`.

Optionally, an unversioned `ghc` link can point to a default version of your choice.

This uses precompiled GHC binaries that have been compiled on fedora/debian by [upstream GHC](https://www.haskell.org/ghc/download_ghc_8_6_1.html#binaries).

Alternatively, you can also tell it to compile from source (note that this might fail due to missing requirements).

In addition this script can also install `cabal-install`.

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

### Compilation

Although this script can compile GHC for you, it's just a very thin
wrapper around the build system. It makes no effort in trying
to figure out whether you have the correct toolchain and
the correct dependencies. Refer to [the official docs](https://ghc.haskell.org/trac/ghc/wiki/Building/Preparation/Linux)
on how to prepare your environment for building GHC.
