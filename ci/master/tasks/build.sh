#!/bin/bash

set -x -e

conda update -y -c defaults --override-channels conda
conda update -y -c defaults --override-channels conda-build

BUILD_DIR=$(ls -d -1 $(pwd)/build-*)
CHANNELS=$(ls -d -1 $(pwd)/*-channel | sed "s/^/ -c /" | xargs) || ''
cd ./source
git fetch --tags
conda build $CHANNELS -c https://conda.anaconda.org/qiime2 -c biocore -c defaults --override-channels --python 3.5 --output-folder $BUILD_DIR ci/recipe
