#!/bin/sh

set -e

# install GHCs
./ghcup.sh -v install 8.2.2
./ghcup.sh -v install 8.4.3
./ghcup.sh -v install 8.6.1

# set GHC
./ghcup.sh -v set 8.6.1
./ghcup.sh -v set 8.4.3

# install cabal-install
wget https://www.haskell.org/cabal/release/cabal-install-2.2.0.0/cabal-install-2.2.0.0-x86_64-unknown-linux.tar.gz
tar -xzf cabal-install-2.2.0.0-x86_64-unknown-linux.tar.gz

export PATH="$HOME/.ghcup/bin:$PATH"

# install shellcheck
./cabal new-update
./cabal new-install ShellCheck

# check our script for errors
~/.cabal/bin/shellcheck ghcup.sh
