# ABOUTME: Comprehensive guide to session management and SSH tools
# ABOUTME: Covers sesh, sessionx, tmuxinator, sp picker, and SSH configuration

# Session Management & SSH Guide

Quick reference for all session and SSH tools configured in this system.

## Overview

| Tool | Purpose | Trigger |
|------|---------|---------|
| **sesh** | Smart tmux session manager with zoxide | `ss` in shell |
| **sessionx** | Fuzzy session picker inside tmux | `C-a o` |
| **tmuxinator** | Predefined session layouts | `mux <template>` or `C-a o` then `C-t` |
| **sp** | SSH host picker with multi-select | `C-a S` (capital S) or `sp` in shell |
| **cssh** | Cisco SSH with 1Password auto-auth | `cssh <host>` |
| **sshc/sshn** | Colored/normal SSH aliases | `sshc <host>` or `sshn <host>` |

---

## Sesh (Session Manager)

Smart tmux session management with zoxide integration.

### Usage

```bash
ss              # Interactive picker with preview
ss <name>       # Jump to or create session
sesh connect    # Same as ss
```

### Configured Sessions

From `~/.config/sesh/sesh.toml`:

| Name | Path | Description |
|------|------|-------------|
| o-vault | ~/Library/.../vault-002 | Obsidian vault |
| v-vault | ~/Library/.../vault-002 | Neovim in vault |
| o-family | ~/Library/.../family-vault | Family vault |
| v-family | ~/Library/.../family-vault | Neovim in family vault |
| os | ~/Code/personal/os | This config repo |
| pai | ~/Code/personal/pai-config | PAI config repo |

### Key Features

- Zoxide integration (frecency-based directory jumping)
- Automatic session creation if doesn't exist
- Preview shows session windows/panes

---

## Sessionx (tmux plugin)

Fuzzy session manager that runs inside tmux.

### Keybindings

| Key | Action |
|-----|--------|
| `C-a o` | Open sessionx picker |
| `C-t` | Show tmuxinator templates (inside picker) |
| `Enter` | Switch to selected session |
| `C-d` | Delete session |

### Configuration

From `tmux.conf`:
- Window size: 85% x 75%
- Zoxide mode: enabled
- Tmuxinator integration: enabled
- Config path: `~/.config`

---

## Tmuxinator (Layout Templates)

Predefined window/pane layouts for common workflows.

### Usage

```bash
mux <template>           # Start template
mux start <template>     # Same
mux list                 # List available templates
mux edit <template>      # Edit template
mux new <template>       # Create new template
```

### Available Templates

Located in `~/.config/tmuxinator/`:

| Template | Windows | Purpose |
|----------|---------|---------|
| lab | editor, terminal, server | Development environment |
| troubleshoot | logs, ssh, tools | Debugging setup |
| ssh-multi | Dynamically created | Multi-host SSH sessions |

### From Sessionx

Inside `C-a o` picker, press `C-t` to list and launch tmuxinator templates.

---

## SP (SSH Picker)

Interactive SSH host picker with fzf, multi-select, and tmux integration.

### Keybindings

| Key | Action |
|-----|--------|
| `C-a S` | Open SSH picker popup (capital S!) |
| `sp` | Run picker in current shell |
| `sp <query>` | Pre-filter by query |

### Inside the Picker

| Key | Action |
|-----|--------|
| `Enter` | Connect in new tmux window |
| `C-p` | Pane mode (see below) |
| `C-t` | Tiled panes in new window |
| `C-s` | Synced panes in new window |
| `Tab` | Toggle multi-select |
| `Shift-Tab` | Toggle and move up |

**C-p behavior:**
- **1 host selected:** Adds pane to your **current** window (great for troubleshooting side-by-side)
- **2+ hosts selected:** Creates **new** window with just those hosts

**C-t vs C-s:** Both create tiled panes in a new window. With C-t, each pane is independent. With C-s, keystrokes go to ALL panes simultaneously - useful for running the same command on multiple hosts.

**Window naming:** Multi-host windows show the first hostname + mode (e.g., `srv+tiled`, `pihole+sync`).

### Features

- Parses all hosts from `~/.ssh/config.d/`
- Shows preview of SSH config for selected host
- Multi-select for bulk connections
- Tiled layout auto-arranges panes
- Sync mode types to all panes simultaneously
- Auto-detects password auth via `# OP:` markers

### Examples

```bash
# Single host → new window
C-a S → type "ftd" → Enter

# Single host → add as pane beside current session (troubleshooting)
C-a S → type "srv" → C-p

# Two hosts → side-by-side panes in new window
C-a S → Tab on pihole → Tab on nas → C-p

# Multiple hosts → tiled panes (each independent)
C-a S → Tab on each host → C-t

# Multiple hosts → synced panes (type once, runs on all)
C-a S → Tab on each host → C-s

# After opening panes, rearrange layout
C-a L → keep pressing until layout looks right
```

---

## CSSH (Cisco SSH)

SSH wrapper that auto-authenticates using 1Password CLI.

### Usage

```bash
cssh <hostname>                    # Uses default credential
CSSH_OP_REF="op://vault/item/field" cssh <host>  # Custom credential
```

### How It Works

1. Reads password from 1Password via `op read`
2. Passes to `sshpass` via file descriptor (secure, not visible in `ps`)
3. Connects via SSH

### Default Credential

`op://vault/item/password`

Override with `CSSH_OP_REF` environment variable.

---

## Syntax Highlighting (ChromaTerm)

SSH sessions to network devices support Cisco IOS syntax highlighting via ChromaTerm.

### Installation

ChromaTerm must be installed separately (not in Brewfile):

