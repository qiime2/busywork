#!/bin/bash

set -e -x

conda update -y conda

conda create -y -p ./test-env
source activate ./test-env
conda install -y -c ./builds -c qiime2 -c defaults --override-channels qiime2
conda install -y nose

QIIMETEST= nosetests qiime2
