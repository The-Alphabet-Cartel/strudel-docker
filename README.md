# Strudel Docker Setup

Docker configuration for running the Strudel music live coding environment on your LOFN Debian server.

## Prerequisites

- Docker installed on your Debian server
- Docker Compose installed

## Deployment

**Quick, easy, no repository cloning needed.**

See [DEPLOYMENT.md](DEPLOYMENT.md) for complete instructions.

Quick start:
```bash
# Create the Strudel Directory
mkdir ~/strudel && cd ~/strudel

# Download docker-compose.yml
curl -O https://raw.githubusercontent.com/The-Alphabet-Cartel/strudel-docker/main/docker-compose.yml

#Start Strudel
docker compose up -d
```

Benefits:
- ✅ Fastest deployment (< 1 minute)
- ✅ Minimal disk space (~500 MB)
- ✅ No build dependencies
- ✅ Easy updates with `docker compose pull`
- ✅ Automatically built via GitHub Actions

## Accessing Strudel

Once running, access Strudel at:
- **Local**: http://localhost:4321
- **Network**: http://YOUR_SERVER_IP:4321

Replace `YOUR_SERVER_IP` with your server's IP address.

## Configuration

### Port Configuration

If port 4321 is already in use, modify the port mapping in `docker-compose.yml`:

```yaml
ports:
  - "8080:4321"  # Maps host port 8080 to container port 4321
```

### Resource Limits

The production setup includes resource limits. Adjust in `docker-compose.yml`:

```yaml
deploy:
  resources:
    limits:
      cpus: '4'      # Maximum CPU cores
      memory: 4G     # Maximum memory
```

## Troubleshooting

### Container won't start
```bash
# Check logs
docker compose logs strudel

# Check if port is already in use
sudo netstat -tlnp | grep 4321
```

### Clear cache and restart

```bash
docker compose down -v
docker compose pull
docker compose up -d
```

## Additional Commands

```bash
# View container resource usage
docker stats strudel
```

## License

Strudel is licensed under GNU AGPL-3.0. See the LICENSE file in the strudel directory.

## Automated Builds

Docker images are automatically built and published to GitHub Container Registry via GitHub Actions when:

- Code is pushed to the `main` branch
- Dockerfile or submodule is updated
- Weekly on Sundays at 2am UTC (to pick up Strudel updates)
- Manually triggered via GitHub Actions

## Support

For Strudel-specific issues, visit: https://codeberg.org/uzu/strudel
For Docker setup issues, contact The Alphabet Cartel team.
