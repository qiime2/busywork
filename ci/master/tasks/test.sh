#!/bin/bash

set -e -v

conda update -q -y conda
conda create -q -y -p ./test-env

set +v
echo "source activate ./test-env"
source activate ./test-env
set -v

CHANNELS=$(ls -1 -d $(pwd)/* | grep '^.\+-channel$' | sed "s/^/ -c /" | xargs)
conda install -q -y $CHANNELS \
  -c https://conda.anaconda.org/qiime2 \
  -c https://conda.anaconda.org/biocore \
  -c defaults \
  -c https://conda.anaconda.org/conda-forge \
  -c https://conda.anaconda.org/bioconda \
  --override-channels $PKG_NAME pytest nose
echo "backend: Agg" > matplotlibrc

$TEST_RUNNER_CMD
