#!/bin/bash

set -e
# Fix this someday
apt-get update
apt-get install gnupg -y
apt-get install wget -y
wget -O fly "$CONCOURSE_HOST/api/v1/cli?arch=amd64&platform=linux" --no-check-certificate
chmod +x ./fly

./fly -t qiime2 login -k -c $CONCOURSE_HOST -u $CONCOURSE_USER -p $CONCOURSE_PASS

set -x

for product_path in busywork/ci/*
do
  product_name=$(basename "$product_path")
  for pipeline_path in "$product_path"/pipelines/*.yaml
  do
    pipeline_name=$(basename "$pipeline_path")
    pipeline_name="${pipeline_name%.*}"
    pipeline_name="$product_name-$pipeline_name"
    ./fly -t qiime2 set-pipeline -n -p $pipeline_name -c $pipeline_path --var "github_user=$GITHUB_USER" --var "github_pass=$GITHUB_PASS" --var "ftp_host=$FTP_HOST" --var "ftp_channel_root=$FTP_CHANNEL_ROOT" --var "ftp_user=$FTP_USER" --var "ftp_pass=$FTP_PASS"
    ./fly -t qiime2 expose-pipeline -p $pipeline_name
    ./fly -t qiime2 unpause-pipeline -p $pipeline_name
  done
done
