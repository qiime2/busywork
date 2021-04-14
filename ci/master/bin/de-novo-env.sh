#!/bin/bash

set -e -v

conda upgrade -n base -q -y conda
conda create -q -y -p ./test-env

for project in $PROJECTS; do
  PKG_NAME=$(cat $(ls -1 -d $(pwd)/$project-* | grep '^.\+-channel$' | sed "s/$/\/version-spec.txt/" | xargs) | xargs)
  CHANNEL=$(ls -1 -d $(pwd)/$project-* | grep '^.\+-channel$' | sed "s/^/ -c /" | xargs)

  conda install -p ./test-env -q -y $CHANNEL \
    -c https://conda.anaconda.org/conda-forge \
    -c https://conda.anaconda.org/bioconda \
    -c defaults \
    --override-channels \
    --strict-channel-priority \
    $PKG_NAME
done

conda env export --no-builds --ignore-channels -p ./test-env > tmp.yml

conda create -q -y -p ./conda-env

set +v
echo "source activate ./conda-env"
source activate ./conda-env
set -v

conda install -q -y -c conda-forge jq yq

yq ". | {channels: [\
\"$TEST_CHANNEL\", \
\"conda-forge\", \
\"bioconda\", \
\"defaults\"\
], dependencies: .dependencies}" tmp.yml --yaml-output \
> $ENV_FILE_FP
