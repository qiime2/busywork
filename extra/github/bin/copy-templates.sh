#!/bin/bash

set -e -x

cp -r $REPO $REPO-updated

cd ./template-repo/github_templates
./update_templates.sh ../../$REPO-updated
