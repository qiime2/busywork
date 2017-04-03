#!/bin/bash

set -e -v

if [ `uname` == "Linux" ]
then
  # Fix this someday
  apt-get update -q
  apt-get install wget -q -y --allow-unauthenticated # Really??
fi

set +v
echo "source activate ./conda-env"
source activate ./conda-env
set -v

cd docs-source
pip install -q -r requirements.txt
echo "backend: Agg" > matplotlibrc

make clean
make dummy
make preview
make html
