#!/bin/bash

set -e -x

conda update -y conda
conda create -y -p ./test-env
source activate ./test-env

conda install -y -c ./builds -c ./qiime2-channel -c qiime2 -c defaults --override-channels q2cli
conda install -y nose
echo "backend: Agg" > matplotlibrc

QIIMETEST= nosetests q2cli
QIIMETEST= source tab-qiime
QIIMETEST= qiime
