#!/bin/bash

set -e -x

conda update -y conda
conda create -y -p ./test-env
source activate ./test-env

conda install -y -c ./qiime2-channel -c qiime2 -c biocore -c defaults --override-channels qiime2
# conda install -y -c ./q2cli-channel -c qiime2 -c biocore -c defaults --override-channels q2cli
# conda install -y -c ./q2templates-channel -c qiime2 -c biocore -c defaults --override-channels q2templates
# conda install -y -c ./q2-types-channel -c qiime2 -c biocore -c defaults --override-channels q2-types
# conda install -y -c ./q2-feature-table-channel -c qiime2 -c biocore -c defaults --override-channels q2-feature-table

echo "backend: Agg" > matplotlibrc

conda list

$(exit 1)
