#!/bin/bash

set -e -v

if [ `uname` == "Linux" ]
then
  # Fix this someday
  apt-get clean -y
  rm -rf /var/lib/apt/lists/*
  apt-get clean -y
  apt-get update -o Acquire::Check-Valid-Until=false -q -y
  apt-get upgrade -y
  apt-get install unzip wget build-essential -q -y --allow-unauthenticated # Really??
fi

conda update -q -y conda
conda create -q -y -p ./test-env

set +v
echo "source activate ./test-env"
source activate ./test-env
set -v

PKG_NAMES=$(cat $(ls -1 -d $(pwd)/* | grep '^.\+-channel$' | sed "s/$/\/version-spec.txt/" | xargs) | xargs)
CHANNELS=$(ls -1 -d $(pwd)/* | grep '^.\+-channel$' | sed "s/^/ -c /" | xargs)
conda install -q -y $CHANNELS \
  -c https://conda.anaconda.org/qiime2 \
  -c defaults \
  -c https://conda.anaconda.org/conda-forge \
  -c https://conda.anaconda.org/bioconda \
  -c https://conda.anaconda.org/biocore \
  --override-channels \
  $PKG_NAMES

cd docs-source
pip install -q -r requirements.txt

make clean
make dummy
make preview
make html
