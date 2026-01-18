# ABOUTME: Comprehensive context file for Claude operating in OS management workspace
# ABOUTME: Complete documentation of repo structure, features, and workflows

# OS Management Workspace

Command center for managing Ivo's machines. Claude is the executing agent for ALL OS-level tasks. This repo manages dotfiles, packages, and system configuration across macOS and Linux using chezmoi.

**Created:** 2026-01-06
**Commits:** 102+
**Status:** Active development

---

## Quick Reference

| Task | Command |
|------|---------|
| Deploy configs | `chezmoi apply` |
| Preview changes | `chezmoi apply --dry-run` |
| Add new config | `chezmoi add ~/.config/foo` |
| Install packages | `brew bundle --file=inventory/Brewfile.darwin` |
| SSH picker | `sp` (in tmux) |
| Session picker | `ss` |

---

## Repository Architecture

### Three-Repo Structure

| Repo | Visibility | Contents |
|------|------------|----------|
| `imrellx/os` | **Public** | All configs, scripts, docs, Brewfiles |
| `imrellx/os-private` | **Private** | SSH host configs (`~/.ssh/config.d/*`) - 200+ hosts |
| `imrellx/fonts-private` | **Private** | Proprietary fonts (`~/.config/fonts/`) - 83 files |

**How it works:** `.chezmoiexternal.toml` tells chezmoi to clone private repos during `chezmoi apply`:
```toml
[".ssh/config.d"]
url = "git@github.com:imrellx/os-private.git"

[".config/fonts"]
url = "git@github.com:imrellx/fonts-private.git"
```

### Directory Structure

```
os/
├── CLAUDE.md                 # THIS FILE - comprehensive context
├── CHANGELOG.md              # Human-readable change history
├── .gitignore
│
├── home/                     # Chezmoi source directory → deploys to ~/
│   ├── .chezmoi.toml.tmpl    # Profile selection (minimal/developer/full/custom)
│   ├── .chezmoiexternal.toml # Private repo integration
│   ├── .chezmoiignore        # Platform and profile-based exclusions
│   │
│   ├── dot_zshenv.tmpl       # → ~/.zshenv (macOS shell bootstrap)
│   ├── dot_bashrc.tmpl       # → ~/.bashrc (Linux shell bootstrap)
│   ├── dot_chromaterm.yml    # → ~/.chromaterm.yml (Cisco syntax highlighting)
│   ├── dot_gitmessage        # → ~/.gitmessage
│   ├── symlink_dot_gitconfig # → ~/.gitconfig (symlink)
│   │
│   ├── dot_ssh/
│   │   └── config            # Main SSH config with Include directives
│   │
│   ├── dot_config/           # → ~/.config/
│   │   ├── aerospace/        # macOS tiling window manager
│   │   ├── alacritty/        # Terminal (template)
│   │   ├── bash/             # Linux shell config
│   │   ├── borders/          # macOS window borders
│   │   ├── gh/               # GitHub CLI
│   │   ├── ghostty/          # Primary terminal (template)
│   │   ├── helix/            # Modal editor
│   │   ├── hyprspace/        # macOS spaces manager
│   │   ├── lazygit/          # Git TUI
│   │   ├── mise/             # Tool version manager
│   │   ├── nvim/             # Neovim (LazyVim)
│   │   ├── sesh/             # Session manager config
│   │   ├── starship/         # Prompt
│   │   ├── superfile/        # File manager
│   │   ├── tmux/             # Multiplexer (template)
│   │   ├── tmuxinator/       # Session layouts
│   │   ├── wezterm/          # Terminal (template)
│   │   ├── yazi/             # File manager
│   │   ├── zellij/           # Multiplexer
│   │   └── zsh/              # macOS shell config
│   │
│   ├── run_once_after_brew-bundle.sh.tmpl  # Auto-installs Homebrew packages
│   └── run_once_install-fonts.sh.tmpl      # Installs fonts per platform
│
├── inventory/                # Package management
│   ├── Brewfile.common       # Cross-platform CLI tools (97 items)
│   ├── Brewfile.darwin       # macOS casks, VSCode extensions (178 items)
│   └── Brewfile.linux        # Linux-specific (placeholder)
│
├── scripts/
│   └── macos-defaults.sh     # macOS system preferences
│
└── docs/
    ├── audit-2026-01-06.md           # Initial system audit
    ├── ssh-configuration.md          # SSH setup documentation
    ├── session-and-ssh-guide.md      # User guide for SSH/session tools
    ├── pai/                          # PAI customizations documentation
    │   ├── CHANGELOG.md              # PAI version tracking
    │   ├── fixes-2026-01-16.md       # Bug fix details
    │   └── custom-skills.md          # Custom skill documentation
    └── plans/
        ├── 2026-01-06-os-management-design.md    # Original design doc
        ├── 2026-01-07-ssh-picker-design.md       # SSH picker design
        └── 2026-01-18-devcontainer-workflow-design.md  # DevPod/containers
```

