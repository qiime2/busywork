#!/bin/bash

set -e -x

conda update -y conda
conda create -y -p ./test-env
source activate ./test-env

CHANNELS=$(ls -d -1 $(pwd)/*-channel | sed "s/^/ -c /" | xargs) || ''
conda install -y -c $CHANNELS -c qiime2 -c biocore -c defaults --override-channels $PKG_NAME
conda install -y pytest
echo "backend: Agg" > matplotlibrc

$TEST_RUNNER_CMD $PKG_NAME
