#!/bin/bash

set -x -e
conda update -y -c defaults --override-channels conda
conda update -y -c defaults --override-channels conda-build

BUILD_DIR=$(ls -d -1 $(pwd)/build-*)
cd qiime2-source
git fetch --tags
conda build -c https://conda.anaconda.org/qiime2 -c defaults --override-channels --output-folder $BUILD_DIR --python 3.5 ci/recipe
