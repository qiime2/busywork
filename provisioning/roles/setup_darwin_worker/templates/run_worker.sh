#!/bin/sh

/usr/local/bin/concourse worker \
  --work-dir {{ worker_dir }} \
  --tsa-host {{ tsa_host }} \
  --tsa-port {{ tsa_port }} \
  --tsa-public-key {{ base_dir }}/{{ keys_dir }}/tsa_host_key.pub \
  --tsa-worker-private-key {{ base_dir }}/{{ keys_dir }}/worker_key
