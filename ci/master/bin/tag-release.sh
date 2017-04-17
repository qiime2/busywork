#!/bin/bash

# TODO:
#   - make jobs idempotent

set -e -v

# Fix this someday
apt-get clean -y
rm -rf /var/lib/apt/lists/*
apt-get clean -y
apt-get update -o Acquire::Check-Valid-Until=false -q -y
apt-get upgrade -y
apt-get install -y git

# Convert a space-separated string to an array.
REPOS_ARRAY=(${REPOS_STRING[*]})

# Check if project version is `dev`
_is_dev() {
  python -c 'import versioneer; print("dev" in versioneer.get_version())'
}

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

expected_release="$(trim $(cat busywork/current-dev-release))"

for repo in $REPOS_ARRAY
do
  cd ${repo}-source

  if [ "$(_is_dev)" != "True" ]
  then
    echo "Repo $repo HEAD is not a development version: $(_get_version)"
    exit 1
  fi

  observed_release=$(_get_release)

  if [ "$observed_release" != "$expected_release" ]
  then
    echo "Repo $repo has current dev release $observed_release but busywork/current-dev-release declares $expected_release."
    exit 1
  fi

  cd ..
  git clone ${repo}-source tagged-${repo}-source
  cd tagged-${repo}-source

  version="${observed_release}.0"

  git commit --allow-empty -m "REL: ${version}"

  echo $version > tag
  echo "${repo} ${version}" > annotate
done
