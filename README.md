[![Build Status](https://travis-ci.org/hasufell/ghcup.svg?branch=master)](https://travis-ci.org/hasufell/ghcup)
[![license](https://img.shields.io/github/license/hasufell/ghcup.svg)](COPYING)

# GHC up

Installs a specified GHC version into `~/.ghcup/<ver>`,
and places `ghc-<ver>` etc. symlinks in `~/.ghcup/bin/`.
Additionally allows to manage currently selected ghc
via unversioned symlinks.

This uses precompiled GHC binaries that have been
compiled on fedora/debian by
[upstream GHC](https://www.haskell.org/ghc/download_ghc_8_6_1.html#binaries).

## Why

I don't use stack, but `cabal new-*` and system GHC versions
are often either outdated or cannot be installed in parallel
with proper symlink management.

Inspired by [rustup](https://github.com/rust-lang-nursery/rustup.rs).

## Installation

Just place `ghcup.sh` into your PATH anywhere
(preferably `~/.local/bin`).

## Usage

See `ghcup.sh --help`.

## Contributing

* PR or email
* this script is POSIX shell
* use [shellcheck](https://github.com/koalaman/shellcheck) and `checkbashisms.pl` from [debian devscripts](http://http.debian.net/debian/pool/main/d/devscripts/devscripts_2.18.4.tar.xz)
* whitespaces, no tabs

## TODO

- [ ] FreeBSD support
- [ ] Make fetching tarballs more robust

## Known problems

Since this uses precompiled binaries you may run into
problems with ncurses and missing libtinfo, in case
your distribution doesn't use the legacy way of building
ncurses and has no compatibility symlinks in place.

Ask your distributor on how to solve this.
