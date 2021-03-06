#!/bin/bash

set -e -v

conda upgrade -n base -q -y conda
conda create -q -y -p ./test-env

PKG_NAMES=$(cat $(ls -1 -d $(pwd)/* | grep '^.\+-channel$' | sed "s/$/\/version-spec.txt/" | xargs) | xargs)
CHANNELS=$(ls -1 -d $(pwd)/* | grep '^.\+-channel$' | sed "s/^/ -c /" | xargs)
conda install -p ./test-env -q -y $CHANNELS \
  -c https://conda.anaconda.org/conda-forge \
  -c https://conda.anaconda.org/bioconda \
  -c defaults \
  --override-channels $PKG_NAMES pytest nose

set +v
echo "source activate ./test-env"
source activate ./test-env
set -v

# debug-env.yml for when this task fails, allows us to recreate the working env.
conda list --explicit --export > debug-env/debug-env.yml

$TEST_RUNNER_CMD
