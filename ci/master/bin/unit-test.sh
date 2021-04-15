#!/bin/bash

set -e -v

conda upgrade -n base -q -y conda

conda env create -q -p ./test-env --file environment-files/$RELEASE/test/qiime2-$RELEASE-py38-$PLATFORM-conda.yml

set +v
echo "source activate ./test-env"
source activate ./test-env
echo "running test cmd:"
echo $TEST_CMD
set -v

$TEST_CMD
