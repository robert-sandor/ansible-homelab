# Ansible Role: Unpackerr

[Unpackerr](https://github.com/unpackerr/unpackerr) is an automation tool that monitors your media library and automatically extracts archives (such as .rar, .zip, .7z) for use with media managers like Sonarr, Radarr, and Lidarr. It is ideal for homelab and self-hosted environments to keep your media library organized and ready for playback.

For full documentation, visit the [official Unpackerr documentation](https://github.com/unpackerr/unpackerr/wiki).

## Role Variables

### Basic Settings

- `unpackerr_media_path`: Path to your media library on the host (default: `"/media"`)

### Advanced Settings

- `unpackerr_version`: Version of Unpackerr to deploy (default: `"0.14.5"`)
- `unpackerr_docker_image`: Docker image for Unpackerr (default: `ghcr.io/unpackerr/unpackerr:{{ unpackerr_version }}`)
- `unpackerr_container_name`: Docker container name for Unpackerr (default: `"unpackerr"`)
- `unpackerr_deploy_path`: Path where Unpackerr will be deployed (default: `{{ deploy_path }}/unpackerr`)
- `unpackerr_backup_path`: Path for Unpackerr backups (default: `{{ backup_path }}/unpackerr`)
- `unpackerr_config_path`: Path for Unpackerr config (default: `{{ unpackerr_deploy_path }}/config`)
- `unpackerr_media_mount`: Path where the media library is mounted inside the container (default: `"/media"`)
- `unpackerr_config`: Main Unpackerr configuration object (TOML format, see below)
- `unpackerr_sonarr_config`: Sonarr integration config (URL, API key, paths)
- `unpackerr_radarr_config`: Radarr integration config (URL, API key, paths)
- `unpackerr_lidarr_config`: Lidarr integration config (URL, API key, paths)

> **Note:** The integration configs for Sonarr, Radarr, and Lidarr are auto-generated based on your inventory and group variables. API keys must be provided for each service.

## Example Playbook

```yaml
- hosts: unpackerr
  roles:
    - role: unpackerr
```

## Further Configuration

For more advanced configuration options, refer to the role's `templates/compose.yml`, `defaults/main.yml`, and the [Unpackerr documentation](https://github.com/unpackerr/unpackerr/wiki).