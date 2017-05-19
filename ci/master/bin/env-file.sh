#!/bin/bash

set -e -v

conda update -q -y conda
conda create -q -y -p ./conda-env

set +v
echo "source activate ./conda-env"
source activate ./conda-env
set -v

conda clean --index-cache

PKG_NAMES=$(cat $(ls -1 -d $(pwd)/* | grep '^.\+-channel$' | sed "s/$/\/version-spec.txt/" | xargs) | xargs)
conda install -q -y \
  -c $STAGING_CHANNEL \
  -c https://conda.anaconda.org/qiime2 \
  -c defaults \
  -c https://conda.anaconda.org/conda-forge \
  -c https://conda.anaconda.org/bioconda \
  -c https://conda.anaconda.org/biocore \
  --override-channels \
  $PKG_NAMES

conda list --explicit --export > $ENV_FILE_PATH
