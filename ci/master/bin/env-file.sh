#!/bin/bash

set -e -v

conda upgrade -n base -q -y conda
conda create -q -y -p ./env-gen -c ./metapackage-channel -c $Q2_CHANNEL -c conda-forge -c bioconda -c defaults qiime2-core

set +v
echo "source activate ./env-gen"
source activate ./env-gen
set -v

conda install -q -y -c conda-forge jq yq

conda env export --no-builds | yq -y "{channels: [\
\"$CHANNEL\", \
\"conda-forge\", \
\"bioconda\", \
\"defaults\"\
], dependencies: .dependencies | map(select(. | startswith(\"qiime2-core\") | not))}" > $ENV_FILE_FP

conda clean --index-cache -y
conda env create -q -p "./$RELEASE" --file $ENV_FILE_FP
