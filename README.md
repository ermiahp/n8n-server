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

This repository includes a convenient script to manage all Docker Compose services. You can manage all services at once or target specific services individually.

#### List available services:
```bash
./run-docker-compose.sh list
```

#### Start all services:
```bash
./run-docker-compose.sh up
```

#### Start a specific service:
```bash
./run-docker-compose.sh up n8n
./run-docker-compose.sh up portainer
./run-docker-compose.sh up nginxproxymanager
```

#### Stop all services:
```bash
./run-docker-compose.sh down
```

#### Stop a specific service:
```bash
./run-docker-compose.sh down n8n
./run-docker-compose.sh down portainer
./run-docker-compose.sh down nginxproxymanager
```

#### Check status of all services:
```bash
./run-docker-compose.sh status
```

#### Check status of a specific service:
```bash
./run-docker-compose.sh status n8n
```

#### View logs from all services:
```bash
./run-docker-compose.sh logs
```

#### View logs from a specific service:
```bash
./run-docker-compose.sh logs n8n
```

#### Restart all services:
```bash
./run-docker-compose.sh restart
```

#### Restart a specific service:
```bash
./run-docker-compose.sh restart n8n
```

#### Pull latest images:
```bash
./run-docker-compose.sh pull
```

#### Pull images for a specific service:
```bash
./run-docker-compose.sh pull n8n
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

### Nginx Proxy Manager
- Web UI: http://localhost:81
- Public HTTP Port: 80
- Public HTTPS Port: 443

Nginx Proxy Manager provides an easy way to manage your Nginx proxy hosts with a simple, powerful interface.

### N8N
- Web UI: http://localhost:5678

N8N is a powerful workflow automation tool that allows you to connect different services and automate tasks. It features a visual workflow editor and supports webhooks for external integrations.

#### Configuring N8N with Nginx Proxy Manager

To access N8N through Nginx Proxy Manager with a custom domain:

1. Start all services including N8N
2. Access Nginx Proxy Manager at http://localhost:81
3. Create a new Proxy Host with:
   - **Domain Names**: Your domain (e.g., n8n.yourdomain.com)
   - **Scheme**: http
   - **Forward Hostname/IP**: n8n (the container name)
   - **Forward Port**: 5678
   - **Enable SSL** if you have a certificate configured
4. Update your `.env` file with the custom webhook URL:
   ```
   N8N_WEBHOOK_URL=https://n8n.yourdomain.com/
   N8N_HOST=n8n.yourdomain.com
   N8N_PROTOCOL=https
   ```
5. Restart N8N service: `./run-docker-compose.sh restart`

**Important**: The `WEBHOOK_URL` environment variable must be set to your external domain for webhooks to work correctly. This URL is used by external services to send data to your N8N workflows.

## Ports Reference

This table lists all ports used by services in this repository:

| Service                   | Port | Protocol | Purpose              | Access URL               |
|---------------------------|------|----------|----------------------|--------------------------|
| **Portainer**             | 9443 | HTTPS    | Web UI               | https://localhost:9443   |
| **Portainer**             | 8000 | HTTP     | Edge Agents          | http://localhost:8000    |
| **Nginx Proxy Manager**   | 81   | HTTP     | Admin Web UI         | http://localhost:81      |
| **Nginx Proxy Manager**   | 80   | HTTP     | Public HTTP Proxy    | -                        |
| **Nginx Proxy Manager**   | 443  | HTTPS    | Public HTTPS Proxy   | -                        |
| **N8N**                   | 5678 | HTTP     | Web UI & API         | http://localhost:5678    |

> **Note**: Ports are defined in their respective `docker-compose.yml` files and can be modified by editing those files directly.

## Environment Variables

The script reads environment variables from the `.env` file. You can customize the following variables:

### Docker Compose
- `COMPOSE_PROJECT_NAME`: Project name for Docker Compose (default: n8n-server)

### Portainer
- `PORTAINER_HTTPS_PORT`: HTTPS port for Portainer (default: 9443)
- `PORTAINER_HTTP_PORT`: HTTP port for Portainer Edge Agents (default: 8000)

### N8N
- `N8N_HOST`: Hostname for N8N (default: localhost)
- `N8N_PORT`: Port for N8N (default: 5678)
- `N8N_PROTOCOL`: Protocol (http or https, default: http)
- `N8N_WEBHOOK_URL`: External webhook URL (required for webhooks to work)
- `N8N_GENERIC_TIMEZONE`: Generic timezone (default: UTC)
- `N8N_TZ`: Timezone (default: UTC)
- `N8N_ENCRYPTION_KEY`: Encryption key for credentials (IMPORTANT: change this!)
- `N8N_BASIC_AUTH_USER`: Optional basic auth username
- `N8N_BASIC_AUTH_PASSWORD`: Optional basic auth password
- `N8N_EXECUTIONS_PROCESS`: Execution process mode (default: main)
- `N8N_EXECUTIONS_MODE`: Execution mode (default: regular)

## Script Features

The `run-docker-compose.sh` script provides:

- **Automatic discovery**: Finds all `docker-compose.yml` files in the repository
- **Service filtering**: Target specific services or all services at once
- **Environment management**: Reads and applies variables from `.env` file
- **Comprehensive logging**: Detailed logging with timestamps and color-coded messages
- **Error handling**: Graceful error handling with informative messages
- **Multiple commands**: Support for up, down, restart, status, logs, pull, and list operations

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
