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

export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"

# TODO: exceeds maximum time limit of travis
# compile GHC from source
#./ghcup -v compile 8.4.3 ghc-8.2.2

# install cabal-install
./ghcup -v install-cabal

cabal new-update

# https://github.com/haskell/cabal/issues/5516
mkdir -p ~/.cabal/store/ghc-8.2.2/package.db

# this shouldn't be necessary, file bug upstream
cabal new-install --symlink-bindir="$HOME"/.ghcup/bin cabal-install
mv -f "$HOME"/.ghcup/bin/cabal "$HOME"/.cabal/bin/cabal

# install shellcheck
cabal new-update
cabal new-install ShellCheck

# check our script for errors
shellcheck ghcup

# self update
ghcup self-update
