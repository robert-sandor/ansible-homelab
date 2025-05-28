# Ansible Role: Beszel

This Ansible role installs and configures [Beszel](https://beszel.dev), a server monitoring solution. The role can deploy both the Beszel hub and agent components using Docker containers.

## Role Variables

Variables are split into three categories:
- Variables in `defaults/main.yml` are meant to be modified by users of the role
- Variables in `vars/main.yml` contain internal role configuration and should only be modified by advanced users
- Note: `hostname` and `deploy_path` are provided globally by the playbook

### User Variables (defaults/main.yml)

| Variable | Default | Description |
|----------|---------|-------------|
| `beszel_hub` | `false` | Whether to run the Beszel hub on this host |
| `beszel_key` | `changeme` | The Beszel public key from the app |

### Internal Variables (vars/main.yml)

| Variable | Default | Description |
|----------|---------|-------------|
| `beszel_deploy_path` | `{{ deploy_path }}/beszel` | Path where Beszel will be deployed |
| `beszel_version` | `0.10.2` | Version of Beszel to deploy |
| `beszel_hostname` | `beszel.{{ hostname }}` | The hostname for accessing Beszel through Traefik |

## Dependencies

- Traefik (for the hub component)

## Example Playbook

```yaml
- hosts: monitoring
  roles:
    - role: beszel
      vars:
        beszel_hub: true
        beszel_key: "your-beszel-key"
```

## Components

### Hub
- The central Beszel server that collects and displays monitoring data
- Runs on port 8090
- Integrates with Traefik for HTTPS access
- Includes Homepage integration labels
- Supports automatic updates via watchtower/wud

### Agent
- Lightweight monitoring agent that reports to the hub
- Runs with host network access
- Requires access to Docker socket for container monitoring

## License

This role is part of the ansible-homelab playbook.
