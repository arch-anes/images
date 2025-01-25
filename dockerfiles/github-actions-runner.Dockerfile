FROM ghcr.io/actions/actions-runner:latest

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -

RUN sudo apt-get update && sudo apt-get install -y software-properties-common build-essential nodejs apt-transport-https pipx
