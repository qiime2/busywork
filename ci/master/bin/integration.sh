#!/bin/bash

set -e -v

conda upgrade -n base -q -y conda
conda env create -p ./test-env --file environment-files/$RELEASE/test/qiime2-$RELEASE-py38-$PLATFORM-conda.yml

set +v
echo "source activate ./test-env"
source activate ./test-env
set -v

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
