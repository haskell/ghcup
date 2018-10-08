#!/bin/sh

edo()
{
	printf "\\033[0;34m%s\\033[0m\\n" "$*" 1>&2
    "$@" || exit 2
}

# install GHCs
edo ./ghcup -v install 8.2.2
edo ./ghcup -v install 8.4.3
edo ./ghcup -v install 8.6.1

# set GHC
edo ./ghcup -v set 8.6.1
edo ./ghcup -v set 8.4.3

# rm G HC
edo ./ghcup -v rm 8.6.1
edo ./ghcup -v rm 8.4.3

# set GHC
edo ./ghcup -v set 8.2.2

export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$HOME/.local/bin:$PATH"
edo mkdir -p "$HOME"/.local/bin

edo cp ./ghcup "$HOME"/.local/bin/ghcup

# TODO: exceeds maximum time limit of travis
# compile GHC from source
#./ghcup -v compile 8.4.3 ghc-8.2.2

# install cabal-install
edo ghcup -v install-cabal

# install shellcheck
edo wget https://storage.googleapis.com/shellcheck/shellcheck-latest.linux.x86_64.tar.xz
edo tar -xJf shellcheck-latest.linux.x86_64.tar.xz
edo mv shellcheck-latest/shellcheck "$HOME"/.local/bin/shellcheck

# check our script for errors
edo shellcheck ghcup

# self update
edo ghcup self-update

edo ghcup show

edo ghc --version
