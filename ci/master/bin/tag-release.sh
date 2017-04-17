#!/bin/bash

# TODO:
#   - make jobs idempotent

set -e

# Necessary for pushing (configures curl and other networking tools).
rm -f $HOME/.netrc
echo "default login $GITHUB_USER password $GITHUB_PASS" > $HOME/.netrc

# NOTE: Do not echo commands above to avoid leaking secrets.
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
  echo ${repo}

  cp -r ${repo}-source/ tagged-${repo}-source/
  ls tagged-${repo}-source/
  cd tagged-${repo}-source
  cd ${repo}-source

  ls ..
  ls .
  pwd

  observed_release=$(_get_release)

  if [ "$observed_release" != "$expected_release" ]
  then
    echo "Repo $repo has current dev release $observed_release but busywork/current-dev-release declares $expected_release."
    rm -f $HOME/.netrc
    exit 1
  fi

#  current_release="$(grep 'version=' setup.py | sed -E "s/^.*version=['\"](.+)['\"].*$/\1/" | cut -f1,2 -d'.')"
#  next_version=$next_release.0.dev0
#  git branch dev/$current_release
#  git checkout dev/main
#  sed -i "s/version=.*/version='$next_version',/g" setup.py
#  git add setup.py
#  git commit -m "VER: $next_version"
#  git push origin dev/main
#  git push origin dev/$current_release
done

rm -f $HOME/.netrc
