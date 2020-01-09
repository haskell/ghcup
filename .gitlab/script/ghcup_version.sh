#!/bin/sh

set -eux

. "$( cd "$(dirname "$0")" ; pwd -P )/../ghcup_env"

mkdir -p "$CI_PROJECT_DIR"/.local/bin

cp ./ghcup "$CI_PROJECT_DIR"/.local/bin/ghcup

ghcup --version

ghcup -v install ${GHC_VERSION}
ghcup -v set ${GHC_VERSION}
ghcup -v install-cabal

cabal --version

ghcup -v debug-info

ghcup -v list
ghcup -v list -t ghc
ghcup -v list -t cabal-install

ghc --version
ghci --version
ghc-$(ghc --numeric-version) --version
ghci-$(ghc --numeric-version) --version

ghcup -v upgrade

ghcup -v rm -f ${GHC_VERSION}

