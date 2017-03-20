#!/bin/bash

set -x -e

conda build -c https://conda.anaconda.org/qiime2 -c defaults --override-channels --output-folder builds --python 3.5 qiime2-source/ci/recipe
