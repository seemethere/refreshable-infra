# this can more than likely be swapped out with any type of base image
FROM ubuntu:22.04 as base_runner_env
RUN apt update && apt install -y curl bash sudo ca-certificates
RUN install -m 0755 -d /etc/apt/keyrings && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
  chmod a+r /etc/apt/keyrings/docker.asc
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
  apt update && \
  apt install -y docker-ce-cli
RUN useradd -ms /bin/bash runner
USER runner
WORKDIR /home/runner
ARG RUNNER_VERSION=2.317.0
RUN mkdir actions-runner && \
  cd actions-runner && \
  curl -o actions-runner.tar.gz \
    -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
  tar xzf ./actions-runner.tar.gz
WORKDIR /home/runner/actions-runner
USER root
RUN /home/runner/actions-runner/bin/installdependencies.sh
USER runner

ADD docker-entrypoint.sh docker-entrypoint.sh
ENTRYPOINT ["bash", "/home/runner/actions-runner/docker-entrypoint.sh"]
