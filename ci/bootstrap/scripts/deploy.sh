#!/bin/bash

# IMPORTANT: Do not set -x to avoid leaking sensitive information below.
set -e

apt-get update
apt-get install wget -y
wget -O fly "$CONCOURSE_HOST/api/v1/cli?arch=amd64&platform=linux" --no-check-certificate
chmod +x ./fly

./fly -t qiime2 login -k -c $CONCOURSE_HOST -u $CONCOURSE_USER -p $CONCOURSE_PASS

for pipeline_path in busywork/ci/pipelines/*.yml
do
  pipeline_name=$(basename "$pipeline_path")
  pipeline_name="${pipeline_name%.*}"
  ./fly -t qiime2 set-pipeline -n -p $pipeline_name -c $pipeline_path --var 'github_user=$GITHUB_USER' --var 'github_pass=$GITHUB_PASS'
  ./fly -t qiime2 expose-pipeline -p $pipeline_name
  ./fly -t qiime2 unpause-pipeline -p $pipeline_name
done
