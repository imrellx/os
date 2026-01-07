# ABOUTME: Comprehensive documentation for SSH configuration and tooling
# ABOUTME: Covers config structure, 1Password integration, cssh, and troubleshooting

# SSH Configuration

This document covers the SSH setup managed by this repository, including the modular config structure, 1Password SSH Agent integration, and Cisco device password automation.

## Overview

| Component | Purpose |
|-----------|---------|
| `~/.ssh/config` | Main config with Include directives |
| `~/.ssh/config.d/` | Modular host configs by category |
| 1Password SSH Agent | Key management with biometric unlock |
| `cssh` function | Cisco SSH with 1Password password injection |

## Directory Structure

```
~/.ssh/
├── config                  # Main config (includes config.d/*)
├── config.d/
│   ├── 00-defaults        # Global defaults, 1Password agent
│   ├── 05-github          # GitHub exclusion (for Obsidian sync)
│   ├── 10-home            # Home network devices
│   ├── 20-work-jump       # Jump hosts
│   ├── 30-work-management # Management servers
│   ├── 31-work-iperf      # iPerf servers
│   ├── 32-work-vpn-fw     # VPN and firewalls
│   ├── 33-work-eu         # European sites
│   ├── 34-work-us         # US sites
│   ├── 35-work-ap         # Asia-Pacific sites
│   ├── 36-work-branches   # Branch offices
│   └── 37-work-via-jump   # Devices requiring ProxyJump
├── id_rsa                  # Local SSH key (for GitHub/Obsidian)
└── id_rsa.pub
```

## Config Files

### Main Config (`~/.ssh/config`)

```ssh-config
# OrbStack (must be at top before Host blocks)
Include ~/.orbstack/ssh/config

# Colima
Include /Users/imrellx/.config/colima/ssh_config

# Include all modular configs (loaded in alphabetical order)
Include ~/.ssh/config.d/*
```

