# ABOUTME: Design document for OS management workspace
# ABOUTME: Defines structure, tools, and workflows for multi-machine config management

# OS Management Design

**Date:** 2026-01-06
**Status:** Approved

## Overview

This repository serves as the command center for managing Ivo's machines. Claude operates as the executing agent for all OS-level tasks, with configs managed via chezmoi and packages via Homebrew.

## Machines

- **Primary**: MacBook (macOS)
- **Secondary**: Linux laptops (Ubuntu, Omakub)
- **Ephemeral**: VMs as needed

## Key Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Dotfiles manager | Chezmoi | Templates for multi-OS, single binary bootstrap, secrets support |
| Package manager | Homebrew | Cross-platform consistency, supplementary to native on Linux |
| Autonomy model | Tiered (green/yellow/red) | Balance speed with safety |
| Change tracking | Git + CHANGELOG.md | Technical record + human-readable summary |
| State capture | Living inventory files | Can regenerate from reality, detect drift |

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

## Folder Structure

```
os/
├── CLAUDE.md                    # Context for Claude
├── CHANGELOG.md                 # Human-readable history
├── .chezmoi.toml.tmpl           # Chezmoi config (machine-specific vars)
│
├── home/                        # Chezmoi source directory
│   ├── .chezmoiignore           # What to skip per platform
│   ├── dot_zshrc.tmpl           # → ~/.zshrc (macOS)
│   ├── dot_bashrc.tmpl          # → ~/.bashrc (Linux)
│   ├── dot_gitconfig.tmpl       # → ~/.gitconfig
│   └── dot_config/              # → ~/.config/
│       └── shell/
│           └── common.sh        # Shared shell config
│
├── inventory/                   # System state snapshots
│   ├── Brewfile                 # Homebrew packages (both platforms)
│   ├── Brewfile.macos           # macOS-only casks/formulae
│   ├── Brewfile.linux           # Linux-specific if needed
│   ├── runtimes.md              # Language versions
│   ├── apps.md                  # Non-Homebrew apps
│   └── system-info.md           # Hardware, OS version, etc.
│
├── scripts/                     # Automation
│   ├── bootstrap.sh             # Initial machine setup
│   ├── snapshot.sh              # Regenerate inventory from reality
│   └── doctor.sh                # Health check / diagnostics
│
└── docs/
    ├── plans/                   # Design documents
    └── audit-YYYY-MM-DD.md      # Audit reports
```

## Chezmoi Configuration

Machine-specific variables defined in `.chezmoi.toml.tmpl`:

- `email` - User email address
- `machine_type` - "personal" or "work"
- `include_dev_tools` - Boolean for dev tool inclusion
- `homebrew_prefix` - Auto-detected per OS

Templates use these for conditional configuration.

## Bootstrap Process

New machine setup:

```bash
# Full bootstrap (Homebrew + chezmoi + configs)
curl -fsSL https://raw.githubusercontent.com/imrellx/os/main/scripts/bootstrap.sh | bash
```

Or manually:

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install chezmoi and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply imrellx

# 3. Install packages
brew bundle --file=~/Code/personal/os/inventory/Brewfile
```

## Workflow

### Making changes

1. Check tier, propose if yellow/red
2. Make changes in repo
3. Run `chezmoi apply` (or `--dry-run` first)
4. Update inventory if system state changed
5. Commit with descriptive message
6. Update CHANGELOG.md

### Key commands

```bash
chezmoi apply           # Deploy configs
chezmoi apply --dry-run # Preview changes
chezmoi diff            # Show pending changes
chezmoi edit <file>     # Edit source file
chezmoi add <file>      # Add existing file to management
```

## Changelog Format

Follows Keep a Changelog conventions:

- **Added** - New packages, configs, scripts
- **Changed** - Modifications to existing configs
- **Removed** - Uninstalled packages, deleted configs
- **Fixed** - Bug fixes, corrections
- **Platform** - Note [macOS], [Linux], or [All] when relevant

## Initial Audit Plan

Priority order:

1. Homebrew - Installed formulae, casks, taps
2. Shell - zsh config, aliases, functions, PATH
3. Dev tools - Node, Python, Ruby versions + managers
4. Git - Global config, aliases, signing setup
5. Dotfiles - ~/.config/ contents mapping
6. Apps - Non-Homebrew applications
7. macOS - Relevant defaults, preferences

## Future Considerations

- Secrets management via chezmoi + 1Password/Bitwarden if needed
- Potential Deciduous integration for decision tracking
- Machine-specific Brewfiles as inventory grows
