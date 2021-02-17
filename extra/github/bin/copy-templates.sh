#!/bin/bash

set -e -x

DEST=$(readlink -f $REPO-updated)
git clone $REPO $DEST

cd ./template-repo/github_templates
./update_templates.sh "${DEST}" "${PACKAGE_NAME}" "${ADDITIONAL_TESTS}" "${BRANCH}"
