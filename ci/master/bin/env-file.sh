#!/bin/bash

set -e -v

conda update -q -y conda
conda create -q -y -p ./conda-env

set +v
echo "source activate ./conda-env"
source activate ./conda-env
set -v

conda install -q -y -c conda-forge jq
pip install yq

yq ". | {channels: [\
\"$CHANNEL\", \
\"qiime2\", \
\"conda-forge\", \
\"defaults\", \
\"bioconda\", \
\"biocore\"\
], dependencies: .dependencies}" environment-files/$RELEASE/unprocessed/qiime2-$RELEASE-py35-$PLATFORM-conda.yml --yaml-output \
> $ENV_FILE_FP

conda clean --index-cache
conda env create -q -p "./$RELEASE" --file $ENV_FILE_FP
