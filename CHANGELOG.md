# ABOUTME: Human-readable changelog for OS configuration changes
# ABOUTME: Follows Keep a Changelog format with platform annotations

# Changelog

All notable changes to this system configuration.

Format: [Keep a Changelog](https://keepachangelog.com/)

## [Unreleased]

### Added
- macOS defaults script with current non-default settings (`scripts/macos-defaults.sh`) [macOS]
- Chezmoi run_once script for Homebrew package installation (`run_once_after_brew-bundle.sh.tmpl`)
- Zig to mise config

### Fixed (ZSH config overhaul)
- STARSHIP_CONFIG now exported before starship init (was ignored)
- EDITOR changed from nonexistent 'vl' to 'nvim'
- Removed missing notificator script reference from homebrew.zsh
- Removed dangerous undopush alias (force push to master)
- Consolidated duplicate .env loading (now only in .zshrc with comment handling)
- Moved history settings from .zshenv to .zshrc (interactive shell only)
- Moved pandoc alias from .zshenv to aliases.zsh
- Simplified locale settings (removed redundant LC_* exports)
- Cleaned up dead commented code in .zshrc
- Removed unused utils_dir variable and empty utils/ directory
- Consolidated duplicate cc/cc-start aliases into cc and ccc

### Removed
- Original monolithic Brewfile (now split into common/darwin/linux overlays)
- Deprecated Homebrew casks: alacritty, chromium, syntax-highlight
- Backup files from ~/.config/zsh/ (aliases copy.zsh, titus-bashrc)

### Fixed
- Linked unlinked `container` keg in Homebrew

### Infrastructure
- Published repo to GitHub (public): https://github.com/imrellx/os

## 2026-01-06

### Added
- Initial repository structure
- Design document for OS management approach
- CLAUDE.md with autonomy tiers and workflow
- Folder structure for chezmoi, inventory, scripts, docs
- System audit documenting current state (193 formulae, 45 casks, 50+ configs)
- Brewfile generated from current Homebrew state
- Complete application inventory with usage status (~25 essential, ~10 to remove)

### Changed
- Simplified neovim to single config (LazyVim only, removed nvim-astrovim, nvim-adibhanna, nvim-cpplain)
- Primary browser changed from Arc to Chrome (Zen as backup)

### Infrastructure
- Installed and configured chezmoi (source: os/home/)
- Migrated to chezmoi: zsh, starship, git, mise configs
- Migrated to chezmoi: ghostty, nvim (LazyVim), tmux, lazygit, aerospace, hyprspace
- Migrated to chezmoi: fonts (83 files), gh, wezterm, alacritty, borders, yazi, superfile, zellij
- Added cross-platform templates for homebrew.zsh, aliases.zsh, ghostty, tmux, alacritty, wezterm
- Added run_once script for platform-specific font installation
- Added interactive profile selection (minimal/developer/full/custom) at `chezmoi init`
- Created .chezmoiignore for platform-specific deployments
- Added bash configs for Linux (aliases.bash, homebrew.bash, .bashrc)
- Split Brewfile into common + darwin + linux overlays
- Shell separation: zsh on macOS, bash on Linux (Omarchy)

---

## Format Guide

- **Added** - New packages, configs, scripts
- **Changed** - Modifications to existing configs
- **Removed** - Uninstalled packages, deleted configs
- **Fixed** - Bug fixes, corrections
- **Platform** - Note [macOS], [Linux], or [All] when relevant
