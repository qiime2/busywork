#!/bin/bash

set -e -x

conda update -y conda
conda create -y -p test-env
source activate ./test-env

conda install -y -c ./q2-feature-table-channel -c ./q2-types-channel -c ./q2templates-channel -c ./qiime2-channel -c qiime2 -c biocore -c defaults --override-channels q2-feature-table
conda install -y pytest
echo "backend: Agg" > matplotlibrc

py.test --pyargs q2_feature_table
