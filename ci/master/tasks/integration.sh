#!/bin/bash

set -e -v

# Fix this someday
apt-get update -q
apt-get install wget -q -y --allow-unauthenticated # Really??

conda update -q -y conda
conda create -q -y -p ./test-env
source activate ./test-env

CHANNELS=$(ls -1 -d $(pwd)/* | grep '^.\+-channel$' | sed "s/^/ -c /" | xargs)
conda install -q -y $CHANNELS \
  -c https://conda.anaconda.org/qiime2 \
  -c https://conda.anaconda.org/biocore \
  -c defaults \
  -c https://conda.anaconda.org/conda-forge \
  -c https://conda.anaconda.org/bioconda \
  --override-channels \
  qiime2 \
  q2cli \
  q2templates \
  q2-types \
  q2-feature-table \
  q2-alignment \
  q2-composition \
  q2-dada2 \
  $(: q2-deblur) \
  q2-demux \
  q2-diversity \
  q2-emperor \
  q2-feature-classifier \
  q2-phylogeny \
  q2-quality-filter \
  q2-taxa

conda list

cd docs-source
pip install -q -r requirements.txt
echo "backend: Agg" > matplotlibrc

make clean
make dummy
make preview
make html
