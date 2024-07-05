#!/usr/bin/env bash

set -eou pipefail

(
  set -x
  pushd /home/runner/actions-runner

  ./config.sh \
    --unattended \
    --replace \
    --ephemeral \
    --name "${RUNNER_NAME}" \
    --work "_work" \
    --labels "${RUNNER_LABEL}" \
    --url "${RUNNER_REPO_URL}" \
    --token "${RUNNER_TOKEN}"

  ./run.sh
)
