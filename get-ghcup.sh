#!/bin/sh -e
#
# ghcup installation script.
#
# This installs 'ghcup', 'cabal', and 'ghc'.

    ##########################
    #--[ Global Variables ]--#
    ##########################

# @VARIABLE: GHCUP
# @DESCRIPTION:
# The name of the ghcup executable.
GHCUP="ghcup"

# @VARIABLE: INSTALL_BASE
# @DESCRIPTION:
# The main install directory where all ghcup stuff happens.
INSTALL_BASE="$HOME/.ghcup"

# @VARIABLE: BIN_LOCATION
# @DESCRIPTION:
# The location where ghcup will create symlinks for GHC binaries.
# This is expected to be a subdirectory of INSTALL_BASE.
BIN_LOCATION="$INSTALL_BASE/bin"

# @VARIABLE: GHCUP
# @DESCRIPTION:
# The name of the ghcup executable.
GHCUP_EXE="$BIN_LOCATION/$GHCUP"


    ##########################
    #--[ Helper Functions ]--#
    ##########################


# @FUNCTION: command_exists
# @USAGE: <command>
# @DESCRIPTION:
# Check if a command exists (no arguments).
# @RETURNS: 0 if the command exists, non-zero otherwise
command_exists() {
    [ -z "$1" ] && die "Internal error: no argument given to command_exists"

    command -V "$1" >/dev/null 2>&1
    return $?
}

# @FUNCTION: die
# @USAGE: [msg]
# @DESCRIPTION:
# Exits the shell script with status code 2
# and prints the given message in red to STDERR, if any.
die() {
    (>&2 printf "\\033[0;31m%s\\033[0m\\n" "$1")
    exit 2
}

# @FUNCTION: has_ghcup
# @USAGE: <no args>
# @DESCRIPTION:
# Checks to see if the ghcup executable exists.
has_ghcup() {
  command_exists "${GHCUP_EXE}"
}

# @FUNCTION: on_path
# @USAGE: <path-piece>
# @DESCRIPTION:
# Checks to see if the <path-piece> is in the PATH environment variable.
on_path() {
  echo ":$PATH:" | grep -q :"$1":
}

# @FUNCTION: on_path
# @USAGE: <no args>
# @DESCRIPTION:
# Checks to see if the ghcup bin directory is in the PATH environment variable.
ghcup_on_path() {
  on_path "${BIN_LOCATION}"
}


    ############################
    #--[ Installation Logic ]--#
    ############################


# @FUNCTION: preamble
# @USAGE: <no args>
# @DESCRIPTION:
# Prints a welcome message to the terminal and informs the user what the script
# is going to do. They can cancel by pressing ctrl-c.
preamble () {
  echo
  echo "Welcome to Haskell!"
  echo
  echo "This will download and install the Glasgow Haskell Compiler (GHC) for "
  echo "the Haskell programming language, and the Cabal build tool."
  echo
  echo "It will add the 'cabal', 'ghc', and 'ghcup' executables to bin directory "
  echo "located at: "
  echo
  echo "  ${BIN_LOCATION}"
  echo
  echo "This path will then be added to your PATH environment variable by "
  echo "modifying the bashrc file at:"
  echo
  echo "  $HOME/.bashrc"
  echo
  echo "To proceed with the installation press enter, to cancel press ctrl-c"
  echo

  # Wait for user input to continue.
  read
}

# @FUNCTION: check_for_ghcup_installation
# @USAGE: <no args>
# @DESCRIPTION:
# Check if the 'ghcup' command already exists, if so provide instructions
# for upgrading.
check_for_ghcup_installation() {
  if has_ghcup; then
    echo
    echo "Welcome to Haskell!"
    echo
    echo  "We noticed that you already have 'ghcup' installed:"
    echo
    echo "  Location: ${GHCUP_EXE}"
    echo "  Version: `${GHCUP_EXE} --version`"
    echo
    echo "To upgrade to the latest version of ghcup run:"
    echo
    echo "  ghcup self-update"
    echo
    echo "To upgrade to the newest ghc and cabal versions run:"
    echo
    echo "  ghcup install && ghcup install-cabal"
    echo

    if ! ghcup_on_path; then
      echo
      echo "We noticed you don't have ghcup's bin directory ($HOME/.ghcup/bin)"
      echo "in your PATH environment variable. To configure your current shell: "
      echo
      echo "  source $HOME/.ghcup/env"
      echo
    fi

    exit 0
  fi
}

# @FUNCTION: source_ghcup_env_from_bashrc
# @USAGE: <no args>
# @DESCRIPTION:
# Check to see if the ghcup env file is sourced from .bashrc, if not add it.
source_ghcup_env_from_bashrc () {
  # Check to see if the .bashrc file sources the ghcup environement file, if
  # not then add it.
  if [ -z "`cat "$HOME/.bashrc" | grep 'source "$HOME/.ghcup/env"'`" ]; then
    echo "Updating $HOME/.bashrc to source ghcup environment file..."
    echo 'source "$HOME/.ghcup/env"' >> $HOME/.bashrc
   fi
}

# @FUNCTION: install_ghcup
# @USAGE: <no args>
# @DESCRIPTION:
# Install ghcup, ghc, and cabal.
install_ghcup () {
  preamble
  
  echo "Creating ghcup directories..."
  mkdir -p "${BIN_LOCATION}"
  echo "  Done. Created ${BIN_LOCATION}"
  echo
  echo "Downloading ghcup..."
  curl https://raw.githubusercontent.com/haskell/ghcup/master/ghcup > ${GHCUP_EXE} && chmod +x ${GHCUP_EXE}
  echo "  Done. Installed at ${GHCUP_EXE}"
  echo

  # Install ghc and cabal.
  ${GHCUP_EXE} install

  echo
  echo "Installing the cabal build tool..."
  ${GHCUP_EXE} install-cabal

  # Create env file.
  echo 'export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"' > $INSTALL_BASE/env

  echo
  echo "The Haskell toolchain is now installed!"
  echo
}

# @FUNCTION: check_for_ghcup_bin_on_path
# @USAGE: <no args>
# @DESCRIPTION:
# Check to see if the ghcup bin directory is on the PATH, if no provide
# instructions for how to add it.
check_for_ghcup_bin_on_path() {
  if ! ghcup_on_path; then
    echo
    echo "To get started you need ghcup's bin directory ($HOME/.ghcup/bin)"
    echo "in your PATH environment variable. To configure your current shell: "
    echo
    echo "  source $HOME/.ghcup/env"
    echo
  fi
}


# --------------------------------------------------
#  Main
# --------------------------------------------------

main () {
  check_for_ghcup_installation
  install_ghcup
  source_ghcup_env_from_bashrc
  check_for_ghcup_bin_on_path
}

main
