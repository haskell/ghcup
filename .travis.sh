#!/bin/sh

set -e

# install GHCs
./ghcup -v install 8.2.2
./ghcup -v install 8.4.3
./ghcup -v install 8.6.1

# set GHC
./ghcup -v set 8.6.1
./ghcup -v set 8.4.3

# rm GHC
./ghcup -v rm 8.6.1
./ghcup -v rm 8.4.3

# set GHC
./ghcup -v set 8.2.2

# install cabal-install
wget https://www.haskell.org/cabal/release/cabal-install-2.2.0.0/cabal-install-2.2.0.0-x86_64-unknown-linux.tar.gz
tar -xzf cabal-install-2.2.0.0-x86_64-unknown-linux.tar.gz

export PATH="$HOME/.ghcup/bin:$PATH"

# install shellcheck
./cabal update
./cabal install ShellCheck

# check our script for errors
~/.cabal/bin/shellcheck ghcup.sh
