#!/bin/bash

set -x -e

cd qiime2-source
conda build -y -c https://conda.anaconda.org/qiime2 -c defaults --override-channels --output-folder ../builds --python 3.5 ci/recipe

find ../builds
