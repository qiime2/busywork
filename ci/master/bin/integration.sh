#!/bin/bash

set -e -v

conda upgrade -n base -q -y conda
conda create -q -y -p ./test-env

PKG_NAMES=$(cat $(ls -1 -d $(pwd)/* | grep '^.\+-channel$' | sed "s/$/\/version-spec.txt/" | xargs) | xargs)
CHANNELS=$(ls -1 -d $(pwd)/* | grep '^.\+-channel$' | sed "s/^/ -c /" | xargs)
conda config --show
conda --version
conda install -p ./test-env -q -y $CHANNELS \
  -c https://conda.anaconda.org/conda-forge \
  -c https://conda.anaconda.org/bioconda \
  -c defaults \
  --override-channels \
  --strict-channel-priority \
  $PKG_NAMES

set +v
echo "source activate ./test-env"
source activate ./test-env
set -v

# debug-env.yml for when this task fails, allows us to recreate the working env.
conda list --explicit --export > debug-env/debug-env.yml
conda env export --no-builds --ignore-channels -p ./test-env > $ENV_FILE_FP

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
