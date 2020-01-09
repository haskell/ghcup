#!/bin/sh

set -eux

# install shellcheck
wget https://storage.googleapis.com/shellcheck/shellcheck-latest.linux.x86_64.tar.xz
tar -xJf shellcheck-latest.linux.x86_64.tar.xz
mkdir -p "$CI_PROJECT_DIR"/.local/bin/
mv shellcheck-latest/shellcheck "$CI_PROJECT_DIR"/.local/bin/shellcheck


