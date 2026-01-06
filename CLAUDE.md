# ABOUTME: Context file for Claude operating in OS management workspace
# ABOUTME: Defines autonomy tiers, workflow, and key commands

# OS Management Workspace

Command center for managing Ivo's machines via chezmoi.

## Machines

- **Primary**: MacBook (macOS)
- **Secondary**: Linux laptops (Ubuntu, Omakub)
- **Ephemeral**: VMs as needed

## Autonomy Tiers

### Green (execute and log)
- Edit files within this repo
- Run `chezmoi apply`
- Install/update Homebrew packages
- Run non-destructive commands
- Update inventory files

### Yellow (propose first)
- `defaults write` (macOS preferences)
- Edit templates affecting external files
- Install outside Homebrew
- Anything requiring `sudo`
- Remove/uninstall packages

### Red (explain thoroughly, explicit confirmation)
- Security settings (Keychain, SSH)
- System-level changes (launchd, kernel)
- Destructive operations
- Network configuration

## Workflow

1. Check tier, propose if yellow/red
2. Make changes in repo
3. Run `chezmoi apply` (or `chezmoi apply --dry-run` first)
4. Update inventory if system state changed
5. Commit with descriptive message
6. Update CHANGELOG.md

## Key Commands

```bash
chezmoi apply           # Deploy configs
chezmoi apply --dry-run # Preview changes
chezmoi diff            # Show pending changes
chezmoi edit <file>     # Edit source file
chezmoi add <file>      # Add existing file to management
```

## Inventory

Living snapshots in `inventory/`. Update when system changes.
Regenerate with `scripts/snapshot.sh`.

## Shell Strategy

- macOS: zsh (dot_zshrc.tmpl)
- Linux: bash (dot_bashrc.tmpl) or zsh where available
- Shared config: dot_config/shell/common.sh (sourced by both)

## Homebrew

Supplementary package manager on both platforms.
- macOS prefix: /opt/homebrew
- Linux prefix: /home/linuxbrew/.linuxbrew

Brewfiles in `inventory/`:
- `Brewfile` - Cross-platform packages
- `Brewfile.macos` - macOS-only (casks, etc.)
- `Brewfile.linux` - Linux-specific if needed
