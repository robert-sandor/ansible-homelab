# Tailscale Role

This Ansible role installs and configures Tailscale on a target system, setting up secure networking with automatic authentication and route management.

## Requirements

- Ansible 2.9 or higher
- A Tailscale account and API key
- Target system with internet access

## Role Variables

Required variables:
- `tailscale_api_key`: Your Tailscale API key for authentication
- `tailscale_tailnet`: Your Tailscale network name (typically your domain)

Optional variables:
- `tailscale_routes`: List of routes to advertise (e.g., `["10.0.0.0/24"]`)
- `tailscale_exit_node`: Boolean to configure the node as an exit node (default: `false`)

## Dependencies

None

## Example Playbook

```yaml
- hosts: servers
  roles:
    - role: tailscale
      vars:
        tailscale_api_key: "tskey-xxx..."
        tailscale_tailnet: "example.com"
        tailscale_routes:
          - "192.168.1.0/24"
        tailscale_exit_node: true
```

## Features

- Enables IP forwarding for IPv4 and IPv6
- Automatically installs Tailscale package from official repositories
- Handles authentication using Tailscale API
- Manages advertised routes and exit node configuration
- Supports automatic route enabling via Tailscale API

## Security Notes

- The role uses `no_log` for sensitive operations involving API keys and authentication
- API keys should be stored securely (e.g., in encrypted Ansible vault)
- One-time authentication keys are generated with minimal privileges

## License

Same as the main project repository
