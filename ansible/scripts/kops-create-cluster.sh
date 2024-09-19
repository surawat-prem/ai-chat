#!bin/bash
export KOPS_STATE_STORE={{ S3_NAME }}
export AWS_ACCESS_KEY_ID={{ AWS_ACCESS_KEY_ID }}
export AWS_SECRET_ACCESS_KEY={{ AWS_SECRET_ACCESS_KEY }}
kops crete cluster {{ NAME }} \
  --node-count {{ NODE_COUNT }} \
  --zones {{ ZONES }} \
  --node-size {{ NODE_SIZE }} \
  --control-plane-size {{ CONTROL_PLANE_SIZE }} \
  --control-plane-zones {{ ZONES }} \
  --networking cilium \
  --yes \
  --dry-run \
  -oyaml > test-kops.yaml