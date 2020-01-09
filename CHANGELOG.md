# ChangeLog

## [0.0.8](https://gitlab.haskell.org/haskell/ghcup/-/tags/0.0.8) (2020-01-09)

Release 0.0.8

Distro support:
* add some FreeBSD support
* add linux mint support
* add some redhat support
* add some alpine support

New tool versions:
* GHC: 8.4.1, 8.4.2, 8.6.4, 8.6.5, 8.8.1
* cabal: 3.0.0.0

Commands and API:
* new 'changelog' subcommand added
* 'uprade' subcommand is tweaked':
  - add --inplace flag
  - by default install into BIN_LOCATION
* new subcommand 'print-system-reqs'
* 'compile' subcommand is now hidden from help menu (since it's only for power-users, use 'ghcup -v --help' to show all commands)
* 'list' subcommand is overhauled and 'show' removed
* allow to overwrite the distro detection system (see 'ghcup -v --help')
* allow to overwrite meta download and meta version files via GHCUP_META_DOWNLOAD_URL and GHCUP_META_VERSION_URL

Fixes:
* clean up interrupted download cache properly
* send debug output to stderr only
* fix bug in bootstrap-haskell causing odd errors

Other:
* introduce major version symlinks (e.g. 8.6 -> 8.6.5) and add x.y tags
* use GHCUP_INSTALL_BASE_PREFIX in bootstrap-haskell
* don't reinstall cabal-install from source in bootstrap-haskell
* various usability improvements in bootstrap-haskell
* add bash-completion script
* add manpage support when using man-db


## [0.0.7](https://gitlab.haskell.org/haskell/ghcup/-/tags/0.0.8) (2019-01-07)

Release 0.0.7

This release introduces a new way of installing ghcup (and GHC and cabal in the process)
with the infamous `curl .. | sh` pattern. See #36 for discussion. This
is completely optional.

Features:

- Add a bootstrap-haskell script, fixes #36
- Allow to specify tags for `ghcup install`, `ghcup install-cabal` and `ghcup set`
- `ghcup list` also shows tags
- support installing on macOS aka Darwin
- Improve detection logic for CentOS/Alpine/AIX/FreeBSD
- Introduce a GHCUP_INSTALL_BASE_PREFIX env variable to control where `.ghcup` directory will be created
- Add rudimentary support for Amazon Linux

Bugfixes:

- Create missing haddock -> haddock-ghc symlink
- Emit distro-alias inferred in `debug-info` output
- Tweak exit code for `ghcup install` (If a GHC is already installed, we shouldn't treat it as an error)

Cleanups:

- Simplify mkdir calls
- Documentation improvements
- Error handling improvements

API changes:

- `self-update` was renamed to `upgrade`


## [0.0.6](https://gitlab.haskell.org/haskell/ghcup/-/tags/0.0.8) (2018-10-30)

Release 0.0.6


## [0.0.5](https://gitlab.haskell.org/haskell/ghcup/-/tags/0.0.8) (2018-10-16)

Release 0.0.5


## [0.0.4](https://gitlab.haskell.org/haskell/ghcup/-/tags/0.0.8) (2018-10-09)

Release 0.0.4


## [0.0.3](https://gitlab.haskell.org/haskell/ghcup/-/tags/0.0.8) (2018-09-30)

Release 0.0.3


## [0.0.2](https://gitlab.haskell.org/haskell/ghcup/-/tags/0.0.8) (2018-09-30)

Release 0.0.2


## [0.0.1](https://gitlab.haskell.org/haskell/ghcup/-/tags/0.0.8) (2018-09-29)

Release 0.0.1


