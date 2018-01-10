#!/bin/bash

set -e -v

conda update -q -y conda
conda create -q -y -p ./test-env

PKG_NAMES=$(cat $(ls -1 -d $(pwd)/* | grep '^.\+-channel$' | sed "s/$/\/version-spec.txt/" | xargs) | xargs)
CHANNELS=$(ls -1 -d $(pwd)/* | grep '^.\+-channel$' | sed "s/^/ -c /" | xargs)
conda install -p ./test-env -q -y $CHANNELS \
  -c https://conda.anaconda.org/qiime2 \
  -c https://conda.anaconda.org/conda-forge \
  -c defaults \
  -c https://conda.anaconda.org/bioconda \
  -c https://conda.anaconda.org/biocore \
  --override-channels \
  $PKG_NAMES

set +v
echo "source activate ./test-env"
source activate ./test-env
set -v

conda env export --no-builds --ignore-channels > $ENV_FILE_FP

cd docs-source
pip install -q -r requirements.txt

make clean
make dummy
make preview
if [ "$(uname)" == "Darwin" ]; then
  rm -rf /Users/caporasolab/Desktop/latest_preview/*
  cp -r build/preview/* /Users/caporasolab/Desktop/latest_preview/
fi

make html
if [ "$(uname)" == "Darwin" ]; then
  rm -rf /Users/caporasolab/Desktop/latest_docs/*
  cp -r build/html/* /Users/caporasolab/Desktop/latest_docs/
fi
