#!/bin/bash

set -e -v

conda install -q -y -c defaults --override-channels conda=4.5 conda-build conda-verify
conda install -y git pip --file https://raw.githubusercontent.com/bioconda/bioconda-utils/master/bioconda_utils/bioconda_utils-requirements.txt

BUILD_DIR=$(ls -d -1 $(pwd)/build-*)
CHANNELS=$(ls -1 -d $(pwd)/* | grep '^.\+-channel$' | sed "s/^/ -c /" | xargs)
cd ./source
git fetch --tags
conda build $CHANNELS \
  -c https://conda.anaconda.org/conda-forge \
  -c https://conda.anaconda.org/bioconda \
  -c defaults \
  --override-channels --output-folder $BUILD_DIR ci/recipe
