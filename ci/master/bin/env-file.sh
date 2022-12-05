#!/bin/bash

set -e -v

conda upgrade -n base -q -y conda
conda install -q -y -n base -c conda-forge jq yq
conda create -q -y -p ./env-gen -c ./metapackage-channel -c $Q2_CHANNEL -c conda-forge -c bioconda -c defaults qiime2-core

set +v
echo "source activate base"
source activate base
set -v

conda env export -p ./env-gen --no-builds | yq -y "{channels: [\
\"$CHANNEL\", \
\"conda-forge\", \
\"bioconda\", \
\"defaults\"\
], dependencies: .dependencies | map(select(. | startswith(\"qiime2-core\") | not))}" > $ENV_FILE_FP

conda clean --index-cache -y
conda env create -q -p "./$RELEASE" --file $ENV_FILE_FP
