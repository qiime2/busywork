#!/bin/bash

set -e -x

conda update -y conda
conda create -y -p ./test-env
source activate ./test-env

CHANNELS=$(ls -1 -d $(pwd)/* | grep '^.\+-channel$' | sed "s/^/ -c /" | xargs)
conda install -y $CHANNELS -c https://conda.anaconda.org/qiime2 -c biocore -c defaults --override-channels $PKG_NAME
conda install -y pytest
conda install -y nose
echo "backend: Agg" > matplotlibrc

$($TEST_RUNNER_CMD)
