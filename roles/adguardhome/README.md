# Ansible Role: AdGuard Home

This Ansible role installs and configures [AdGuard Home](https://github.com/AdguardTeam/AdGuardHome), a network-wide DNS ad blocker and DNS server. The role deploys AdGuard Home as a Docker container with Traefik integration.

## Role Variables

Variables are split into two categories:
- Variables in `defaults/main.yml` are meant to be modified by users of the role
- Variables in `vars/main.yml` contain internal role configuration and should only be modified by advanced users
- Note: `hostname` and `deploy_path` are provided globally by the playbook

### User Variables (defaults/main.yml)

<table>
<tr>
<th>Variable</th>
<th>Default</th>
<th>Description</th>
</tr>
<tr>
<td><code>adguardhome_user</code></td>
<td><code>admin</code></td>
<td>Admin username (only applies on first deploy)</td>
</tr>
<tr>
<td><code>adguardhome_password</code></td>
<td><code>changeme</code></td>
<td>Admin password (only applies on first deploy)</td>
</tr>
<tr>
<td><code>adguardhome_upstream_dns</code></td>
<td><code>["{{ ansible_default_ipv4.gateway }}"]</code></td>
<td>List of upstream DNS servers</td>
</tr>
<tr>
<td><code>adguardhome_bootstrap_dns</code></td>
<td><code>["1.1.1.1", "9.9.9.9"]</code></td>
<td>DNS servers for resolving upstreams</td>
</tr>
<tr>
<td><code>adguardhome_ratelimit</code></td>
<td><code>240</code></td>
<td>Per-client rate limit (requests/second, 0 to disable)</td>
</tr>
<tr>
<td><code>adguardhome_cache_size</code></td>
<td><code>256</code></td>
<td>DNS cache size in MiB (0 to disable)</td>
</tr>
<tr>
<td><code>adguardhome_wildcard_hosts</code></td>
<td><code>[]</code></td>
<td>List of hosts for wildcard subdomain rewrites</td>
</tr>
<tr>
<td><code>adguardhome_rewrites</code></td>
<td><code>[]</code></td>
<td>List of custom DNS rewrites</td>
</tr>
<tr>
<td><code>adguardhome_filter_lists</code></td>
<td><pre>
- name: AdGuard DNS filter
  url: https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt
  enabled: true
- name: AdAway Default Blocklist
  url: https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt
  enabled: true</pre></td>
<td>List of ad-blocking filter lists</td>
</tr>
</table>

### Internal Variables (vars/main.yml)

| Variable | Default | Description |
|----------|---------|-------------|
| `adguardhome_deploy_path` | `{{ deploy_path }}/adguardhome` | Path where AdGuard Home will be deployed |
| `adguardhome_version` | `v0.107.59` | Version of AdGuard Home to deploy |

## Dependencies

- Traefik (for web interface access)
- Common role (for systemd-resolved configuration)

## Example Playbook

```yaml
- hosts: dns_servers
  roles:
    - role: adguardhome
      vars:
        adguardhome_user: admin
        adguardhome_password: secure_password
        adguardhome_upstream_dns:
          - 1.1.1.1
          - 9.9.9.9
```

## Components

### DNS Server
- Network-wide DNS server and ad blocker
- Runs on port 53 (TCP/UDP)
- Web interface on port 3000 (proxied through Traefik)
- Integrates with Traefik for HTTPS access
- Includes Homepage integration labels
- Supports automatic updates via watchtower/wud

### Features
- DNS ad blocking with customizable filter lists
- Custom DNS rewrites and wildcard subdomain support
- DNS query caching
- Per-client rate limiting
- Automatic daily backups

## License

This role is part of the ansible-homelab playbook.
