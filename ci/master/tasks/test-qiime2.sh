#!/bin/bash

set -e -x

conda update -y conda

conda create -y -n test-env
source activate test-env
conda install -y nose
conda install -y -c ./builds -c qiime2 -c defaults --override-channels qiime2

QIIMETEST= nosetests qiime2

source deactivate
conda env remove -y -n test-env
