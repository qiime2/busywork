#!/bin/bash

set -x -e

conda update -y -c defaults --override-channels conda
conda update -y -c defaults --override-channels conda-build

cd q2-feature-table-source
git fetch --tags
conda build -c ../q2-types-channel -c ../q2templates-channel -c ../qiime2-channel -c qiime2 -c biocore -c defaults --override-channels --python 3.5 --output-folder ../builds ci/recipe
