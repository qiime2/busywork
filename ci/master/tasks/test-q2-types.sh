#!/bin/bash

set -e -x

conda update -y conda
conda create -y -n test-env
source activate test-env

conda install -y pytest
conda install -y -c ./builds -c ./qiime2-channel -c qiime2 -c biocore -c defaults --override-channels q2-types
echo "backend: Agg" > matplotlibrc

py.test --pyargs q2_types

source deactivate
conda env remove -y -n test-env
