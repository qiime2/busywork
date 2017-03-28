#!/bin/bash

set -x -e
conda update -y -c defaults --override-channels conda
conda update -y -c defaults --override-channels conda-build

BUILD_DIR=$(ls -d -1 $(pwd)/build-*)
cd q2templates-source
git fetch --tags
conda build -c defaults --override-channels --output-folder $BUILD_DIR --python 3.5 ci/recipe