---

## Managed Configurations

### 20 Application Configs

| Category | Apps | Notes |
|----------|------|-------|
| **Shells** | zsh (macOS), bash (Linux) | XDG-compliant, starship prompt |
| **Terminals** | ghostty, wezterm, alacritty | Templates with platform handling |
| **Editors** | nvim (LazyVim), helix | Full plugin configs |
| **Multiplexers** | tmux, zellij | Plugins via TPM |
| **File Managers** | yazi, superfile | With themes/flavors |
| **Git Tools** | lazygit, gh | |
| **Dev Tools** | mise | Tool version manager |
| **Window Managers** | aerospace, hyprspace, borders | macOS only |
| **SSH** | 200+ hosts | Via private repo |

### Template Files (Platform-Aware)

These files use chezmoi templates for cross-platform support:
- `aliases.zsh.tmpl` - Clipboard, ls, network commands differ per OS
- `homebrew.zsh.tmpl` - Different Homebrew paths
- `tmux.conf.tmpl` - Clipboard integration
- `ghostty/config.tmpl` - Font paths
- `wezterm.lua.tmpl` - Platform detection
- `alacritty.toml.tmpl` - Font configuration

---

## SSH Tools (Major Feature)

### Architecture
- Main config: `~/.ssh/config` includes `~/.ssh/config.d/*`
- 200+ hosts extracted from Royal TSX export
- 1Password SSH Agent integration
- Jump host support for work network

### SSH Picker (`sp`)
Interactive fzf-based SSH host picker with tmux integration:

```bash
sp [search-term]
```

**Keybindings:**
| Key | Action |
|-----|--------|
| Enter | New tmux window |
| Ctrl-t | Tiled panes (multi-select) |
| Ctrl-s | Synchronized input (multi-select) |
| Ctrl-p | Run in current pane |
| Ctrl-h | Run in current pane (tmux keybinding) |
| Tab | Toggle multi-select |

**Features:**
- Parses `~/.ssh/config.d/*` for hosts
- Detects `# OP:` markers for password auth via 1Password
- ChromaTerm syntax highlighting for Cisco devices
- Works in tmux popup (`C-a S`)

### Related Functions
- `cssh <host>` - Cisco SSH with 1Password password
- `sshc` - SSH with ChromaTerm
- `sshn` - SSH without ChromaTerm

---

## Session Management

### sesh + sessionx
- `ss` - fzf picker for tmux sessions
- `C-a o` - sessionx popup
- `C-a p` - floax floating pane

### Named Sessions (in `~/.config/sesh/sesh.toml`)
- `o-vault`, `v-vault` - Obsidian vaults
- `o-family`, `v-family` - Family vaults
- `os` - This repo
- `pai` - PAI repo

### tmuxinator Templates
- `lab` - Home lab layout
- `troubleshoot` - Network troubleshooting
- `ssh-multi` - Multi-host sessions

---

## Installation Profiles

Run `chezmoi init` to select:

| Profile | Includes |
|---------|----------|
| **minimal** | shell, git, starship |
| **developer** | + editors, terminals, multiplexers, file managers, dev tools |
| **full** | + window managers, fonts (110MB) |
| **custom** | Pick each category individually |

Categories are controlled by boolean flags in `.chezmoi.toml.tmpl`:
- `install_shell`, `install_git` (always true)
- `install_editors`, `install_terminals`, `install_multiplexers`
- `install_file_managers`, `install_dev_tools`
- `install_window_managers`, `install_fonts`

---

## Machines

| Machine | OS | Role |
|---------|-----|------|
| MacBook Pro M4 Max | macOS Tahoe | Primary workstation |
| Linux laptops | Omarchy | Secondary |
| VMs | Various | Ephemeral |

---

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

---

## Workflow

### Making Changes

1. Check tier (Green/Yellow/Red) - propose if yellow/red
2. Make changes in repo
3. Run `chezmoi apply` if `home/` changed
4. Update `CHANGELOG.md` under `[Unreleased]`
5. Commit with descriptive message (conventional commits)
6. Push to origin

### What Changed → What Action

| Changed | Action |
|---------|--------|
| `home/**` | `chezmoi apply` to deploy |
| `inventory/Brewfile.*` | `brew bundle` or manual `brew install` |
| New external config | `chezmoi add <file>` before editing |
| Inventory/docs only | No deploy needed |

### Common Tasks

**Add a brew package:**
```bash
# 1. Edit Brewfile
nvim inventory/Brewfile.darwin  # or .common

# 2. Install immediately (optional)
brew install <pkg>

# 3. Commit
# Update CHANGELOG, commit, push
```

**Add a new config to management:**
```bash
chezmoi add ~/.config/foo     # Copies to home/dot_config/foo
nvim home/dot_config/foo/...  # Edit if needed
# Update CHANGELOG, commit, push
```

**Modify existing config:**
```bash
nvim home/dot_config/foo/...  # Edit source
chezmoi apply                 # Deploy
# Update CHANGELOG, commit, push
```

