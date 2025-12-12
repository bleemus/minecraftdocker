# Minecraft Bedrock Server (Docker)

A containerized Minecraft Bedrock Edition server that automatically downloads and runs the latest official server binary.

## Features

- Automatically fetches the latest Bedrock server from Minecraft's official API
- Persistent world and configuration storage
- Automatic restarts on failure
- Non-root container execution for improved security
- Simple one-command deployment and updates

## Prerequisites

- Docker
- Docker Compose
- sudo access (or Docker group membership)

## Setup

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd minecraftdocker
   ```

2. Configure environment variables:
   ```bash
   cp .env.example .env
   ```

   Edit `.env` to customize paths and user/group IDs (see Configuration section below).

3. Create the data directory:
   ```bash
   mkdir -p /path/to/your/mcdata/worlds
   ```

   Replace `/path/to/your/mcdata` with the value you set for `MCDATA_PATH` in `.env`.

4. (Optional) Add a custom `server.properties` file to your data directory. If not provided, the server will generate one on first run.

5. Build and start the server:
   ```bash
   ./new_minecraft.sh
   ```

## Configuration

### Server Properties

Edit `data/server.properties` to configure server settings (game mode, difficulty, player limit, etc.). Changes require a server restart:

```bash
sudo docker compose restart
```

### Environment Variables

The server uses environment variables for configuration. Create a `.env` file in the project root (copy from `.env.example`):

```bash
cp .env.example .env
```

Available variables:

- **MCDATA_PATH** (default: `/home/bleemus/mcdata`)
  - Path to the directory containing server data
  - This directory should contain `server.properties` and the `worlds/` subdirectory
  - Example: `MCDATA_PATH=/opt/minecraft/data`

- **USER_ID** and **GROUP_ID** (default: `1000`)
  - User and group IDs for the container user
  - Should match your host user to prevent permission issues with mounted volumes
  - Find your IDs: `id -u` (user) and `id -g` (group)
  - Example: `USER_ID=1001` and `GROUP_ID=1001`

Example `.env` file:
```bash
MCDATA_PATH=/opt/minecraft/data
USER_ID=1000
GROUP_ID=1000
```

Changes to `.env` require rebuilding the image (for USER_ID/GROUP_ID) or restarting the container (for MCDATA_PATH)

### EULA

The server automatically accepts the Minecraft EULA via the `EULA: "TRUE"` environment variable. By running this server, you agree to the [Minecraft End User License Agreement](https://www.minecraft.net/en-us/eula).

## Usage

### Deploy/Update Server

To update to the latest Bedrock server version:

```bash
./new_minecraft.sh
```

This script:
1. Stops the current server
2. Archives the current image with a date tag
3. Builds a fresh image with the latest Bedrock server
4. Starts the new server

### Manual Commands

```bash
# Start server
sudo docker compose up -d

# Stop server
sudo docker compose down

# View logs
sudo docker logs minecraft

# Follow logs in real-time
sudo docker logs -f minecraft

# Restart server
sudo docker compose restart

# Access server console (Ctrl+C to detach)
sudo docker attach minecraft
```

### Backup

World data is stored in the `worlds/` subdirectory of your configured MCDATA_PATH. To backup:

```bash
# Replace /path/to/your/mcdata with your MCDATA_PATH value
tar -czf minecraft-backup-$(date +%Y%m%d).tar.gz /path/to/your/mcdata/worlds/
```

Previous Docker images are automatically tagged with the date (MMDDYY format) when running `./new_minecraft.sh`.

## Network

The server uses `network_mode: "host"` to bind directly to the host network on UDP port 19132. Ensure this port is:
- Not blocked by your firewall
- Forwarded in your router (for external access)

## Troubleshooting

### Server won't start
```bash
# Check logs for errors
sudo docker logs minecraft

# Verify the container is running
sudo docker ps
```

### Permission issues
Ensure the data directory is accessible and owned by the correct user:
```bash
# Make directory accessible
chmod -R 755 /path/to/your/mcdata

# Fix ownership (use the same USER_ID/GROUP_ID from your .env file)
sudo chown -R 1000:1000 /path/to/your/mcdata
```

### Port already in use
Check if another process is using port 19132:
```bash
sudo netstat -tulpn | grep 19132
```

## File Structure

```
.
├── Dockerfile           # Container image definition
├── docker-compose.yml   # Service configuration
├── new_minecraft.sh     # Deployment script
├── .env.example        # Example environment variables
├── .env                # Your environment configuration (create from .env.example)
├── README.md
└── [MCDATA_PATH]/      # Server data (configured location, not in git)
    ├── server.properties
    └── worlds/
```

## License

This project is for running the official Minecraft Bedrock Server. The Minecraft server software is property of Mojang/Microsoft and subject to their EULA.
