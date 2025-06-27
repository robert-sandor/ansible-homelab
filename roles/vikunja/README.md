# Ansible Role: Vikunja

[Vikunja](https://vikunja.io/) is an open-source, self-hosted to-do application designed for project and task management. It offers features such as lists, tasks, sharing, reminders, and integrations, making it ideal for personal productivity or collaborative work in a homelab environment.

For full documentation, visit the [official Vikunja documentation](https://vikunja.io/docs/).

## Role Variables

All configuration for this role is considered advanced and should be reviewed before deployment:

### Advanced Settings

- `vikunja_deploy_path`: Path where Vikunja will be deployed (default: `{{ deploy_path }}/vikunja`)
- `vikunja_backup_path`: Path for Vikunja backups (default: `{{ backup_path }}/vikunja`)
- `vikunja_version`: Version of Vikunja to deploy (default: `"0.24.6"`)
- `vikunja_hostname`: Public hostname for Vikunja (default: `vikunja.{{ hostname }}`)
- `vikunja_url`: Public URL for Vikunja (default: `https://{{ vikunja_hostname }}`)
- `vikunja_jwt_secret`: Secret used for JWT authentication (default: generated from deployment secret)
- `vikunja_local_auth_enable`: Enable local auth (default: inverse of `vikunja_openid_enable`, i.e., if OpenID is enabled, local auth is disabled)
- `vikunja_openid_enable`: Enable OpenID authentication (default: `true`)
- `vikunja_openid_name`: Name of the OpenID provider (default: `Authelia`)
- `vikunja_openid_authurl`: Authorization URL for the provider (default: `https://auth.{{ core_hostname }}`)
- `vikunja_openid_clientid`: Client ID for OpenID (default: `vikunja`)
- `vikunja_openid_clientsecret`: Client secret for OpenID (default: generated from deployment secret)
- `vikunja_openid_scope`: Scopes to request (default: `openid email profile`)
- `vikunja_pg_version`: Version of PostgreSQL to use (default: `"17.5"`)
- `vikunja_db_name`: Name of the Vikunja database (default: `vikunja`)
- `vikunja_db_user`: Database user for Vikunja (default: `vikunja`)
- `vikunja_db_pass`: Database password (default: generated from deployment secret)

> **Warning:** Do not change `vikunja_jwt_secret`, `vikunja_openid_clientsecret`, `vikunja_db_name`, `vikunja_db_user`, or `vikunja_db_pass` after deployment, as this may break your installation or cause data loss.

## Example Playbook

```yaml
- hosts: vikunja
  roles:
    - role: vikunja
