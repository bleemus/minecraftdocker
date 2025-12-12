# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository provides a Docker implementation for running a Minecraft Bedrock Edition server on Linux. The setup automatically downloads the latest official Bedrock server binary from Minecraft's API and packages it in a container.

## Architecture

### Docker Image Build Process

The Dockerfile implements a two-stage approach to obtaining the Bedrock server:

1. **Dynamic Download**: Uses Minecraft's official download-links API (`net-secondary.web.minecraft-services.net/api/v1.0/download/links`) to fetch the latest Bedrock Linux server URL
2. **JSON Parsing**: Uses `jq` to extract the `serverBedrockLinux` download URL from the API response
3. **Server Extraction**: Downloads and unzips the server into `/bedrock-server`

The server runs on UDP port 19132 (standard Bedrock port) with `LD_LIBRARY_PATH` set to the current directory for shared library resolution.

### Volume Mapping

The docker-compose configuration mounts two critical directories from the host:
- `/home/bleemus/mcdata/server.properties` → container's server configuration
- `/home/bleemus/mcdata/worlds/` → persistent world data

Uses `network_mode: "host"` for direct network access, avoiding port mapping complexity with UDP.

## Common Commands

### Build and Deploy New Server Version

```bash
./new_minecraft.sh
```

This script performs a complete rebuild and deployment:
1. Stops the running container
2. Tags the current image with today's date (MMDDYY format) as a backup
3. Builds a fresh image with `--no-cache` to fetch the latest Bedrock server
4. Starts the container in detached mode

**Important**: This script uses `sudo` for all Docker commands, so ensure proper permissions.

### Manual Docker Operations

```bash
# Build the image
sudo docker build . -t minecraft:latest

# Start the server
sudo docker compose up -d

# Stop the server
sudo docker compose down

# View logs
sudo docker logs minecraft

# Access server console
sudo docker attach minecraft
```

### Configuration

Server configuration is managed through the mounted `server.properties` file at `/home/bleemus/mcdata/server.properties`. World data persists in `/home/bleemus/mcdata/worlds/`.

Modify `docker-compose.yml` volume paths if data should be stored elsewhere on the host system.
