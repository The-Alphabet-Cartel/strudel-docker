# Strudel Docker Deployment Guide

This guide covers deploying Strudel using pre-built Docker images from GitHub Container Registry.

## Quick Start (Using Pre-Built Image)

This is the **recommended approach** for production deployments.

### 1. Create a Simple Directory

```bash
mkdir -p ~/strudel
cd ~/strudel
```

### 2. Download docker-compose.yml

```bash
# Download the compose file
curl -O https://raw.githubusercontent.com/The-Alphabet-Cartel/strudel-docker/master/docker-compose.yml

# Or create it manually (see content below)
```

### 3. Start Strudel

```bash
# Start the container (from within the strudel directory)
docker compose up -d

# View logs
docker logs strudel

# Access at http://YOUR_SERVER_IP:4321
```

That's it! No repository cloning, no building, just run.

## docker-compose.yml Content

```yaml
services:
  strudel:
    container_name: strudel
    image: ghcr.io/the-alphabet-cartel/strudel-docker:latest
    ports:
      - "4321:4321"
    environment:
      - NODE_ENV=production
      - HOST=0.0.0.0
    restart: unless-stopped
    networks:
      - strudel-network

networks:
  strudel-network:
    driver: bridge
```

## Updating the Application

```bash
# Pull the latest image (again, from within the strudel directory)
docker compose pull

# Restart with new image
docker compose up -d

# Or in one command:
docker compose pull && docker compose up -d
```

## Available Image Tags

Images are automatically built and pushed to GitHub Container Registry:

- `latest` - Latest build from main branch (recommended)
- `main-<commit-sha>` - Specific commit from main branch
- `YYYYMMDD` - Build from specific date

Example using a specific date:
```yaml
image: ghcr.io/the-alphabet-cartel/strudel-docker:20241211
```

## GitHub Container Registry Access

### Public Images

To make images publicly accessible without authentication:

1. Go to https://github.com/orgs/The-Alphabet-Cartel/packages
2. Find the `strudel-docker` package
3. Click "Package settings"
4. Under "Danger Zone" → "Change visibility"
5. Select "Public"
6. Confirm the change

Now anyone can pull without authentication!

## Advanced Configuration

### Custom Port

Edit the ports section:
```yaml
ports:
  - "8080:4321"  # Access on port 8080
```

### Resource Limits

Add resource constraints:
```yaml
deploy:
  resources:
    limits:
      cpus: '2'
      memory: 2G
    reservations:
      cpus: '1'
      memory: 1G
```

## Monitoring

```bash
# View logs
docker logs strudel

# Check resource usage
docker stats strudel

# Check container status
docker compose ps
```

## Troubleshooting

### Image Pull Fails

```bash
# Check if package is public
curl -I https://ghcr.io/v2/the-alphabet-cartel/strudel-docker/manifests/latest
```

### Container Won't Start

```bash
# Check logs
docker logs strudel

# Verify port is available
sudo netstat -tlnp | grep 4321

# Remove and recreate
docker compose down
docker compose up -d
```

### Old Version Running

```bash
# Force pull latest
docker compose pull --ignore-pull-failures
docker compose up -d --force-recreate
```

## Production Recommendations

1. ✅ Set up automatic updates with cron/systemd
2. ✅ Use a reverse proxy (nginx/traefik) for SSL

## Automatic Updates (Optional)

Create a cron job for automatic updates:

```bash
# Edit crontab
crontab -e

# Add line to update daily at 3am:
0 3 * * * cd ~/strudel && docker compose pull -q && docker compose up -d
```
