# n8n-server

A repository for managing n8n server and related services using Docker Compose.

## Quick Start

### Prerequisites

- Docker installed on your system
- Docker Compose (included with Docker Desktop or can be installed separately)

### Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/ermiahp/n8n-server.git
   cd n8n-server
   ```

2. Create your environment configuration:
   ```bash
   cp .env.example .env
   ```

3. Edit `.env` file with your preferred settings (optional)

### Running Services

This repository includes a convenient script to manage all Docker Compose services.

#### Start all services:
```bash
./run-docker-compose.sh up
```

#### Stop all services:
```bash
./run-docker-compose.sh down
```

#### Check status of all services:
```bash
./run-docker-compose.sh status
```

#### View logs from all services:
```bash
./run-docker-compose.sh logs
```

#### Restart all services:
```bash
./run-docker-compose.sh restart
```

#### Pull latest images:
```bash
./run-docker-compose.sh pull
```

#### Get help:
```bash
./run-docker-compose.sh --help
```

## Services

### Portainer
- Web UI: https://localhost:9443
- HTTP Port: 8000 (for Edge Agents)

Portainer is a lightweight management UI for Docker, allowing you to easily manage your Docker containers, images, networks, and volumes.

## Environment Variables

The script reads environment variables from the `.env` file. You can customize the following variables:

- `COMPOSE_PROJECT_NAME`: Project name for Docker Compose (default: n8n-server)
- `PORTAINER_HTTPS_PORT`: HTTPS port for Portainer (default: 9443)
- `PORTAINER_HTTP_PORT`: HTTP port for Portainer Edge Agents (default: 8000)

## Script Features

The `run-docker-compose.sh` script provides:

- **Automatic discovery**: Finds all `docker-compose.yml` files in the repository
- **Environment management**: Reads and applies variables from `.env` file
- **Comprehensive logging**: Detailed logging with timestamps and color-coded messages
- **Error handling**: Graceful error handling with informative messages
- **Multiple commands**: Support for up, down, restart, status, logs, and pull operations

## Troubleshooting

### Docker not found
Make sure Docker is installed and running on your system. You can verify with:
```bash
docker --version
```

### Permission denied
If you get a permission denied error, make sure the script is executable:
```bash
chmod +x run-docker-compose.sh
```

### Services not starting
Check the logs for detailed error messages:
```bash
./run-docker-compose.sh logs
```

## License

See [LICENSE](LICENSE) file for details.
