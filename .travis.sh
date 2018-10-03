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

# TODO: exceeds maximum time limit of travis
# compile GHC from source
#./ghcup -v compile 8.4.3 ghc-8.2.2

# install cabal-install
edo ./ghcup -v install-cabal

edo cabal update
edo cabal install cabal-install

# https://github.com/haskell/cabal/issues/5516
edo mkdir -p ~/.cabal/store/ghc-8.2.2/package.db
edo cabal new-update

# install shellcheck
edo cabal new-install ShellCheck

# check our script for errors
edo shellcheck ghcup

# self update
edo mkdir -p "$HOME"/.local/bin
edo ./ghcup self-update

edo ghcup show
