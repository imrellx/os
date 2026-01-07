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
| `C-p` | Add as pane in **current** window |
| `C-t` | Connect in tiled panes (new window) |
| `C-s` | Connect with synchronized input (new window) |
| `Tab` | Toggle multi-select |
| `Shift-Tab` | Toggle and move up |

**C-t vs C-s:** Both create tiled panes. With C-t, each pane is independent. With C-s, keystrokes go to ALL panes simultaneously - useful for running the same command on multiple hosts.

### Features

- Parses all hosts from `~/.ssh/config.d/`
- Shows preview of SSH config for selected host
- Multi-select for bulk connections
- Tiled layout auto-arranges panes
- Sync mode types to all panes simultaneously
- Auto-detects password auth via `# OP:` markers

### Examples

```bash
# Single host - new window
C-a S → type "ftd" → Enter

# Add host as pane beside current session (for troubleshooting)
C-a S → type "srv" → C-p

# Multiple hosts - tiled panes in new window
C-a S → Tab on each host → C-t

# Multiple hosts - synchronized typing
C-a S → Tab on each host → C-s
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
│  C-a S           → SSH picker popup (CAPITAL S)         │
│  sp              → SSH picker (shell)                   │
│  cssh <host>     → Cisco SSH with 1Password             │
├─────────────────────────────────────────────────────────┤
│  SSH PICKER ACTIONS                                      │
├─────────────────────────────────────────────────────────┤
│  Enter           → New window                           │
│  C-p             → Pane in current window               │
│  C-t             → Tiled panes (new window)             │
│  C-s             → Synced panes (new window)            │
│  Tab             → Multi-select                         │
├─────────────────────────────────────────────────────────┤
│  TMUX BASICS                                             │
├─────────────────────────────────────────────────────────┤
│  C-a c           → New window                           │
│  C-a |           → Split horizontal                     │
│  C-a -           → Split vertical                       │
│  C-a g           → Lazygit                              │
│  C-a p           → Floating pane (floax)                │
│  C-a Space       → Last window                          │
│  C-a b           → Last session                         │
├─────────────────────────────────────────────────────────┤
│  PANE LAYOUTS (rearrange after opening)                  │
├─────────────────────────────────────────────────────────┤
│  C-a M-1         → Even horizontal (side by side)       │
│  C-a M-2         → Even vertical (stacked)              │
│  C-a M-3         → Main horizontal                      │
│  C-a M-4         → Main vertical                        │
│  C-a M-5         → Tiled                                │
└─────────────────────────────────────────────────────────┘
```

**Note:** `M-1` means Meta+1, which is `Alt+1` (or `Option+1` on Mac).

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
