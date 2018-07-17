#!/bin/bash

set -e -x

git clone $REPO $REPO-updated

cd ./template-repo/github_templates
./update_templates.sh ../../$REPO-updated
