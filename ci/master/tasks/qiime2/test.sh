#!/bin/bash

set -e -x
BUILD_DIR=$(find $(pwd) -name build-*)

conda update -y conda
conda create -y -p ./test-env
source activate ./test-env
conda install -y -c $BUILD_DIR -c qiime2 -c defaults --override-channels qiime2
conda install -y nose

QIIMETEST= nosetests qiime2
