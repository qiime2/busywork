#!/bin/bash

set -e -x

DEST=$(readlink -f $REPO-updated)
git clone $REPO $DEST

cd ./template-repo/copyright
./update_copyright.sh $DEST $BRANCH
