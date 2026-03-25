# Claudio — Claude Code in Docker

Run Claude Code inside an isolated Docker container with your project mounted as a volume. The container runs as the default `ubuntu` user (UID/GID 1000) shipped with the Ubuntu 24.04 base image.

## Prerequisites

- Docker and Docker Compose
- An Anthropic subscription (Claude Pro/Team/Enterprise)

## Setup

1. **Build the image**:

   ```bash
   docker compose build
   ```

2. **Create the config file** (required by Claude Code):

   ```bash
   echo '{}' > .claude.json
   ```

3. **Run Claude Code**:

   ```bash
   docker compose run --rm claude
   ```

   On first launch, Claude will prompt you to log in — follow the instructions in the terminal to authenticate.

## Project structure

```
.
├── .claude/          # Claude Code config (settings, skills, hooks) — committed
├── .claude.json      # Claude Code state — gitignored (contains credentials)
├── projects/         # Your workspaces — gitignored, each has its own repo
├── Dockerfile
└── docker-compose.yaml
```
