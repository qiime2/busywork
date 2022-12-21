#!/bin/bash

set -e -v

conda upgrade -n base -q -y conda
conda create -q -y -p ./test-env -c ./metapackage-channel -c $Q2_CHANNEL -c conda-forge -c bioconda -c defaults $(cat ./metapackage-channel/version-spec.txt)
set +v
echo "source activate ./test-env"
source activate ./test-env
set -v

cd docs-source
pip install -q -r requirements.txt

make clean
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
