#!/bin/bash

set -e

wget -O fly "$CONCOURSE_HOST/api/v1/cli?arch=amd64&platform=linux"
chmod +x ./fly

./fly -t qiime2 login -k -c $CONCOURSE_HOST -u $CONCOURSE_USER -p $CONCOURSE_PASS

set -x

for pipeline_path in busywork/ci/pipelines/*.yml
do
  pipeline_name=$(basename "$pipeline_path")
  pipeline_name="${pipeline_name%.*}"
  ./fly -t qiime2 set-pipeline -n -p $pipeline_name -c $pipeline_path
  ./fly -t qiime2 expose-pipeline -p $pipeline_name
  ./fly -t qiime2 unpause-pipeline -p $pipeline_name
done
