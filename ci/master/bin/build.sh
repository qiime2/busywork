#!/bin/bash

set -e -v

conda update -q -y -c defaults --override-channels conda
conda install -q -y -c defaults --override-channels conda-build=3.8.1

BUILD_DIR=$(ls -d -1 $(pwd)/build-*)
CHANNELS=$(ls -1 -d $(pwd)/* | grep '^.\+-channel$' | sed "s/^/ -c /" | xargs)
cd ./source
git fetch --tags
conda build -q $CHANNELS \
  -c https://conda.anaconda.org/qiime2 \
  -c https://conda.anaconda.org/conda-forge \
  -c defaults \
  -c https://conda.anaconda.org/bioconda \
  -c https://conda.anaconda.org/biocore \
  --override-channels --python 3.5 --output-folder $BUILD_DIR ci/recipe
