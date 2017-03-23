#!/bin/bash

set -e -x

conda update -y conda
conda create -y -n test-env
source activate test-env

conda env update -f qiime2-source/ci/environment.yaml
conda env update -f q2templates-source/ci/environment.yaml
conda env update -f q2-types-source/ci/environment.yaml
conda install -y pytest
conda install -y -c ./builds -c ./q2-types-channel -c ./q2templates-channel -c ./qiime2-channel --override-channels q2-feature-table
echo "backend: Agg" > matplotlibrc

py.test --pyargs q2_feature_table

source deactivate
conda env remove -y -n test-env
