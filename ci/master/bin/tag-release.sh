#!/bin/bash

# TODO:
#   - make jobs idempotent

set -e

rm -f $HOME/.netrc
echo "default login $GITHUB_USER password $GITHUB_PASS" > $HOME/.netrc

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

REPOS_ARRAY=(${REPOS_STRING[*]})

echo $REPOS_ARRAY
echo ${REPOS_ARRAY[*]}
echo ${REPOS_ARRAY[0]}
echo ${REPOS_ARRAY[1]}
echo ${REPOS_ARRAY[2]}

exit 1

#git clone qiime2 qiime2-feature-freeze
#cd qiime2-feature-freeze
#git remote remove origin
#git remote add origin $(cd ../qiime2 && git remote get-url --push origin)
#
#next_release="$(cat ../busywork/next-release)"
#current_release="$(grep 'version=' setup.py | sed -E "s/^.*version=['\"](.+)['\"].*$/\1/" | cut -f1,2 -d'.')"
#next_version=$next_release.0.dev0
#git branch dev/$current_release
#git checkout dev/main
#sed -i "s/version=.*/version='$next_version',/g" setup.py
#git add setup.py
#git commit -m "VER: $next_version"
#git push origin dev/main
#git push origin dev/$current_release
