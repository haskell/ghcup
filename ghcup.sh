#!/bin/sh

set -e

## global variables ##

VERSION=0.0.1
SCRIPT="$(basename $0)"
VERBOSE=false


## print help ##

usage() {
    (>&2 echo "${SCRIPT} [FLAGS] <SUBCOMMAND>

FLAGS:
    -v, --verbose    Enable verbose output
    -h, --help       Prints help information
    -V, --version    Prints version information

SUBCOMMANDS:
    install          Update Rust toolchains and rustup
")
    exit 1
}

install_usage() {
    (>&2 echo "${SCRIPT} install [FLAGS] <VERSION>

FLAGS:
    -h, --help       Prints help information

ARGS:
    <VERSION>        E.g. \"8.4.3\" or \"8.6.1\"
")
    exit 1
}


## utilities ##

die() {
    (>&2 echo "$1")
    exit 2
}

if_verbose() {
    if ${VERBOSE} ; then
        printf "$1"
    else
        [ -n "$2" ] && printf "$2"
    fi
}

echov() {
    if ${VERBOSE} ; then
        echo "$1"
    fi
}

get_distro_name() {
    if [ -f /etc/os-release ]; then
        # freedesktop.org and systemd
        . /etc/os-release
        printf "$NAME"
    elif type lsb_release >/dev/null 2>&1; then
        # linuxbase.org
        printf "$(lsb_release -si)"
    elif [ -f /etc/lsb-release ]; then
        # For some versions of Debian/Ubuntu without lsb_release command
        . /etc/lsb-release
        printf "$DISTRIB_ID"
    elif [ -f /etc/debian_version ]; then
        # Older Debian/Ubuntu/etc.
        printf "Debian"
    else
        # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
        printf "$(uname -s)"
    fi
}

get_distro_ver() {
    if [ -f /etc/os-release ]; then
        # freedesktop.org and systemd
        . /etc/os-release
        printf "$VERSION_ID"
    elif type lsb_release >/dev/null 2>&1; then
        # linuxbase.org
        printf "$(lsb_release -sr)"
    elif [ -f /etc/lsb-release ]; then
        # For some versions of Debian/Ubuntu without lsb_release command
        . /etc/lsb-release
        printf "$DISTRIB_RELEASE"
    elif [ -f /etc/debian_version ]; then
        # Older Debian/Ubuntu/etc.
        printf "$(cat /etc/debian_version)"
    else
        # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
        printf "$(uname -r)"
    fi
}


get_arch() {
    myarch=$(uname -m)

    case "${myarch}" in
    x86_64)
        printf "x86_64"  # or AMD64 or Intel64 or whatever
        ;;
    i*86)
        printf "i386"  # or IA32 or Intel32 or whatever
        ;;
    *)
        die "Cannot figure out architecture (was: ${myarch})"
        ;;
    esac

    unset myarch
}

get_download_url() {
    myghcver=$1
    myarch=$(get_arch)
    mydistro=$(get_distro_name)
    mydistrover=$(get_distro_ver)
    baseurl="https://downloads.haskell.org/~ghc"

    case "${mydistro},${mydistrover},${myarch},${myghcver}" in
    Debian,7,i386,8.2.2)
        printf "${baseurl}/${myghcver}/ghc-${myghcver}-${myarch}-deb${mydistrover}-linux.tar.xz"
        break;;
    *,*,i386,*)
        printf "${baseurl}/${myghcver}/ghc-${myghcver}-${myarch}-deb8-linux.tar.xz"
        break;;
    Debian,8,*,*)
        printf "${baseurl}/${myghcver}/ghc-${myghcver}-${myarch}-deb8-linux.tar.xz"
        break;;
    Debian,*,*,*)
        printf "${baseurl}/${myghcver}/ghc-${myghcver}-${myarch}-deb9-linux.tar.xz"
        break;;
    Ubuntu,*,*,*)
        printf "${baseurl}/${myghcver}/ghc-${myghcver}-${myarch}-deb9-linux.tar.xz"
        break;;
    *,*,*,*) # this is our best guess
        printf "${baseurl}/${myghcver}/ghc-${myghcver}-${myarch}-fedora27-linux.tar.xz"
        break;;
    esac

    unset myghcver myarch mydistro mydistrover baseurl
}


## subcommand install ##

install_ghc() {
    myghcver=$1
    downloader=curl
    downloader_opts="$(if_verbose "-v") -O"
    old_pwd=${PWD}
    inst_location=$HOME/.ghcup/${myghcver}

    echov "Installing ghc for $(get_distro_name) on architecture $(get_arch)"

    cd "$(mktemp -d)"

    echov "Downloading $(get_download_url ${myghcver})"
    ${downloader} ${downloader_opts} "$(get_download_url ${myghcver})"

    tar $(if_verbose "-v") -xf ghc-*-linux.tar.xz
    cd ghc-${myghcver}

    if [ -z "$HOME" ] ; then
        die "HOME env not set, cannot install GHC"
    else
        echov "Installing GHC into ${inst_location}"
    fi

    ./configure --prefix="${inst_location}"
    make install

    cd "${old_pwd}"

    echo "Done installing, set up your current GHC via: ${SCRIPT} set-ghc ${myghcver}"

    unset myghcver downloader downloader_opts old_pwd inst_location
}



## command line parsing and entry point ##

while [ $# -gt 0 ] ; do
    case $1 in
    -v|--verbose)
        VERBOSE=true
        shift 1;;
    -V|--version)
        printf "${VERSION}"
        exit 0;;
    -h|--help)
        usage;;
    *) case $1 in
       install)
           shift 1
           while [ $# -gt 0 ] ; do
               case $1 in
                   -h|--help) install_usage;;
                   *) GHC_VER=$1
                      break;;
               esac
           done
           [ "${GHC_VER}" ] || install_usage
           install_ghc ${GHC_VER}
           break;;
       *) usage;;
       esac
       break;;
    esac
done

