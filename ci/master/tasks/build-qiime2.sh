#!/bin/bash

set -x -e
conda update -y conda
conda update -y conda-build

cd qiime2-source
conda build -c https://conda.anaconda.org/qiime2 -c defaults --override-channels --output-folder ../builds --python 3.5 ci/recipe

find ../builds
