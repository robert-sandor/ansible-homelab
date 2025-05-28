# Ansible Role: Portainer

This role installs and configures Portainer, a lightweight management UI that allows you to easily manage your Docker and Kubernetes environments. It can deploy Portainer Server, Portainer Agent, or both.

When the Portainer Server is enabled, this role will:
*   Initialize the admin user.
*   Configure OpenID Connect (OIDC) authentication with Authelia.
*   Automatically add the local Docker environment as an endpoint.
*   Discover and manage other Portainer agents deployed on hosts within the `portainer` inventory group and those specified in `portainer_extra_agents`.
*   Expose the Portainer Server via Traefik with HTTPS.

## Requirements

*   Ansible 2.9 or higher.
*   Docker installed on the target host(s).
*   The `community.docker` Ansible collection (`ansible-galaxy collection install community.docker`).
*   A pre-existing external Docker network named `traefik` if `portainer_server` is `true`.
*   Traefik configured as a reverse proxy if `portainer_server` is `true`.
*   Authelia configured for OIDC if `portainer_server` is `true` and OIDC integration is desired.
*   The following variables are expected to be defined, typically in group_vars or inventory:
    *   `deploy_path`: Base path for application deployments (e.g., `/opt/homelab`).
    *   `deployment_secret`: A secret string used for generating other secrets.
    *   `domain`: The primary domain for your services (e.g., `example.com`).
    *   `core_hostname`: The hostname where core services like Authelia are running (e.g., `services.example.com`).
    *   `hostname`: The FQDN of the host where Portainer server will be deployed (e.g. `node1.example.com`). This is typically derived from `inventory_hostname`.
    *   `base_traefik_acme_staging`: (boolean) Whether Traefik is using Let's Encrypt staging environment. This influences certificate validation.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`).

### User-configurable Variables (`defaults/main.yml`)

These variables can be overridden to customize the role's behavior.

| Variable                  | Default        | Description                                                                                                                              |
| :------------------------ | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------- |
| `portainer_server`        | `false`        | If `true`, deploys the Portainer server instance on this host. Recommended to be `true` on only one host. If `false`, only agent is deployed. |
| `portainer_admin_user`    | `admin`        | The username for the Portainer admin account created during initial setup.                                                               |
| `portainer_admin_password`| `changeme`     | The password for the Portainer admin account. **Change this for production!**                                                            |
| `portainer_extra_agents`  | `[]`           | A list of additional hostnames (short names, without domain) running Portainer agents to be added to the server.                       |

### Advanced Configuration (`vars/main.yml`)

These variables are defined in `vars/main.yml`. While they can be overridden, it's generally recommended to use the defaults unless you have a specific reason and understand the implications, as they are often tied to the internal logic of the role or conventions within the `ansible-homelab` project.

