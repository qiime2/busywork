#!/bin/bash

set -e -v

cd ./template-repo/labels
for repo in $REPOS; do
	./update-labels.py qiime2/$repo
done
