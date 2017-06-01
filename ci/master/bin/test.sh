#!/bin/bash

set -e -v

conda update -q -y conda
conda create -q -y -p ./test-env

set +v
echo "source activate ./test-env"
source activate ./test-env
set -v

export TMPDIR=$(pwd)
PKG_NAMES=$(cat $(ls -1 -d $(pwd)/* | grep '^.\+-channel$' | sed "s/$/\/version-spec.txt/" | xargs) | xargs)
CHANNELS=$(ls -1 -d $(pwd)/* | grep '^.\+-channel$' | sed "s/^/ -c /" | xargs)
conda install -q -y $CHANNELS \
  -c https://conda.anaconda.org/qiime2 \
  -c defaults \
  -c https://conda.anaconda.org/conda-forge \
  -c https://conda.anaconda.org/bioconda \
  -c https://conda.anaconda.org/biocore \
  --override-channels $PKG_NAMES pytest nose

$TEST_RUNNER_CMD