| Variable                  | Default                                                    | Description                                                                                                                              |
| :------------------------ | :--------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------- |
| `portainer_deploy_path`   | `"{{ deploy_path }}/portainer"`                            | The directory on the target host where Portainer configuration and compose files will be stored.                                         |
| `portainer_version`       | `"2.29.2"`                                                 | The version of Portainer (CE and Agent) to deploy. Check [Portainer releases](https://github.com/portainer/portainer/releases) for updates. |
| `portainer_authelia_secret` | `"{{ ('portainer@' + deployment_secret) \| hash('sha256') }}"` | Client secret for OIDC communication with Authelia. Generated based on `deployment_secret`.                                           |

### Implicit Variables (from `tasks/server.yml` and `templates/compose.yml`)

The role also uses and expects certain variables to be available in the Ansible environment:
*   `hostname`: Typically `inventory_hostname_short` or a fully qualified name used for Traefik rules (e.g., `portainer.{{ hostname }}`). In the context of `compose.yml`, this is the FQDN for the Portainer service.
*   `domain`: Your main domain (e.g., `example.com`), used for constructing agent URLs.
*   `core_hostname`: The FQDN of your core services host, where Authelia is running (e.g., `auth.services.example.com`).
*   `base_traefik_acme_staging`: Boolean indicating if Traefik uses Let's Encrypt staging certificates. Affects `validate_certs` for API calls.

## Dependencies

*   This role assumes Docker is installed and running on the target hosts.
*   If `portainer_server` is `true`:
    *   It relies on Traefik for reverse proxying and SSL termination. Ensure Traefik is configured and the `traefik` Docker network exists.
    *   It integrates with Authelia for OIDC authentication. Ensure Authelia is set up and accessible.
*   The role uses `ansible.builtin.uri` for API calls, which might require network access from the Ansible controller to the Portainer API endpoint during server configuration.

## Example Playbook

Here's an example of how to use this role in a playbook:

```yaml
- hosts: docker_hosts
  become: true
  roles:
    - role: portainer
      vars:
        portainer_server: "{{ true if inventory_hostname == 'main_server_hostname' else false }}"
        portainer_admin_password: "MySecurePassword123!"
        portainer_extra_agents:
          - "worker-node-1"
          - "media-server"
        # Ensure global vars like deploy_path, deployment_secret, domain, core_hostname are set
        # e.g., in group_vars/all.yml
        # deploy_path: /opt/apps
        # deployment_secret: "a-very-secret-phrase"
        # domain: myhomelab.lan
        # core_hostname: infra.myhomelab.lan # for Authelia
```

This example playbook applies the `portainer` role to all hosts in the `docker_hosts` group.
It enables the Portainer server only on the host named `main_server_hostname`. All other hosts in the group will get the Portainer agent.

### Inventory Setup

For automatic agent discovery, ensure your inventory includes a group named `portainer` which contains all hosts where the Portainer agent should be running and managed by the server instance.

Example inventory (`inventory.ini`):

```ini
[portainer_server]
main_server_hostname ansible_host=192.168.1.10

[portainer_agents]
worker-node-1 ansible_host=192.168.1.11
media-server ansible_host=192.168.1.12

[portainer:children]
portainer_server
portainer_agents

[all:vars]
ansible_user=your_ssh_user
deploy_path=/opt/homelab_apps
deployment_secret="super_secret_value_for_hashing"
domain="your.domain.com"
core_hostname="auth.your.domain.com" # Where Authelia is running
base_traefik_acme_staging=false
```

## Functionality Details

1.  **Directory Structure**: Creates `{{ portainer_deploy_path }}` for compose and environment files.
2.  **Docker Compose Templating**: Generates a `compose.yml` in `{{ portainer_deploy_path }}` based on `templates/compose.yml`.
    *   Includes services for `agent` and `server`.
    *   Uses Docker Compose profiles (`server` or `agent`) to control which service is started.
    *   Server service includes Traefik labels for reverse proxying and HTTPS.
    *   Includes labels for `homepage` dashboard integration and `wud` (What's Up Docker) update notifications.
3.  **Environment File**: Creates an `.env` file in `{{ portainer_deploy_path }}` to set `COMPOSE_PROFILES`.
4.  **Container Deployment**: Uses `community.docker.docker_compose_v2` to deploy the services.
5.  **Server Configuration** (when `portainer_server` is `true`):
    *   **Admin User**: Checks if the admin user exists; if not, initializes it using `portainer_admin_user` and `portainer_admin_password`.
    *   **Authentication**: Authenticates with Portainer API to obtain a JWT.
    *   **OIDC with Authelia**: Configures Portainer settings to use OpenID Connect with Authelia.
    *   **Local Endpoint**: Adds the local Docker socket (`unix:///var/run/docker.sock`) as an endpoint named after the host.
    *   **Agent Management**:
        *   Retrieves a list of current endpoints from the Portainer API.
        *   Builds a target list of agents based on hosts in the `portainer` inventory group (excluding the server itself) and the `portainer_extra_agents` variable. Agent URLs are assumed to be `tcp://<agent_hostname>.<domain>:9001`.
        *   Removes stale agent endpoints from Portainer that are no longer in the target list.
        *   Adds new agent endpoints to Portainer that are in the target list but not yet configured.

## License

MIT (or specify your preferred license)

## Author Information

This role was created for the `ansible-homelab` project.
