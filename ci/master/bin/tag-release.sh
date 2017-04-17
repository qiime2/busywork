#!/bin/bash

# TODO:
#   - make jobs idempotent

set -e
set -v

# Fix this someday
apt-get clean -y
rm -rf /var/lib/apt/lists/*
apt-get clean -y
apt-get update -o Acquire::Check-Valid-Until=false -q -y
apt-get upgrade -y
apt-get install -y git

# TODO template q2d2 credentials
git config --global user.name q2d2
git config --global user.email "q2d2.noreply@gmail.com"

# Convert a space-separated string to an array.
REPOS_ARRAY=(${REPOS_STRING[*]})

# Ask for current release in the current working directory.
_get_release() {
  # TODO:
  # Do we need to check that it is dev, first?
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

  observed_release=$(_get_release)

  if [ "$observed_release" != "$expected_release" ]
  then
    echo "Repo $repo has current dev release $observed_release but busywork/current-dev-release declares $expected_release."
    exit 1
  fi

  cd ../${repo}-gh-release
  rm -f tag name
  echo "$observed_release.0" > tag
  echo "QIIME 2 ${observed_release}" > name
done
