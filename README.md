# Strudel Docker Setup

Docker configuration for running the Strudel music live coding environment on your LOFN Debian server.

## Prerequisites

- Docker installed on your Debian server
- Docker Compose installed
- The Strudel repository cloned from GitHub

## Setup Instructions

### 1. Clone the Repository Structure

On your LOFN server, create a directory for Strudel:

```bash
mkdir -p ~/strudel-docker
cd ~/strudel-docker
```

### 2. Clone Your Forked Strudel Repository

```bash
git clone https://github.com/The-Alphabet-Cartel/strudel.git
```

Your directory structure should look like:
```
~/strudel-docker/
├── docker-compose.yml
├── docker-compose.production.yml
├── Dockerfile
├── README.md
└── strudel/          (the cloned repository)
```

### 3. Choose Your Setup

#### Option A: Quick Development Setup (Recommended for Testing)

Uses the simple docker-compose.yml without building a custom image:

```bash
# Start the container
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the container
docker-compose down
```

#### Option B: Production Setup with Custom Build

Uses the Dockerfile for an optimized image:

```bash
# Build and start
docker-compose -f docker-compose.production.yml up -d --build

# View logs
docker-compose -f docker-compose.production.yml logs -f

# Stop
docker-compose -f docker-compose.production.yml down
```

## Accessing Strudel

Once running, access Strudel at:
- **Local**: http://localhost:4321
- **Network**: http://YOUR_SERVER_IP:4321

Replace `YOUR_SERVER_IP` with your LOFN server's IP address.

## Configuration

### Port Configuration

If port 4321 is already in use, modify the port mapping in docker-compose.yml:

```yaml
ports:
  - "8080:4321"  # Maps host port 8080 to container port 4321
```

### Resource Limits

The production setup includes resource limits. Adjust in `docker-compose.production.yml`:

```yaml
deploy:
  resources:
    limits:
      cpus: '4'      # Maximum CPU cores
      memory: 4G     # Maximum memory
```

## Updating Strudel

To update to the latest version:

```bash
cd ~/strudel-docker/strudel
git pull origin main

# Restart the containers
cd ..
docker-compose down
docker-compose up -d
```

For production setup:
```bash
docker-compose -f docker-compose.production.yml down
docker-compose -f docker-compose.production.yml up -d --build
```

## Troubleshooting

### Container won't start
```bash
# Check logs
docker-compose logs

# Check if port is already in use
sudo netstat -tlnp | grep 4321
```

### Permission issues
```bash
# Ensure proper ownership
sudo chown -R $USER:$USER ~/strudel-docker/strudel
```

### Clear cache and rebuild
```bash
docker-compose down -v
docker-compose up -d --build
```

## Server Specifications

Your LOFN server specs:
- CPU: Ryzen 7 5800x (8 cores / 16 threads)
- RAM: 64GB
- OS: Debian Linux
- Docker-based hosting platform

This configuration is optimized for these specifications.

## Additional Commands

```bash
# Enter the running container
docker-compose exec strudel sh

# View container resource usage
docker stats strudel-app

# Rebuild without cache
docker-compose build --no-cache
docker-compose up -d
```

## License

Strudel is licensed under GNU AGPL-3.0. See the LICENSE file in the strudel directory.

## Support

For Strudel-specific issues, visit: https://codeberg.org/uzu/strudel
For Docker setup issues, contact The Alphabet Cartel team.
