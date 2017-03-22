#!/bin/bash

set -x -e
conda update -y -c defaults --override-channels conda
conda update -y -c defaults --override-channels conda-build

echo "Hello, Evan"
env
conda info -a
pwd
ls
ls qiime2-channel
ls qiime2-channel/noarch
ls builds

cd q2-types-source
conda build -c ../qiime2-channel -c qiime2 -c biocore -c defaults --override-channels --python 3.5 --output-folder ../builds ci/recipe
