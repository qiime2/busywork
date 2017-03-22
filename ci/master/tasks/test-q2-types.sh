#!/bin/bash

set -e -x

conda update -y conda
conda create -y -n test-env
source activate test-env

conda env update -f qiime2-source/ci/environment.yaml
conda env update -f q2-types-source/ci/environment.yaml
conda install -y pytest
conda install -y -c ./builds -c ./qiime2-channel --override-channels q2-types
echo "backend: Agg" > matplotlibrc

py.test --pyargs q2_types

source deactivate
conda env remove -y -n test-env
