# ABOUTME: Design document for stateless workstation and dev container workflow
# ABOUTME: Defines DevPod + devcontainer.json + mise architecture for portable development

# Dev Container Workflow Design

**Date:** 2026-01-18
**Status:** Draft

## Overview

This document defines a stateless workstation workflow using DevPod, dev containers, and mise. The goal is to achieve portable, reproducible development environments where the underlying OS is irrelevant - you can SSH into any configured machine and be productive within minutes.

## Inspiration

Based on Mischa van den Burg's stateless workstation philosophy, adapted for our existing stack:

| His Stack (Fedora Atomic) | Our Stack | Notes |
|---------------------------|-----------|-------|
| Immutable OS | macOS / Linux | We don't need immutability - machines are already configured |
| rpm-ostree | Homebrew | Declarative via Brewfiles |
| Podman | OrbStack (macOS) / Podman (Linux) | Container runtimes |
| chezmoi | chezmoi | Same ✅ |
| mise | mise | Currently limited use - expanding |
| DevPod | DevPod | Just added |
| pass + GPG + Yubikey | 1Password | Already integrated |
| Synology Drive | Synology | Already in use |

## Architecture

### The Layers

```
┌─────────────────────────────────────────────────────────────────┐
│  HOST MACHINE (macOS or Linux)                                  │
│  ├── OS (already installed and configured)                      │
│  ├── DevPod (orchestrates containers)                           │
│  ├── Container runtime (OrbStack on macOS, Podman on Linux)     │
│  └── SSH access configured                                      │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ devpod up <repo>
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  DEV CONTAINER (per project)                                    │
│  ├── Base image (from devcontainer.json)                        │
│  ├── Dotfiles (cloned by DevPod from your repo)                 │
│  ├── mise (reads mise.toml from project)                        │
│  └── Project-specific tools (installed by mise)                 │
└─────────────────────────────────────────────────────────────────┘
```

### What Lives Where

| Component | Location | Managed By |
|-----------|----------|------------|
| OS config, shell, editor | Host machine | chezmoi |
| DevPod | Host machine | Homebrew (Brewfile.darwin) |
| Container runtime | Host machine | OrbStack cask / system package |
| Project code | Inside container | Git |
| Dotfiles (in container) | Inside container | DevPod clones from your repo |
| Project tools | Inside container | mise reads `mise.toml` |

## Key Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Container orchestrator | DevPod | Works with any backend (Docker, Podman, K8s, cloud), handles dotfiles, integrates with IDEs |
| Container runtime (macOS) | OrbStack | Already installed, fast, low resource usage |
| Container runtime (Linux) | Podman | Native, rootless, no daemon |
| Dotfiles in containers | Same repo as host | One source of truth, DevPod clones automatically |
| Per-project tools | mise | `mise.toml` per repo specifies exact versions |
| Host machine setup | Minimal | Only needs DevPod and container runtime |

## Workflow

### Daily Usage (machines already configured)

```bash
# SSH into any of your machines
ssh myserver

# Spin up a project's dev environment
devpod up git@github.com:imrellx/someproject.git

# Connect to the container
devpod ssh someproject

# You're now in a fully configured environment with:
# - Your dotfiles (shell, editor, aliases)
# - Project code
# - All tools specified in mise.toml
```

### New Machine Setup (when needed)

```bash
# 1. Install chezmoi and apply dotfiles (includes DevPod in Brewfile)
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply imrellx

# 2. Configure DevPod to use your dotfiles
devpod provider add docker  # or orbstack, podman
devpod context set-options -o DOTFILES_URL=https://github.com/imrellx/os

# 3. Done - now devpod up <any-repo> will work
```

## DevPod Configuration

### One-time setup (per machine)

```bash
# Set default provider (container runtime)
devpod provider add orbstack  # macOS
devpod provider add docker    # Linux with Docker
devpod provider add podman    # Linux with Podman

# Configure dotfiles repository
devpod context set-options -o DOTFILES_URL=https://github.com/imrellx/os
devpod context set-options -o DOTFILES_SCRIPT=scripts/devcontainer-setup.sh  # optional
```

