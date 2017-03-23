#!/bin/bash

set -x -e
conda update -y -c defaults --override-channels conda
conda update -y -c defaults --override-channels conda-build

cd q2templates-source
git fetch --tags
conda build -c defaults --override-channels --output-folder ../builds --python 3.5 ci/recipe
