#!/bin/bash

set -e -v

# TODO template q2d2 credentials
git config --global user.name q2d2
git config --global user.email "q2d2.noreply@gmail.com"

RELPATH="$RELEASE/$BUILD_TYPE/"

git clone ./environment-files ./updated-environment-files
cd ./updated-environment-files

mkdir -p $RELPATH
cp ../linux-environment-files/* $RELPATH
cp ../darwin-environment-files/* $RELPATH

if [ "$BUILD_TYPE" == "staging" ]
then
  # Latest Staging
  mkdir -p latest/staging
  cp ../linux-environment-files/* latest/staging
  cp ../darwin-environment-files/* latest/staging
fi

git add $RELPATH
git diff-index --quiet HEAD || git commit -m "Updated $RELEASE $BUILD_TYPE environment file."
