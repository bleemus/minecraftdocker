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

2. Create the data directory:
   ```bash
   mkdir -p data/worlds
   ```

3. (Optional) Add a custom `server.properties` file to `data/` directory. If not provided, the server will generate one on first run.

4. Build and start the server:
   ```bash
   ./new_minecraft.sh
   ```

## Configuration

### Server Properties

Edit `data/server.properties` to configure server settings (game mode, difficulty, player limit, etc.). Changes require a server restart:

```bash
sudo docker compose restart
```

### Volume Paths

By default, the docker-compose.yml uses hardcoded paths at `/home/bleemus/mcdata/`. Update these paths in `docker-compose.yml` to match your setup:

```yaml
volumes:
  - "/your/path/server.properties:/bedrock-server/server.properties"
  - "/your/path/worlds/:/bedrock-server/worlds"
```

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

World data is stored in the mounted `worlds/` directory. To backup:

```bash
tar -czf minecraft-backup-$(date +%Y%m%d).tar.gz data/worlds/
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
Ensure the data directory is accessible:
```bash
chmod -R 755 data/
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
├── data/               # Server data (not in git)
│   ├── server.properties
│   └── worlds/
└── README.md
```

## License

This project is for running the official Minecraft Bedrock Server. The Minecraft server software is property of Mojang/Microsoft and subject to their EULA.
