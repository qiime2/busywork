#!/bin/bash

set -x -e

conda update -y -c defaults --override-channels conda
conda update -y -c defaults --override-channels conda-build

BUILD_DIR=$(ls -d -1 $(pwd)/build-*)
cd q2-types-source
git fetch --tags
conda build -c ../qiime2-channel -c qiime2 -c biocore -c defaults --override-channels --python 3.5 --output-folder $BUILD_DIR ci/recipe
