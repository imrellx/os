# ABOUTME: Human-readable changelog for OS configuration changes
# ABOUTME: Follows Keep a Changelog format with platform annotations

# Changelog

All notable changes to this system configuration.

Format: [Keep a Changelog](https://keepachangelog.com/)

## [Unreleased]

### Changed
- chromaterm: direct translation from vscode-cisco-config-highlight (Y-Ysss)
  - Complete rewrite following tmLanguage.json structure (12 sections)
  - Colors match VS Code extension exactly:
    - Interface names: Green (#99ad6a)
    - IOS command keywords: Cyan (#8fbfdc)
    - IP addresses: Light blue (#8197bf)
    - MAC addresses: Purple (#c6b6ee)
    - Numbers: Bright gold (#ffaf00)
    - permit/up: Green | deny/shutdown/down: Red
    - native/voice: Red (#cf6a4c)
    - Switchport modes (trunk/access): Gold (#dad085)
    - Description/remark text: Gold (#dad085)
    - Comments: Gray italic (#888888)
  - 20 interface types including modern variants (HundredGigE, TwentyFiveGigE, AppGigabitEthernet, NVE, BD-VIF, VASI)
  - Named object highlighting (route-map, policy-map, class-map, access-list, crypto, BGP peer-group)
  - Routing protocol states (BGP Established/Idle, OSPF FULL/DOWN, STP FWD/BLK)
  - Error message patterns (%Invalid input, %Incomplete command)
  - Fixed Python regex limitations (variable-width lookbehinds split into fixed-width patterns)

### Added
- docs/pai/: PAI customizations documentation (CHANGELOG.md, fixes-2026-01-16.md, custom-skills.md)
- CLAUDE.md: comprehensive rewrite with full repo documentation (430 lines)
- Brewfile.darwin: devpod (dev container management for stateless workstation workflow)
- docs/plans: devcontainer-workflow-design.md (stateless workstation architecture)
- Brewfile.darwin: kitlangton-hex (Hex voice-to-text transcription tool)
- tmux: extended-keys configuration for modifier key passthrough (`extended-keys always`, `extended-keys-format csi-u`)
- ghostty: Shift+Enter keybind sends CSI u sequence for Claude Code multi-line input in tmux
- wezterm: Shift+Enter keybind sends CSI u sequence for Claude Code multi-line input in tmux
- tmux: flexoki-tmux theme plugin (fork of yukinord-tmux with Flexoki dark colors)
- tmux: tmux-prefix-highlight plugin (visual indicator when prefix key is active)
- tmux: jellybeans-tmux theme plugin (fork of tokyo-night-tmux with jellybeans-flexoki colors)
- tmux: jellybeans-tmux powerline separators (pill-shaped status elements with `` and ``)
- tmux: jellybeans-tmux teal accent color (`#2DA099`) matching lualine aesthetic
- tmux: jellybeans-tmux OS icon (auto-detected Apple/Linux/Windows)
- tmux: jellybeans-tmux git status widget with branch icon and sync status
- tmux: themes directory with jellybeans, flexoki-dark, and jellybeans-flexoki palettes
- Brewfile.common: sesh (smart tmux session manager with zoxide integration)
- tmux: tmux-sessionx plugin (fuzzy session manager with preview, `C-a o`)
- tmux: tmux-floax plugin (floating pane scratchpad, `C-a p`)
- tmux: sessionx x-path (~/.config)
- sesh: config with named sessions (o-vault, v-vault, o-family, v-family, os, pai)
- zsh: `ss` function for sesh with fzf picker and preview
- Brewfile.common: tmuxinator (session layout manager)
- tmuxinator: starter templates (lab, troubleshoot, ssh-multi)
- tmux: sessionx tmuxinator integration (`Ctrl-t` to list templates)
- ssh: modular `~/.ssh/config.d/` structure with Include directive
- ssh: `00-defaults` with 1Password SSH Agent, keep-alive, accept-new hostkeys
- ssh: `05-github` exclusion from 1Password agent (fixes Obsidian background sync)
- ssh: `10-home` with home network devices (proxmox, truenas, opnsense, etc.)
- ssh: `20-work-jump` with jump hosts (ssh-srv, ssh-ma5, ssh-ld5)
- ssh: `30-work-network` with direct work network devices
- ssh: `37-work-via-jump` with 30+ devices requiring ProxyJump via ssh-srv
- ssh: extracted 200+ hosts total from Royal TSX export (.rtsz XML)
- ssh: 1Password SSH Agent integration (`~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock`)
- zsh: `cssh` function for Cisco SSH with auto-password from 1Password CLI
- Brewfile.common: sshpass (non-interactive SSH password authentication)
- docs: `ssh-configuration.md` - comprehensive SSH setup documentation
- docs: `plans/2026-01-07-ssh-picker-design.md` - SSH picker design with fzf/tmux
- docs: `session-and-ssh-guide.md` - comprehensive user guide with quick reference card
- zsh: `sp` function - SSH picker with fzf, multi-select, tmux layouts (tiled/sync)
- tmux: `C-a S` keybinding to launch SSH picker in popup
- ssh: `# OP:` markers on 202 hosts for explicit password auth detection
- sp: `C-p` keybinding - single host adds pane to current window, multiple hosts create new window
- sp: `C-h` keybinding - run SSH in current pane (for pre-split panes)
- tmux: `C-a L` cycles through pane layouts (simpler than separate horizontal/vertical keys)
- ssh: ChromaTerm syntax highlighting for Cisco IOS sessions (jellybeans-flexoki colors)
- chromaterm: `.chromaterm.yml` config with patterns for interfaces, VLANs, spanning-tree, ACLs, BGP, EIGRP, OSPF
- zsh: `sshc` alias for explicit colored SSH, `sshn` for no-color SSH
- sp: automatic ChromaTerm integration when `ct` command available
- cssh: automatic ChromaTerm integration when `ct` command available
- tmux: Alt+arrows for pane switching without prefix
- tmux: Shift+arrows for window switching without prefix
- tmux: Alt+H/L for window switching without prefix
- tmux: tmux-yank plugin for improved clipboard support
- tmux: vi copy-mode keybindings (`v` select, `C-v` rectangle, `y` copy)

### Changed
- wezterm: switched to flexoki-dark theme
- tmux: status line now uses ANSI colors instead of hex - follows terminal theme
- zsh: `cssh` now uses `sshpass -d` (file descriptor) - password no longer visible in `ps`
- tmux: disabled continuum auto-restore (use `C-a C-r` to restore manually)
- sp: improved fzf input handling for tmux popup compatibility (uses `--bind start:reload`)
- sp: window names now show hostname (e.g., `srv+tiled` instead of `ssh-tiled`)

### Security
- Moved proprietary fonts to private `fonts-private` repository (Berkeley Mono, MonoLisa, Operator Mono, PragmataPro, etc.)
- Configured chezmoi externals to pull fonts from `fonts-private` via SSH
- Moved sensitive SSH host configs (10-home through 37-*) to private `os-private` repository
- Configured chezmoi externals (`.chezmoiexternal.toml`) to pull SSH configs via SSH URL
- All 12 `config.d/` files now live in private repo (including non-sensitive 00-defaults, 05-github)
- Sanitized documentation examples (replaced real IPs with 10.x.x.x placeholders)
- Purged sensitive files from git history using BFG (70 commits cleaned)

### Fixed
- Moved mole from Brewfile.common to Brewfile.darwin (macOS-only in Homebrew)

### Changed
- CLAUDE.md: Restored original workflow steps, added push as step 7
- CLAUDE.md: Added "Depending on What Changed" table for chezmoi/brew actions
- CLAUDE.md: Added "Common Tasks" quick reference
- CLAUDE.md: Restored "Autonomy Check" callout section
- CLAUDE.md: Added "Session Start" section with memory search and design doc read requirements

### Added
- Brewfile.common: jq, sqlite
- Brewfile.darwin: 1password (main app), keymapp, spotify, zed
- Brewfile.darwin: global `cask_args appdir: "/Applications"`
- Mac App Store section in Brewfile.darwin (1Password Safari, Simplenote, Tailscale, Xcode, obsidian-web-clipper, pl2303-serial, raycast-companion, zsa-keymapp)

### Fixed
- Brewfile.darwin: removed per-cask appdir overrides, using global default now
- Brewfile.darwin: cleaned up inconsistent ~/Applications vs /Applications settings

### Added (earlier)
- macOS defaults script with current non-default settings (`scripts/macos-defaults.sh`) [macOS]
- Chezmoi run_once script for Homebrew package installation (`run_once_after_brew-bundle.sh.tmpl`)
- Zig to mise config

### Fixed (brew-bundle script)
- Moved shebang to first line (was after ABOUTME comments)
- Replaced invalid `--no-lock` flag with `--no-upgrade`

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
- Deprecated Homebrew casks from system: alacritty, chromium, syntax-highlight
- Deprecated casks from Brewfile.darwin: alacritty, arc, chromium, powershell, syntax-highlight
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
