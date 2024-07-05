#!/usr/bin/env bash

set -eou pipefail

(
  set -x
  pushd /home/runner/actions-runner
  ./run.sh
)