---

## Key Commands

```bash
# Chezmoi
chezmoi init              # First-time setup (prompts for profile)
chezmoi apply             # Deploy configs
chezmoi apply --dry-run   # Preview changes
chezmoi diff              # Show pending changes
chezmoi edit <file>       # Edit source file
chezmoi add <file>        # Add existing file to management

# Homebrew
brew bundle --file=inventory/Brewfile.common
brew bundle --file=inventory/Brewfile.darwin

# SSH/Session
sp                        # SSH picker
ss                        # Session picker
cssh <host>               # Cisco SSH with 1Password
```

---

## Tech Stack Preferences

| Category | Preferred |
|----------|-----------|
| Shell (macOS) | zsh |
| Shell (Linux) | bash |
| Terminal | ghostty |
| Editor | neovim (LazyVim) |
| Multiplexer | tmux |
| File Manager | yazi |
| Prompt | starship |
| Tool versions | mise |
| Containers | OrbStack (macOS), Podman (Linux) |
| Dev containers | DevPod |

---

## Future Work

### DevPod / Stateless Workstation (In Progress)
See `docs/plans/2026-01-18-devcontainer-workflow-design.md`

Goal: Portable dev environments using DevPod + devcontainer.json + mise

```
Host (macOS/Linux) → DevPod → Container with:
  - Dotfiles (cloned by DevPod)
  - Project code
  - Tools (via mise.toml)
```

---

## Git History Summary

**102 commits** since 2026-01-06

### Major Milestones
1. **Initial setup** (01-06): Repo structure, chezmoi migration, system audit
2. **Shell separation** (01-06): zsh for macOS, bash for Linux
3. **Profile system** (01-06): Interactive profile selection at init
4. **SSH extraction** (01-07): 200+ hosts from Royal TSX, modular config.d
5. **SSH picker** (01-07): fzf-based `sp` with tmux integration, 1Password
6. **Security split** (01-07): Private repos for SSH configs and fonts
7. **ChromaTerm** (01-07): Cisco syntax highlighting
8. **tmux themes** (01-09): jellybeans-tmux, flexoki, ANSI colors
9. **DevPod** (01-18): Stateless workstation design

### Commit Style
Uses conventional commits: `feat(scope):`, `fix(scope):`, `docs:`, `security:`

---

## Design Documents

| Document | Purpose |
|----------|---------|
| `2026-01-06-os-management-design.md` | Original architecture, autonomy tiers |
| `2026-01-07-ssh-picker-design.md` | SSH picker requirements, tmux integration |
| `2026-01-18-devcontainer-workflow-design.md` | DevPod, stateless workstation |
| `audit-2026-01-06.md` | Initial system state (193 formulae, 45 casks) |
| `ssh-configuration.md` | SSH setup, 1Password, jump hosts |
| `session-and-ssh-guide.md` | User guide with quick reference |

---

## PAI Customizations

PAI (Personal AI Infrastructure) customizations are tracked separately:

| Location | Contents |
|----------|----------|
| `docs/pai/` | Public documentation (this repo) |
| `imrellx/pai-customizations` (private) | Actual customization files |

### Restore After Fresh PAI Install

```bash
# Clone and restore customizations
cd ~/Code/personal
git clone git@github.com:imrellx/pai-customizations.git
cp -r pai-customizations/skills/* ~/.claude/skills/
cp pai-customizations/modified/hooks/* ~/.claude/hooks/
cp pai-customizations/modified/scripts/statusline-command.sh ~/.claude/
cp -r pai-customizations/USER ~/.claude/skills/CORE/
cp pai-customizations/settings.json ~/.claude/
```

See `docs/pai/` for detailed documentation.

---

## Troubleshooting

### chezmoi apply fails
```bash
chezmoi doctor          # Check setup
chezmoi diff            # See what would change
chezmoi apply --verbose # Detailed output
```

### Private repos not cloning
- Ensure SSH key is loaded: `ssh-add -l`
- Check GitHub access: `ssh -T git@github.com`
- Private repos use SSH URLs (not HTTPS)

### SSH picker not finding hosts
- Check `~/.ssh/config.d/` exists and has files
- Files must not start with `.` (hidden)
- Run `sp` with no args to see all hosts

---

## Session Start Checklist

When starting a new session in this repo:

1. ✅ Read this CLAUDE.md (you're here)
2. Check `CHANGELOG.md` for recent changes
3. Run `git status` to see working tree state
4. For SSH work, review `docs/session-and-ssh-guide.md`
5. For new features, check `docs/plans/` for relevant design docs

---

## Notes for Claude

- **This manages the ENTIRE computer**, not just dotfiles
- Always update `CHANGELOG.md` with changes
- Use conventional commit messages
- Check autonomy tier before making changes
- Private repos contain sensitive data - never commit IPs/passwords to public repo
- Templates (`.tmpl`) need `chezmoi apply` to deploy changes