### Provider options

| Provider | Platform | Notes |
|----------|----------|-------|
| orbstack | macOS | Recommended - fast, lightweight |
| docker | Any | Docker Desktop or Docker Engine |
| podman | Linux | Rootless, daemonless |
| kubernetes | Any | For cloud-based dev environments |
| ssh | Any | Run containers on remote machines |

## devcontainer.json Pattern

Template for projects:

```json
{
  "name": "project-name",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/common-utils:2": {},
    "ghcr.io/jdx/devcontainer-feature/mise:1": {}
  },
  "postCreateCommand": "mise install",
  "customizations": {
    "vscode": {
      "extensions": [
        "asvetliakov.vscode-neovim"
      ]
    }
  },
  "remoteUser": "vscode"
}
```

### Key Features

| Feature | Purpose |
|---------|---------|
| `common-utils` | Basic CLI tools (git, curl, etc.) |
| `mise` | Tool version manager - reads `mise.toml` from repo |

### Base Images

| Image | Use Case |
|-------|----------|
| `mcr.microsoft.com/devcontainers/base:ubuntu` | General purpose |
| `mcr.microsoft.com/devcontainers/typescript-node` | Node/TypeScript projects |
| `mcr.microsoft.com/devcontainers/python` | Python projects |
| `mcr.microsoft.com/devcontainers/go` | Go projects |
| `mcr.microsoft.com/devcontainers/rust` | Rust projects |

## mise.toml Pattern

Per-project tool specification:

```toml
[tools]
node = "20"
bun = "latest"
python = "3.12"

# Project-specific tools
kubectl = "1.29"
terraform = "1.7"
```

### Current vs Expanded Usage

| Current (limited) | Expanded (target) |
|-------------------|-------------------|
| Few global tools | Per-project tool versions |
| Same versions everywhere | Project specifies exact versions |
| Manual installation | Automatic via `mise install` |

## File Locations

### In this repo (os/)

```
os/
├── inventory/
│   └── Brewfile.darwin        # Contains: cask "devpod"
├── scripts/
│   └── devcontainer-setup.sh  # Optional: runs inside containers after dotfiles clone
└── docs/plans/
    └── 2026-01-18-devcontainer-workflow-design.md  # This document
```

### In each project repo

```
project/
├── .devcontainer/
│   └── devcontainer.json      # Container definition
└── mise.toml                  # Tool versions for this project
```

## Migration Path

### Phase 1: Foundation (Current)
- [x] DevPod added to Brewfile.darwin
- [x] DevPod already installed
- [ ] Configure DevPod dotfiles URL
- [ ] Create `scripts/devcontainer-setup.sh`

### Phase 2: First Project
- [ ] Pick a project to containerize
- [ ] Create `.devcontainer/devcontainer.json`
- [ ] Create/expand `mise.toml`
- [ ] Test `devpod up` workflow

### Phase 3: Refinement
- [ ] Create devcontainer.json templates for common project types
- [ ] Document which tools stay global vs per-project
- [ ] Test on Linux secondary machine

## Open Questions

1. **Dotfiles script**: Do we need `devcontainer-setup.sh` or does chezmoi apply automatically work?
2. **Editor integration**: VSCode Remote Containers vs terminal-only workflow?
3. **Secrets in containers**: How do we handle 1Password SSH agent inside containers?
4. **Performance**: Any concerns with container startup time?

## Not In Scope

- Immutable OS (macOS isn't, and we don't need it)
- USB bootstrap stick (machines already configured)
- Complex bootstrap ceremony (chezmoi handles host, DevPod handles containers)
- pass/GPG password management (using 1Password)

## References

- [DevPod Documentation](https://devpod.sh/docs)
- [Dev Container Specification](https://containers.dev/)
- [mise Documentation](https://mise.jdx.dev/)
- Original inspiration: Mischa van den Burg's stateless workstation video
