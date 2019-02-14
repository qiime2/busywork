#!/bin/bash

set -e -v

conda upgrade -n base -q -y -c defaults --override-channels conda
conda install -n base -q -y -c defaults --override-channels conda-build conda-verify

BUILD_DIR=$(ls -d -1 $(pwd)/build-*)
CHANNELS=$(ls -1 -d $(pwd)/* | grep '^.\+-channel$' | sed "s/^/ -c /" | xargs)
cd ./source
git fetch --tags
conda build $CHANNELS \
  -c https://conda.anaconda.org/conda-forge \
  -c https://conda.anaconda.org/bioconda \
  -c defaults \
  --override-channels --output-folder $BUILD_DIR ci/recipe
