#!/bin/sh

set -e

# Homebrew (plus xcode command line tools)
if [[ ! -x /usr/local/bin/brew ]]; then
    echo "installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Set up the PATH
export PATH=/usr/local/bin:$PATH

# Python 2 (needed for ansible)
if [[ ! -x /usr/local/bin/python ]]; then
    echo "installing python2"
    brew install python --framework --with-brewed-openssl
fi
