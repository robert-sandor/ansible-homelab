# Homelab setup

Set of [ansible](https://docs.ansible.com/ansible/latest/index.html) playbooks for setting up various self-hosted services in a homelab setting.
It uses [docker]() and [docker compose]() for service deployment wherever possible, with the goal of the deployment being reusable without the need for this project.

## Supported services

### Core apps

- [Authelia](docs/authelia.md) - used for authentication and OpenID Connect
- [LLDAP](https://github.com/lldap/lldap) - used as an LDAP backend for Authelia
- [Traefik](https://doc.traefik.io/traefik/) - routing to other deployed apps (reverse proxy) and HTTPS certificate management
- [ntfy](https://ntfy.sh) - push notifications
- [Mailrise]() - SMTP to ntfy conversion
- [Watchtower]() - automatic docker container updates and notifications
- [Docker Socket Proxy]() - expose Docker API safely

### Recommended apps

- [Adguard Home]() - DNS with network-wide ad-blocking
- [Dozzle]() - used to inspect docker logs
- [Gatus]() - monitors the uptime of deployed apps, and alerts to ntfy when apps are down
- [Homepage]() - web dashboard with links to all deployed apps
- [Netdata]() - metrics and logs, with automatic monitoring
- [NUT - Network UPS Tools]() - monitors connected UPS units, and coordinates shutdown of hosts
- [Restic]() - automatic backup of apps
- [Tailscale]() - wireguard based VPN
- [Vaultwarden]() - Bitwarden compatible password manager

### Optional apps

- [Gitea]() - self-hosted software development service with git support, code reviews, CI/CD and more
- [Immich]() - photo and video management (similar to Google Photos)
    > [!WARNING]
    > Immich is still in development - don't use this as the only way to store your photos/videos
- [Mealie]() - recipe and shopping list management
- [Memos]() - note taking app with Twitter (X) like interface
- [Nextcloud]() - file storage (similar to Google Drive)
- [Paperless]() - document library with OCR, email processing and more
- [Portainer]() - docker stack deployments, with support for k8s
- [Vikunja]() - task management

### Deprecated applications

- Monitoring - contains [grafana](), [prometheus]() and [loki]() for host and metrics monitoring - was replaced by [Netdata]() due to its simplicity

## Host setup

The playbooks operate on the following assumptions:

- There is at least one host to deploy on
- There is exactly one host that is considered **core** - this will host authelia and lldap
- There is exactly one host for notifications, to host [ntfy]()
