#!/bin/bash

set -e -x

cd ./template-repo/labels

pip install -r requirements.txt

for repo in $REPOS; do
	./update-labels.py qiime2/$repo
done
