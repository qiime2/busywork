#!/bin/bash

set -e -x
ls qiime2-channel
conda update -y conda
conda create -y -p ./test-env
source activate ./test-env
conda install -y -c ./qiime2-channel -c qiime2 -c defaults --override-channels qiime2
conda install -y nose

QIIMETEST= nosetests qiime2
