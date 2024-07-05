#!/usr/bin/env bash

# q: is it somewhat dumb to run this as a shell script?
# a: yes, correct model should probably be a systemd service, but hey gotta move fast

RUNNER_NAME=${RUNNER_NAME:-test-runner-1}
RUNNER_LABEL=${RUNNER_LABEL:-linux.2xlarge}
RUNNER_REPO_URL="https://github.com/seemethere/test-repo"

RUNNER_IMAGE="bleh"

run_runner() {
  local image
  image=$1
  gpu_flag=""
  if nvidia-smi -L >/dev/null 2>/dev/null; then
    gpu_flag="--runtime=nvidia --gpus all"
  fi
  (
    set -x
    docker run \
      --rm \
      --name "${RUNNER_NAME}" \
      ${gpu_flag} \
      -e RUNNER_NAME="${RUNNER_NAME}" \
      -e RUNNER_LABEL="${RUNNER_LABEL}" \
      -e RUNNER_REPO_URL="${RUNNER_REPO_URL}" \
      -e RUNNER_TOKEN="${RUNNER_TOKEN}" \
      ${image}
  )
}

# run image once to register runner
run_runner "${RUNNER_IMAGE}"
# commit runner image after registration so we can just re-run it
(
  set -x
  docker commit "${RUNNER_NAME}" "${RUNNER_IMAGE}:${RUNNER_NAME}"
)

while true; do
  echo "+ Checking if container ${RUNNER_NAME} is running"
  if ! docker container inspect ${RUNNER_NAME} >/dev/null 2>/dev/null; then
    echo "+ Restarting container ${RUNNER_NAME}"
    run_runner "${RUNNER_IMAGE}:${RUNNER_NAME}"
  fi
  echo "+ Everything looks good, sleeping for 1 minute"
  sleep 60
done
