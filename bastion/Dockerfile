FROM ubuntu:22.04

ARG username=bastion
ARG home_path=/home/bastion

# Install zsh and OpenSSH client
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bind9-utils \
    ca-certificates \
    curl \
    git \
    iproute2 \
    neovim \
    netcat \
    net-tools \
    nmap \
    sed \
    sudo \
    tar \
    telnet \
    tmux \
    zsh && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /tmp/bootstrap/assets

COPY shell/aliases.zsh /tmp/bootstrap/assets/aliases.zsh
COPY shell/exports.zsh /tmp/bootstrap/assets/exports.zsh
COPY shell/functions.zsh /tmp/bootstrap/assets/functions.zsh
COPY shell/p10k.zsh /tmp/bootstrap/assets/.p10k.zsh
COPY shell/zshrc /tmp/bootstrap/assets/.zshrc

COPY bootstrap.sh /tmp/bootstrap/bootstrap.sh
RUN chmod +x /tmp/bootstrap/bootstrap.sh && \
    /tmp/bootstrap/bootstrap.sh

# Default to bastion user and home
USER $username
WORKDIR $home_path

# Ensure interactive zsh prompt by default
SHELL ["/usr/bin/zsh", "-c"]
CMD ["zsh"]
