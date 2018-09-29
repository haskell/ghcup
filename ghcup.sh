#!/bin/sh

# TODO:
#   - self-update

set -e


## global variables ##

VERSION=0.0.1
SCRIPT="$(basename $0)"
VERBOSE=false
FORCE=false
INSTALL_BASE="$HOME/.ghcup"


## print help ##

usage() {
    (>&2 echo "${SCRIPT} [FLAGS] <SUBCOMMAND>

FLAGS:
    -v, --verbose    Enable verbose output
    -h, --help       Prints help information
    -V, --version    Prints version information

SUBCOMMANDS:
    install          Install GHC
    set-ghc          Set current GHC version
    self-update      Update this script in-place
")
    exit 1
}

install_usage() {
    (>&2 echo "${SCRIPT} install [FLAGS] <VERSION>

FLAGS:
    -h, --help       Prints help information
    -f, --force      Overwrite already existing installation

ARGS:
    <VERSION>        E.g. \"8.4.3\" or \"8.6.1\"
")
    exit 1
}

set_ghc_usage() {
    (>&2 echo "${SCRIPT} set-ghc [FLAGS] <VERSION>

FLAGS:
    -h, --help       Prints help information

ARGS:
    <VERSION>        E.g. \"8.4.3\" or \"8.6.1\"
")
    exit 1
}

self_update_usage() {
    (>&2 echo "${SCRIPT} self-update [FLAGS] [TARGET-LOCATION]

FLAGS:
    -h, --help         Prints help information

ARGS:
    [TARGET-LOCATION]  Where to place the updated script (defaults to ~/.local/bin).
                       Must be an absolute path!
")
    exit 1
}


## utilities ##

die() {
    (>&2 echo "$1")
    exit 2
}

echov() {
    if ${VERBOSE} ; then
        echo "$1"
    else
        if [ -n "$2" ] ; then
            echov "$2"
        fi
    fi
}

printf_green() {
    printf "\033[0;32m${1}\033[0m\n"
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

    # TODO: awkward, restructure
    case "${mydistro},${mydistrover},${myarch},${myghcver}" in
    Debian,7,i386,8.2.2)
        printf "${baseurl}/${myghcver}/ghc-${myghcver}-${myarch}-deb${mydistrover}-linux.tar.xz"
        break;;
    *,*,i386,*)
        printf "${baseurl}/${myghcver}/ghc-${myghcver}-${myarch}-deb8-linux.tar.xz"
        break;;
    Debian,*,*,8.2.2)
        printf "${baseurl}/${myghcver}/ghc-${myghcver}-${myarch}-deb8-linux.tar.xz"
        break;;
    Debian,8,*,*)
        printf "${baseurl}/${myghcver}/ghc-${myghcver}-${myarch}-deb8-linux.tar.xz"
        break;;
    Debian,*,*,*)
        printf "${baseurl}/${myghcver}/ghc-${myghcver}-${myarch}-deb9-linux.tar.xz"
        break;;
    Ubuntu,*,*,8.2.2)
        printf "${baseurl}/${myghcver}/ghc-${myghcver}-${myarch}-deb8-linux.tar.xz"
        break;;
    Ubuntu,*,*,*)
        printf "${baseurl}/${myghcver}/ghc-${myghcver}-${myarch}-deb9-linux.tar.xz"
        break;;
    *,*,*,8.2.2)
        printf "${baseurl}/${myghcver}/ghc-${myghcver}-${myarch}-deb8-linux.tar.xz"
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
    downloader_opts="-O"
    old_pwd=${PWD}
    inst_location=${INSTALL_BASE}/${myghcver}

    if [ -e "${inst_location}" ] ; then
        if ${FORCE} ; then
            echo "GHC already installed in ${inst_location}, overwriting!"
        else
            die "GHC already installed in ${inst_location}, use --force to overwrite"
        fi
    fi

    printf_green "Installing GHC for $(get_distro_name) on architecture $(get_arch)"
    (
        cd "$(mktemp -d)"

        echov "Downloading $(get_download_url ${myghcver})"
        ${downloader} ${downloader_opts} "$(get_download_url ${myghcver})"

        tar -xf ghc-*-linux.tar.xz
        cd ghc-${myghcver}

        echov "Installing GHC into ${inst_location}"

        ./configure --prefix="${inst_location}"
        make install
    )

    printf_green "Done installing, set up your current GHC via: ${SCRIPT} set-ghc ${myghcver}"

    unset myghcver downloader downloader_opts old_pwd inst_location
}


## subcommand set-ghc ##

set_ghc() {
    myghcver=$1
    target_location=${INSTALL_BASE}/bin
    inst_location=${INSTALL_BASE}/${myghcver}

    [ -e "${inst_location}" ] || die "GHC ${myghcver} not installed yet, use: ${SCRIPT} install ${myghcver}"
    [ -e "${target_location}" ] || mkdir "${target_location}"

    printf_green "Setting GHC to ${myghcver}"

    if [ -z "${target_location}" ] ; then
        die "We are paranoid, because we are deleting files."
    fi

    find "${target_location}" -type l -delete

    for f in "${inst_location}"/bin/*-${myghcver} ; do
        source_fn=$(basename ${f})
        target_fn=$(echo ${source_fn} | sed "s#-${myghcver}##")
        ln $(echov "-v") -s ../${myghcver}/bin/${source_fn} "${target_location}"/${target_fn}
        unset source_fn target_fn
    done
    ln $(echov "-v") -s runghc "${target_location}"/runhaskell

    printf_green "Done, make sure \"${target_location}\" is in your PATH!"

    unset myghcver target_location inst_location
}


## self-update subcommand ##

self_update() {
    target_location=$1
    source_url="https://raw.githubusercontent.com/hasufell/ghcup/master/ghcup.sh"
    downloader=curl
    downloader_opts="-O"

    [ -e "${target_location}" ] || die "Destination \"${target_location}\" does not exist, cannot update script"

    printf_green "Updating ${SCRIPT}"

    (
        cd "$(mktemp -d)"

        echov "Downloading ${source_url}"
        ${downloader} ${downloader_opts} "${source_url}"
        cp ghcup.sh "${target_location}"/ghcup.sh
        chmod +x "${target_location}"/ghcup.sh
    )

    printf_green "Done, make sure \"${target_location}\" is in your PATH!"

    unset target_location source_url downloader downloader_opts
}


## command line parsing and entry point ##

# sanity checks
if [ -z "$HOME" ] ; then
    die "HOME env not set, cannot operate"
fi

[ $# -lt 1 ] && usage

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
                   -f|--force) FORCE=true
                       shift 1;;
                   *) GHC_VER=$1
                      break;;
               esac
           done
           [ "${GHC_VER}" ] || install_usage
           install_ghc ${GHC_VER}
           break;;
       set-ghc)
           shift 1
           while [ $# -gt 0 ] ; do
               case $1 in
                   -h|--help) set_ghc_usage;;
                   *) GHC_VER=$1
                      break;;
               esac
           done
           [ "${GHC_VER}" ] || set_ghc_usage
           set_ghc ${GHC_VER}
           break;;
       self-update)
           shift 1
           while [ $# -gt 0 ] ; do
               case $1 in
                   -h|--help) self_update_usage;;
                   *) TARGET_LOCATION=$1
                       break;;
               esac
           done
           if [ "${TARGET_LOCATION}" ] ; then
               self_update "${TARGET_LOCATION}"
           else
               self_update "${HOME}/.local/bin"
           fi
           break;;
       *) usage;;
       esac
       break;;
    esac
done

