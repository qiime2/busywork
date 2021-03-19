#!/bin/bash

set -e -v

conda install -q -y jinja2 pyyaml networkx

# Set up fly
wget -q -O fly "$CONCOURSE_HOST/api/v1/cli?arch=amd64&platform=linux"
chmod +x ./fly
./fly -t qiime2 login -c $CONCOURSE_HOST -u $CONCOURSE_USER -p $CONCOURSE_PASS

# Template out pipelines, all pipelines should have unique names
for product_path in busywork/ci/*
do
  $product_path/template.py ./pipelines
done

for pipeline in busywork/extra/*
do
  $pipeline/template.py ./pipelines
done

# Deploy pipelines with secrets
for pipeline_path in ./pipelines/*.yaml
do
  pipeline_name=$(basename "$pipeline_path")
  pipeline_name="${pipeline_name%.*}"
  ./fly -t qiime2 set-pipeline -n -p $pipeline_name -c $pipeline_path \
      --var "github_user=$GITHUB_USER" \
      --var "github_pass=$GITHUB_PASS" \
      --var "anaconda_user=$ANACONDA_USER" \
      --var "anaconda_pass=$ANACONDA_PASS" \
      --var "staging_uri=$STAGING_URI" \
      --var "staging_user=$STAGING_USER" \
      --var "staging_pass=$STAGING_PASS"
  ./fly -t qiime2 expose-pipeline -p $pipeline_name
done
