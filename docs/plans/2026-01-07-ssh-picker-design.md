# ABOUTME: Design document for SSH host picker with tmux integration
# ABOUTME: fzf-based picker with 1Password password injection for Cisco devices

# SSH Picker Design

## Overview

A shell-based SSH host picker for 200+ managed devices. Provides fuzzy search, multi-select, tmux integration, and automatic password injection via 1Password for Cisco devices.

## Problem

- 200+ SSH hosts across multiple config files
- Similar hostnames (differ by 1-2 characters) make typos common
- Mix of key-based auth (home, jump hosts) and password-based auth (Cisco devices)
- Need to connect to multiple devices simultaneously for troubleshooting
- Current workflow requires remembering exact hostnames

## Solution

A `sp` (ssh-pick) function that:
1. Parses SSH configs for hostname + IP
2. Presents fzf picker with preview
3. Handles single or multi-select
4. Auto-detects auth method from config comments
5. Opens in tmux with chosen layout

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  sp (shell function)                                        │
│  ├─> Parse ~/.ssh/config.d/* for Host + HostName            │
│  ├─> fzf --multi with preview and keybindings               │
│  ├─> Detect auth method from # OP: comment                  │
│  └─> Execute ssh or cssh in tmux                            │
└─────────────────────────────────────────────────────────────┘
```

## Authentication Detection

### Previous Approach (Rejected)
Auto-detect by username (`ivn-admin`, `withers`, `admin` → password auth).

**Problems:**
- New usernames require script updates
- Implicit/magical behavior
- Different hosts with same user might have different auth

### Chosen Approach: Explicit Config Comments

Add `# OP:` marker to SSH config for hosts requiring 1Password:

```ssh-config
Host eu-int-rt01
    HostName 185.137.8.251
    User ivn-admin
    ProxyJump ssh-srv
    # OP: op://work/ivn-admin-n/password
```

**Benefits:**
- Self-documenting
- Explicit over implicit
- Different items per host if needed
- No script updates for new usernames

### Password Security

Use `sshpass -d` (file descriptor) instead of `-p` (argument):

```bash
# BAD: Password visible in `ps` output
sshpass -p "$(op read '...')" ssh $host

# GOOD: Password via file descriptor, never in process list
sshpass -d 3 3< <(op read '...') ssh $host
```

## User Interface

### fzf Display

```
┌─────────────────────────────────────────────────────────────┐
│ > eu-int                                                    │
├─────────────────────────────────────────────────────────────┤
│ > eu-int-rt01 (185.137.8.251)      │ Host eu-int-rt01      │
│   eu-int-rt02 (185.137.8.252)      │     HostName 185...   │
│   us-int-rt01 (185.137.11.251)     │     User ivn-admin    │
│   us-int-rt02 (185.137.11.252)     │     ProxyJump ssh-srv │
│   ap-int-rtr01 (185.137.9.251)     │     # OP: op://work/  │
└─────────────────────────────────────────────────────────────┘
  Enter: window | C-t: tiled | C-s: sync | C-p: pane | Tab: multi
```

### Keybindings

| Key | Action | Description |
|-----|--------|-------------|
| `Enter` | New window | Opens SSH in new tmux window |
| `Ctrl-t` | Tiled | Multi-select → tiled panes |
| `Ctrl-s` | Sync | Multi-select → synchronized input |
| `Ctrl-p` | Current pane | Opens in current pane |
| `Tab` | Toggle select | Multi-select hosts |
| `Ctrl-c` | Cancel | Exit without connecting |

### Access Points

1. **Shell function**: `sp` or `sp <search-term>`
2. **tmux keybinding**: `C-a S` (capital S)

## Implementation

### Components

1. **Host parser**: Extract Host/HostName/OP from config.d/*
2. **fzf wrapper**: Multi-select, preview, keybindings
3. **Auth handler**: Determine ssh vs sshpass based on OP comment
4. **tmux launcher**: Create window/pane with appropriate layout

### Pseudocode

```bash
sp() {
    # Parse hosts
    hosts=$(parse_ssh_configs)

    # fzf selection with keybindings
    selected=$(echo "$hosts" | fzf \
        --multi \
        --preview 'show_host_details {}' \
        --bind 'enter:accept' \
        --bind 'ctrl-t:accept+execute(echo TILED)' \
        --bind 'ctrl-s:accept+execute(echo SYNC)' \
        --bind 'ctrl-p:accept+execute(echo PANE)')

    # Determine layout from keybinding
    layout=$(detect_layout)

    # For each selected host
    for host in $selected; do
        op_ref=$(get_op_reference "$host")
        if [[ -n "$op_ref" ]]; then
            cmd="sshpass -d 3 3< <(op read '$op_ref') ssh $host"
        else
            cmd="ssh $host"
        fi

        # Launch in tmux based on layout
        case $layout in
            window) tmux new-window "$cmd" ;;
            tiled)  tmux split-window "$cmd"; tmux select-layout tiled ;;
            sync)   # ... synchronized panes
            pane)   eval "$cmd" ;;
        esac
    done
}
```

### Config Migration

Existing hosts in `37-work-via-jump` and similar need `# OP:` comments added:

```bash
# One-time migration script
for file in ~/.ssh/config.d/3*; do
    sed -i '' 's/User ivn-admin$/User ivn-admin\n    # OP: op:\/\/work\/ivn-admin-n\/password/' "$file"
done
```

## Error Handling

| Scenario | Behavior |
|----------|----------|
| 1Password locked | Error: "1Password locked. Run `op signin` first." |
| OP item not found | Error: "1Password item not found: <ref>" |
| Host unreachable | SSH handles this (timeout) |
| No hosts selected | Silent exit |
| tmux not running | Fall back to direct SSH |

## Files Changed

| File | Change |
|------|--------|
| `home/dot_config/zsh/aliases.zsh.tmpl` | Add `sp` function |
| `home/dot_config/tmux/tmux.conf.tmpl` | Add `C-a S` keybinding |
| `home/dot_ssh/config.d/3*` | Add `# OP:` comments |
| `CHANGELOG.md` | Document changes |

## Future Enhancements

- **Session naming**: `ssh-<hostname>` for easy identification
- **Session cleanup**: Command to kill orphaned SSH sessions
- **History**: Track recently connected hosts for quick access
- **Groups**: Connect to predefined groups (all-eu-routers, all-firewalls)

## Decision Log

| Decision | Rationale |
|----------|-----------|
| Custom script over sshmx | Need cssh integration, full control |
| `# OP:` over username detection | Explicit > implicit, self-documenting |
| `sshpass -d` over `-p` | Security: password not in process list |
| fzf keybindings over prompts | Smoother UX, single interaction |
