`ghcup` makes it easy to install specific versions of `ghc` on GNU/Linux as well as macOS (aka Darwin), and can also bootstrap a fresh Haskell developer environment from scratch.
It follows the unix UNIX philosophy of [do one thing and do it well](https://en.wikipedia.org/wiki/Unix_philosophy#Do_One_Thing_and_Do_It_Well).

Similar in scope to [rustup](https://github.com/rust-lang-nursery/rustup.rs), [pyenv](https://github.com/pyenv/pyenv) and [jenv](http://www.jenv.be).

*Ubuntu users may prefer [hvr's ppa](https://launchpad.net/~hvr/+archive/ubuntu/ghc).*

*This project was started when [CM](https://github.com/capital-match) was switching from stack to [cabal nix-style builds](https://www.haskell.org/cabal/users-guide/nix-local-build-overview.html).*

## Table of Contents

   * [Installation](#installation)
   * [Usage](#usage)
   * [Design goals](#design-goals)
   * [How](#how)
   * [Known users](#known-users)
   * [Known problems](#known-problems)
   * [FAQ](#faq)

## Installation

Choose one of the following installation methods.

### Simple bootstrap of ghcup, GHC and cabal-install

```sh
# complete bootstrap
curl https://gitlab.haskell.org/haskell/ghcup/raw/master/bootstrap-haskell -sSf | sh

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
( mkdir -p ~/.ghcup/bin && curl https://gitlab.haskell.org/haskell/ghcup/raw/master/ghcup > ~/.ghcup/bin/ghcup && chmod +x ~/.ghcup/bin/ghcup) && echo "Success"
```

Then adjust your `PATH` in `~/.bashrc` (or similar, depending on your shell) like so, for example:

```sh
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"
```

Security aware users may want to use the files from the [release page](https://gitlab.haskell.org/haskell/ghcup/tags/)
and verify the gpg signatures.

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

## Known users

* [vabal](https://github.com/Franciman/vabal)

## Known problems

### Limited distributions supported

Currently only GNU/Linux distributions compatible with the [upstream GHC](https://www.haskell.org/ghc/download_ghc_8_6_1.html#binaries) binaries are supported.

### Precompiled binaries

Since this uses precompiled binaries you may run into
several problems.

#### Missing libtinfo (ncurses)

You may run into problems with *ncurses* and **missing libtinfo**, in case
your distribution doesn't use the legacy way of building
ncurses and has no compatibility symlinks in place.

Ask your distributor on how to solve this or
try to compile from source via `ghcup compile <version>`.

#### Libnuma required

This was a [bug](https://ghc.haskell.org/trac/ghc/ticket/15688) in the build system of some GHC versions that lead to
unconditionally enabled libnuma support. To mitigate this you might have to install the libnuma
package of your distribution. See [here](https://gitlab.haskell.org/haskell/ghcup/issues/58) for a discussion.

### Compilation

Although this script can compile GHC for you, it's just a very thin
wrapper around the build system. It makes no effort in trying
to figure out whether you have the correct toolchain and
the correct dependencies. Refer to [the official docs](https://ghc.haskell.org/trac/ghc/wiki/Building/Preparation/Linux)
on how to prepare your environment for building GHC.

## FAQ

1. Why reimplement stack?

ghcup is not a reimplementation of stack. The only common part is automatic installation of GHC, but even that differs in scope and design.

2. Why not contribute to stack and create a library for the common part?

While this might be an interesting idea, ghcup is about simplicity.

3. Why write a >1000k LOC bash script?

ghcup is POSIX sh.

4. Why write a >1000k LOC POSIX sh script?

Mainly because the implementation is fairly straight-forward and the script is highly portable. No need to bootstrap anything or set up yet another CI to build ghcup binaries for all possible arches and distros just to perform a very simple task: identify distro and platform and download a GHC bindist.

5. Why not support windows?

Consider using [Chocolatey](https://chocolatey.org/search?q=ghc) or [ghcups](https://github.com/kakkun61/ghcups).