**Important:** Include order matters. OrbStack and Colima must come before config.d/* to avoid conflicts.

### Defaults (`00-defaults`)

```ssh-config
Host *
    AddKeysToAgent yes
    IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60
    ServerAliveCountMax 3
    StrictHostKeyChecking accept-new
```

| Setting | Purpose |
|---------|---------|
| `AddKeysToAgent yes` | Auto-add keys to agent on first use |
| `IdentityAgent` | 1Password SSH Agent socket path |
| `IdentityFile` | Fallback local key |
| `ServerAliveInterval 60` | Keep-alive every 60 seconds |
| `ServerAliveCountMax 3` | Disconnect after 3 missed keep-alives |
| `StrictHostKeyChecking accept-new` | Auto-accept new hosts, warn on changes |

### GitHub Exclusion (`05-github`)

```ssh-config
Host github.com
    HostName github.com
    User git
    IdentityAgent none
    IdentityFile ~/.ssh/id_rsa
    IdentitiesOnly yes
```

**Why this exists:** 1Password SSH Agent requires biometric authentication. Background git operations (like Obsidian vault sync) can't prompt for biometrics, causing sync failures. This config uses the local key instead of 1Password for GitHub specifically.

### Jump Hosts (`20-work-jump`)

```ssh-config
Host ssh-srv ssh-ma5
    HostName 10.44.164.20
    User withers

Host ssh-ld5
    HostName 10.44.140.62
    User withers
```

These are bastion/jump hosts used to reach internal network devices.

### ProxyJump Hosts (`37-work-via-jump`)

```ssh-config
Host eu-int-rt01
    HostName 185.137.8.251
    User ivn-admin
    ProxyJump ssh-srv
```

Devices that aren't directly reachable and require jumping through `ssh-srv`.

## Authentication Methods

### Method 1: SSH Keys via 1Password Agent

Used for: Home devices, jump hosts, servers

```bash
ssh ssh-srv  # 1Password prompts for biometric
```

The 1Password SSH Agent handles key storage and signing. Keys never touch disk (except the fallback `id_rsa`).

### Method 2: SSH Keys via Local Key

Used for: GitHub (background operations)

```bash
ssh git@github.com  # Uses ~/.ssh/id_rsa directly
```

### Method 3: Password via cssh

Used for: Cisco devices (routers, switches, firewalls)

```bash
cssh eu-int-rt01  # Fetches password from 1Password, injects via sshpass
```

## cssh Function

### Location

`~/.config/zsh/aliases.zsh` (managed via chezmoi template)

### Implementation

```bash
cssh() {
    if ! command -v op &>/dev/null; then
        echo "1Password CLI (op) not installed"
        return 1
    fi
    sshpass -p "$(op read 'op://work/ivn-admin-n/password')" ssh "$@"
}
```

### How It Works

1. Checks that 1Password CLI (`op`) is installed
2. Reads password from 1Password vault using `op read`
3. Passes password to `sshpass` which injects it into SSH

### 1Password Item Reference

```
op://work/ivn-admin-n/password
     │     │           │
     │     │           └── Field name
     │     └── Item name in 1Password
     └── Vault name
```

### Security Note

The current implementation uses `sshpass -p` which exposes the password in process listings (`ps aux`). A more secure approach uses file descriptors:

```bash
# More secure version (password not in ps output)
cssh() {
    if ! command -v op &>/dev/null; then
        echo "1Password CLI (op) not installed"
        return 1
    fi
    sshpass -d 3 3< <(op read 'op://work/ivn-admin-n/password') ssh "$@"
}
```

See `docs/plans/2026-01-07-ssh-picker-design.md` for the planned upgrade.

## 1Password SSH Agent

### Setup

1. **Enable in 1Password:**
   - Settings → Developer → SSH Agent → Enable

2. **Socket Path (macOS):**
   ```
   ~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock
   ```

3. **Configure SSH:**
   Already done in `00-defaults`:
   ```ssh-config
   IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
   ```

### Adding Keys to 1Password

1. Open 1Password
2. Create new "SSH Key" item
3. Paste private key or generate new
4. Key appears in `ssh-add -l` when agent is unlocked

### Troubleshooting

| Problem | Solution |
|---------|----------|
| "Permission denied (publickey)" | 1Password locked. Click 1Password icon to unlock. |
| Agent not found | Check socket path exists: `ls -la ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/` |
| Wrong key offered | Check `IdentitiesOnly yes` for specific hosts |

## 1Password CLI (`op`)

### Installation

```bash
brew install --cask 1password-cli
```

### Authentication

```bash
op signin  # Follow prompts, or use biometric
```

### Common Commands

```bash
# List vaults
op vault list

# List items in a vault
op item list --vault work

# Read a specific field
op read 'op://work/ivn-admin-n/password'

# Get full item as JSON
op item get 'ivn-admin-n' --vault work --format json
```

## Source of Truth

All SSH configs are managed via chezmoi:

```
os/home/dot_ssh/
├── config                 → ~/.ssh/config
└── config.d/
    ├── 00-defaults       → ~/.ssh/config.d/00-defaults
    ├── 05-github         → ~/.ssh/config.d/05-github
    └── ...
```

### Editing Workflow

1. Edit source in `os/home/dot_ssh/config.d/`
2. Run `chezmoi apply` to deploy
3. Test connection
4. Commit changes to git

### Adding New Hosts

1. Determine category (home, work-jump, work-via-jump, etc.)
2. Edit appropriate file in `os/home/dot_ssh/config.d/`
3. Add host block:
   ```ssh-config
   Host new-device
       HostName 10.0.0.1
       User admin
       # OP: op://work/item-name/password  # If password auth needed
   ```
4. `chezmoi apply`
5. Test: `ssh new-device` or `cssh new-device`

## Origin

The 200+ hosts were extracted from a Royal TSX export file (`.rtsz` format, which is XML). Categories were determined by folder structure in Royal TSX:
- Home → `10-home`
- Work/Jump → `20-work-jump`
- Work/Network/EU → `33-work-eu`
- Work/Network/Via-Jump → `37-work-via-jump`
- etc.

## Related Files

| File | Purpose |
|------|---------|
| `home/dot_ssh/` | SSH config source (chezmoi) |
| `home/dot_config/zsh/aliases.zsh.tmpl` | cssh function |
| `docs/plans/2026-01-07-ssh-picker-design.md` | SSH picker design |
| `CHANGELOG.md` | Change history |

## Future Work

- **SSH Picker (`sp`)**: fzf-based host selection with tmux integration
- **Auto-detect cssh**: Based on `# OP:` comment in config
- **Secure password passing**: `sshpass -d` instead of `-p`
- **Session management**: Named tmux sessions for SSH connections
