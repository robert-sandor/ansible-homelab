# Ansible Role: Vaultwarden

[Vaultwarden](https://github.com/dani-garcia/vaultwarden) is an open-source, lightweight, and efficient server implementation of Bitwarden, a popular password manager. Vaultwarden is ideal for self-hosted environments and homelabs, providing secure password management for individuals and teams.

For full documentation, visit the [official Vaultwarden documentation](https://github.com/dani-garcia/vaultwarden/wiki).

## Role Variables

### Basic Settings

- `vaultwarden_allow_signups`: Whether to allow new accounts to be created (default: `true`)
- `vaultwarden_show_password_hint`: Whether to show password hints (default: `false`)

### Advanced Settings

- `vaultwarden_deploy_path`: Path where Vaultwarden will be deployed (default: `{{ deploy_path }}/vaultwarden`)
- `vaultwarden_backup_path`: Path for Vaultwarden backups (default: `{{ backup_path }}/vaultwarden`)
- `vaultwarden_data_path`: Path for Vaultwarden data (default: `{{ vaultwarden_deploy_path }}/data`)
- `vaultwarden_version`: Version of Vaultwarden to deploy (default: `"1.34.1"`)
- `vaultwarden_docker_image`: Docker image for Vaultwarden (default: `vaultwarden/server:{{ vaultwarden_version }}`)
- `vaultwarden_docker_container_name`: Docker container name for Vaultwarden (default: `vaultwarden`)
- `vaultwarden_docker_user`: User and group to run the container as (default: `{{ ansible_facts.user_uid }}:{{ ansible_facts.user_gid }}`)
- `vaultwarden_hostname`: Public hostname for Vaultwarden (default: `vaultwarden.{{ hostname }}`)
- `vaultwarden_url`: Public URL for Vaultwarden (default: `https://{{ vaultwarden_hostname }}`)
- `vaultwarden_pg_version`: Version of PostgreSQL to use (default: `"17.5"`)
- `vaultwarden_pg_docker_image`: Docker image for PostgreSQL (default: `docker.io/library/postgres:{{ vaultwarden_pg_version }}`)
- `vaultwarden_pg_docker_container_name`: Docker container name for PostgreSQL (default: `vaultwarden-db`)
- `vaultwarden_db_name`: Name of the Vaultwarden database (default: `vaultwarden`)
- `vaultwarden_db_user`: Database user for Vaultwarden (default: `vaultwarden`)
- `vaultwarden_db_pass`: Database password (default: generated from deployment secret)

> **Warning:** Do not change `vaultwarden_db_name`, `vaultwarden_db_user`, or `vaultwarden_db_pass` after deployment, as this may break your installation or cause data loss.

## Example Playbook

```yaml
- hosts: vaultwarden
  roles:
    - role: vaultwarden
```

## Further Configuration

For more advanced configuration options, refer to the role's `templates/compose.yml` and the [Vaultwarden documentation](https://github.com/dani-garcia/vaultwarden/wiki).