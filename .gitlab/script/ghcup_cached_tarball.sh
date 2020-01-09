#!/bin/sh

set -eux

. "$( cd "$(dirname "$0")" ; pwd -P )/../ghcup_env"

mkdir -p "$CI_PROJECT_DIR"/.local/bin
cp ./ghcup "$CI_PROJECT_DIR"/.local/bin/ghcup

ghcup -v -c install 8.6.5
test -f "$CI_PROJECT_DIR/.ghcup/cache/ghc-8.6.5-x86_64-deb9-linux.tar.xz"
ghcup -v -c install 8.6.5

