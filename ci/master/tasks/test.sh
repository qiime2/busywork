#!/bin/bash

set -e -v

set +v
echo "source activate ./conda-env"
source activate ./conda-env
set -v

echo "backend: Agg" > matplotlibrc

$TEST_RUNNER_CMD
