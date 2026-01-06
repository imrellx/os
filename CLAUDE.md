# ABOUTME: Context file for Claude operating in OS management workspace
# ABOUTME: Defines autonomy tiers, workflow, and key commands

# OS Management Workspace

Command center for managing Ivo's machines via chezmoi.

## Machines

- **Primary**: MacBook (macOS)
- **Secondary**: Linux laptops (Omarchy)
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
chezmoi init            # First-time setup (prompts for profile)
chezmoi apply           # Deploy configs
chezmoi apply --dry-run # Preview changes
chezmoi diff            # Show pending changes
chezmoi edit <file>     # Edit source file
chezmoi add <file>      # Add existing file to management
```

## Installation Profiles

Run `chezmoi init` to select a profile:

| Profile | Includes |
|---------|----------|
| **minimal** | shell, git, starship |
| **developer** | + editors, terminals, multiplexers, file managers, dev tools |
| **full** | + window managers, fonts (110MB) |
| **custom** | Pick each category individually |

Categories:
- **shell**: zsh (macOS) / bash (Linux), starship prompt
- **editors**: nvim (LazyVim), helix
- **terminals**: ghostty, alacritty, wezterm
- **multiplexers**: tmux, zellij
- **file_managers**: yazi, superfile
- **dev_tools**: gh, lazygit, mise
- **window_managers**: aerospace, hyprspace, borders (macOS only)
- **fonts**: 83 font files (~110MB)

## Shell Strategy

- macOS: zsh (`~/.config/zsh/`)
- Linux: bash (`~/.config/bash/`)
- Bootstrap: `~/.zshenv` (macOS) / `~/.bashrc` (Linux) redirect to XDG locations

## Homebrew

Supplementary package manager on both platforms.
- macOS prefix: /opt/homebrew
- Linux prefix: /home/linuxbrew/.linuxbrew

Brewfiles in `inventory/`:
- `Brewfile.common` - Cross-platform CLI tools
- `Brewfile.darwin` - macOS casks, vscode extensions, zsh plugins
- `Brewfile.linux` - Linux-specific (placeholder)
