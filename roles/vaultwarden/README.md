# Vaultwarden Role

This Ansible role installs and configures [Vaultwarden](https://github.com/dani-garcia/vaultwarden), a lightweight alternative to the official Bitwarden server implementation, with PostgreSQL backend and automated backup capabilities.

## Requirements

- Ansible 2.9 or higher
- Docker with Compose plugin
- PostgreSQL database (automatically set up by the role)
- Target system with internet access

## Role Variables

Optional variables:
- `vaultwarden_allow_signups`: Allow new user registrations (default: true)
- `vaultwarden_show_password_hint`: Enable password hint display (default: false)

## Dependencies

None

## Example Playbook

```yaml
- hosts: servers
  roles:
    - role: vaultwarden
      vars:
        vaultwarden_allow_signups: false  # Disable new registrations
        vaultwarden_show_password_hint: true
```

## Features

- Automated PostgreSQL database setup and Docker deployment
- Automatic backup system integration
- User registration control
- Password hint toggle
- Secure default configuration

## Accessing the Server

Once deployed, Vaultwarden will be available at `https://vaultwarden.yourdomain.com`. You can:
1. Create an initial admin account if signups are enabled
2. Use any Bitwarden client (mobile, desktop, browser extension) by pointing it to your server URL
3. Disable signups after creating needed accounts

## Security Notes

- Database credentials are automatically generated and secured
- Passwords and sensitive data are stored securely in PostgreSQL
- Registration can be disabled after initial setup
- Automatic backups ensure data safety

## License

Same as the main project repository
