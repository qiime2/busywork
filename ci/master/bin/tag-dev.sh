#!/bin/bash

# TODO:
#   - Make jobs idempotent. Hard to solve because concourse-git-resource
#     doesn't support it yet. It ultimately may not be necessary though.

set -e -v

# Configure git
git config --global user.name q2d2
git config --global user.email "q2d2.noreply@gmail.com"

_get_version() {
  python -c 'import versioneer; print(versioneer.get_version())'
}

# Ask for current release in the current working directory.
_get_release() {
  python -c 'import versioneer; version = versioneer.get_version(); release = ".".join(version.split(".")[:2]); print(release)'
}

# Taken from http://stackoverflow.com/a/3352015/3776794
trim() {
  local var="$*"
  # remove leading whitespace characters
  var="${var#"${var%%[![:space:]]*}"}"
  # remove trailing whitespace characters
  var="${var%"${var##*[![:space:]]}"}"
  echo -n "$var"
}

expected_release="$(trim $(grep 'release:' busywork/ci/master/variables.yaml | sed 's/release: //g') | sed 's/["'\'']//g')"

cd ${REPO}-source

observed_release=$(_get_release)

# TODO: revert this when changing back to .dev0 (see below)
# if [ "$observed_release" == "$expected_release" ]
# then
#   echo "Repo $REPO and busywork/ci/master/variables.yaml both declare release $observed_release"
#   exit 1
# fi

cd ..
git clone ${REPO}-source tagged-${REPO}-source
cd tagged-${REPO}-source

# TODO: revert to .dev0
version="${expected_release}.0.dev2"

git commit --allow-empty -m "VER: ${version}"

echo -n "${version}" > tag
echo -n "${REPO} ${version}" > annotate