```bash
uv tool install chromaterm
```

This adds the `ct` command to `~/.local/bin/` (in PATH via mise/uv setup).

### How It Works

When `ct` is available, these tools automatically wrap SSH with ChromaTerm:
- `sp` picker (both shell function and standalone script)
- `cssh` function

### Usage

Highlighting is **automatic** when ChromaTerm is installed. For explicit control:

```bash
sshc <host>      # Colored SSH (forces ChromaTerm)
sshn <host>      # Normal SSH (no color)
```

### Customization

Config file: `~/.chromaterm.yml`

Includes patterns for:
- Interface headers, descriptions
- VLANs (access, voice, native, allowed)
- Spanning-tree (portfast, bpduguard)
- IP/IPv6 addresses, MAC addresses
- Status indicators (up/down/shutdown)
- Routing protocols (BGP, EIGRP, OSPF states)
- ACLs, route-maps, prefix-lists
- VRF, PoE, trunk configuration

Color scheme: Jellybeans-Flexoki (matches terminal/tmux theme).

---

## SSH Configuration

Modular SSH config in `~/.ssh/config.d/`:

| File | Purpose |
|------|---------|
| 00-defaults | Global settings, 1Password agent |
| 05-github | GitHub exclusion from 1Password |
| 10-home | Home network devices |
| 20-work-jump | Jump hosts |
| 30-work-management | Management systems (FMC, DNA, ISE, etc.) |
| 32-work-vpn-fw | VPN concentrators and firewalls |
| 35-work-network | Direct network devices |
| 37-work-via-jump | Devices requiring ProxyJump |

### Password Auth Markers

Hosts with password authentication have this marker:
```
Host example
    HostName 10.x.x.x
    User admin
    # OP: op://vault/item/password
```

The `sp` picker reads these markers to automatically use `cssh` (sshpass) for connection.

### 1Password SSH Agent

Configured in `00-defaults`:
```
Host *
    IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
```

GitHub is excluded (in `05-github`) to allow Obsidian background sync without prompts.

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────┐
│  SESSION MANAGEMENT                                      │
├─────────────────────────────────────────────────────────┤
│  ss              → Sesh picker (shell)                  │
│  C-a o           → Sessionx picker (tmux)               │
│  C-a o → C-t     → Tmuxinator templates                 │
│  mux <name>      → Start tmuxinator template            │
├─────────────────────────────────────────────────────────┤
│  SSH CONNECTIONS                                         │
├─────────────────────────────────────────────────────────┤
│  C-a S           → SSH picker popup (CAPITAL S!)        │
│  sp              → SSH picker (shell)                   │
│  cssh <host>     → Cisco SSH with 1Password             │
│  sshc <host>     → Colored SSH (ChromaTerm)             │
│  sshn <host>     → Normal SSH (no color)                │
├─────────────────────────────────────────────────────────┤
│  SSH PICKER (inside C-a S)                               │
├─────────────────────────────────────────────────────────┤
│  Enter           → New window                           │
│  C-p (1 host)    → Pane in current window               │
│  C-p (2+ hosts)  → New window with just those hosts     │
│  C-t             → Tiled panes (independent)            │
│  C-s             → Synced panes (type to all)           │
│  Tab             → Multi-select hosts                   │
├─────────────────────────────────────────────────────────┤
│  WINDOWS                                                 │
├─────────────────────────────────────────────────────────┤
│  C-a c           → New window                           │
│  C-a n / C-a p   → Next / previous window               │
│  C-a Space       → Last window (toggle)                 │
│  C-a 1-9         → Jump to window by number             │
│  C-a ,           → Rename window                        │
├─────────────────────────────────────────────────────────┤
│  PANES                                                   │
├─────────────────────────────────────────────────────────┤
│  C-a |           → Split horizontal (side by side)      │
│  C-a -           → Split vertical (top/bottom)          │
│  C-a h/j/k/l     → Navigate panes (vim-style)           │
│  C-a L           → Cycle layouts (keep pressing)        │
│  C-a z           → Zoom pane (toggle fullscreen)        │
│  C-a x           → Kill pane                            │
├─────────────────────────────────────────────────────────┤
│  SESSIONS                                                │
├─────────────────────────────────────────────────────────┤
│  C-a b           → Last session (toggle)                │
│  C-a d           → Detach from session                  │
│  C-a $           → Rename session                       │
├─────────────────────────────────────────────────────────┤
│  OTHER                                                   │
├─────────────────────────────────────────────────────────┤
│  C-a r           → Reload tmux config                   │
│  C-a g           → Lazygit                              │
│  C-a p           → Floating pane (floax)                │
│  C-a I           → Install TPM plugins                  │
└─────────────────────────────────────────────────────────┘
```

**Split mnemonics:** `|` is a vertical line → splits left/right. `-` is a horizontal line → splits top/bottom.

---

## Troubleshooting

### SSH picker shows 0 results

- Make sure you're pressing `C-a S` (capital S, i.e., `Ctrl-a Shift-s`)
- Lowercase `s` does something else in tmux

### SSH picker shows file listings

- The `--bind start:reload` fix should handle this
- If still broken, run `SP_DEBUG=1 sp` and check `/tmp/sp-debug.log`

### Password auth fails

- Check the `# OP:` marker matches a valid 1Password reference
- Test manually: `op read "op://work/admin-n/password"`
- Ensure `sshpass` is installed: `brew install sshpass`

### Sessionx not working

- Reload tmux config: `C-a r`
- Check plugin installed: `~/.config/tmux/plugins/tmux-sessionx/`
- Run TPM install: `C-a I`
