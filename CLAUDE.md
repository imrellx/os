# ABOUTME: Context file for Claude operating in OS management workspace
# ABOUTME: Defines autonomy tiers, workflow, and key commands

# OS Management Workspace

Command center for managing Ivo's machines. Claude is the executing agent for ALL OS-level tasks.

## Repository Structure

This project spans TWO repositories:

| Repo | Visibility | Contents |
|------|------------|----------|
| `imrellx/os` | **Public** | All configs, scripts, docs, Brewfiles |
| `imrellx/os-private` | **Private** | SSH host configs (`~/.ssh/config.d/*`) |

**How it works:** The public repo contains `.chezmoiexternal.toml` which tells chezmoi to clone `os-private` into `~/.ssh/config.d/` during `chezmoi apply`. This keeps 200+ SSH hosts with internal IPs out of the public repo.

**On new machine setup:**
```bash
chezmoi init imrellx/os    # Clones public repo
chezmoi apply              # Also clones os-private via SSH
```

**SSH config files in private repo:**
- `00-defaults` - 1Password agent, keep-alive settings
- `05-github` - GitHub exclusion from 1Password (for Obsidian sync)
- `10-home` through `37-work-via-jump` - All host definitions

## Session Start

Before doing anything:
1. Search episodic memory for past conversations about this project
2. Read `docs/plans/2026-01-06-os-management-design.md` for full context
3. Understand: this manages the ENTIRE computer, not just dotfiles

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
3. Run `chezmoi apply` (or `chezmoi apply --dry-run` first) if `home/` changed
4. Update inventory if system state changed
5. Update `CHANGELOG.md` under `[Unreleased]`
6. Commit with descriptive message
7. Push to origin

### Depending on What Changed

| Changed | Action |
|---------|--------|
| `home/**` | `chezmoi apply` to deploy |
| `inventory/Brewfile.*` | `brew bundle` or manual `brew install` |
| New external config | `chezmoi add <file>` before editing |
| Inventory/docs only | No deploy needed |

### Autonomy Check
Before making changes, check tier (Green/Yellow/Red above). Propose if yellow/red.

### Common Tasks

**Add a brew package:**
1. Edit appropriate `Brewfile.*` (common/darwin/linux)
2. Changelog → commit → push
3. Optionally run `brew install <pkg>` immediately

**Add a new config to management:**
1. `chezmoi add ~/.config/foo` (copies to `home/`)
2. Edit source in `home/dot_config/foo/` if needed
3. Changelog → commit → push

**Modify existing config:**
1. Edit file in `home/`
2. Changelog → commit → push
3. `chezmoi apply` to deploy

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
