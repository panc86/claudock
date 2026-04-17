# syntax=docker/dockerfile:1
FROM ubuntu:24.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies in a single layer, clean up apt cache
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js LTS via NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/*

# Switch to non-privileged user (ubuntu ships with UID/GID 1000)
USER ubuntu
WORKDIR /home/ubuntu

# Install Claude Code globally
RUN curl -fsSL https://claude.ai/install.sh | bash

# Install UV Python package manager
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

WORKDIR /home/ubuntu/projects
