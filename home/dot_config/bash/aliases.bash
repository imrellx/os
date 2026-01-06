# ABOUTME: Shell aliases and functions for Linux (bash)
# ABOUTME: Mirrors zsh aliases for consistent cross-platform experience
# ~/.config/bash/aliases.bash

# -------------------------------
# Helpers
# -------------------------------
command_exists() { command -v "$1" &>/dev/null; }

# -------------------------------
# eza aliases with fallback
# -------------------------------
if command_exists eza; then
  alias l='eza -aF --icons'
  alias la='eza -aF --icons'
  alias ll='eza -laF --icons'
  alias lm='eza -lahr --color-scale --icons -s=modified'
  alias lb='eza -lahr --color-scale --icons -s=size'
  tree() { eza -aF --tree -L="${1:-2}" --icons; }
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
else
  # Linux GNU ls
  alias l='ls --color=auto'
  alias la='ls -A --color=auto'
  alias ll='ls -lAh --color=auto'
  alias lm='ls -lt --color=auto'
  alias lb='ls -lAhS --color=auto'
  alias ls='ls -lh --color=auto'
  alias lsa='ls -lah --color=auto'
  tree() { command find "${1:-.}" -maxdepth "${2:-2}" -print 2>/dev/null; }
  alias lt='tree'
  alias lta='lt'
fi

# -------------------------------
# fzf helpers
# -------------------------------
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# -------------------------------
# zoxide-aware cd
# -------------------------------
zd() {
  if [[ $# -eq 0 ]]; then
    builtin cd ~ && return
  elif [[ -d "$1" ]]; then
    builtin cd "$1"
  else
    z "$@" && printf " \U000F17A9 " && pwd || echo "Error: Directory not found"
  fi
}
cd() { zd "$@"; }

# -------------------------------
# Git
# -------------------------------
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
alias undopush="git push -f origin HEAD^:master"

# -------------------------------
# Config editing
# -------------------------------
alias ebrc='nvim ~/.config/bash/.bashrc'
alias sbrc='source ~/.config/bash/.bashrc'

# -------------------------------
# IP / Network
# -------------------------------
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias myip='curl icanhazip.com'
alias whois="whois -h whois-servers.net"
alias localip="ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1"
alias ips="ip -4 addr | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"
alias flush="sudo systemd-resolve --flush-caches 2>/dev/null || sudo resolvectl flush-caches 2>/dev/null"

# -------------------------------
# Clipboard
# -------------------------------
alias clip="tr -d '\n' | xclip -selection clipboard"
alias cpwd='pwd | xclip -selection clipboard'
alias pa='xclip -selection clipboard -o'

# -------------------------------
# File operations
# -------------------------------
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"
alias fs="stat --printf='%s bytes\n'"
alias emptytrash="rm -rfv ~/.local/share/Trash/*"

# Archive listing
ls-archive() {
  if [[ -z "$1" ]]; then echo "No archive specified"; return; fi
  if [[ ! -f "$1" ]]; then echo "File not found"; return; fi
  ext="${1##*.}"
  case "$ext" in
    zip) unzip -l "$1" ;;
    rar) unrar l "$1" ;;
    tar) tar tf "$1" ;;
    gz|tgz) tar tzf "$1" ;;
    *) echo "Unknown Archive Format" ;;
  esac
}
alias lz='ls-archive'

# mkdir helpers
mkcd() { local dir="$*"; mkdir -p "$dir" && cd "$dir"; }
mkcp() {
  local dir="$2"; local tmp="$2"; tmp="${tmp: -1}"
  [[ "$tmp" != "/" ]] && dir="$(dirname "$2")"
  [[ -d "$dir" ]] || mkdir -p "$dir" && cp -r "$@"
}
mkmv() {
  local dir="$2"; local tmp="$2"; tmp="${tmp: -1}"
  [[ "$tmp" != "/" ]] && dir="$(dirname "$2")"
  [[ -d "$dir" ]] || mkdir -p "$dir" && mv "$@"
}

# -------------------------------
# Navigation
# -------------------------------
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias doc="cd ~/Documents"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="cd ~/Code"
alias c="cd ~/.config"

# -------------------------------
# Search
# -------------------------------
alias f="find . | grep"
alias hf="history | grep"
command_exists fd || alias fd='find . -type d -name'

# -------------------------------
# History
# -------------------------------
alias h='history'
alias h-search='history | grep'
alias histrg='history | tail -500 | rg'

# fzf history widget (bash version)
fzf-history() {
  local selected_command
  selected_command=$(history | tac | fzf --height 40% --reverse | sed -E 's/ *[0-9]+ +//')
  if [[ -n "$selected_command" ]]; then
    echo "$selected_command"
    eval "$selected_command"
  fi
}
bind '"\C-r": "\C-x\C-r"'
bind -x '"\C-x\C-r": fzf-history'

# -------------------------------
# Permissions
# -------------------------------
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# -------------------------------
# Disk usage
# -------------------------------
alias dud='du -d 1 -h'
alias duf='du -sh *'

# -------------------------------
# Alias management
# -------------------------------
alias al='alias | less'
alias as='alias | grep'
alias ar='unalias'

# -------------------------------
# System monitoring (Linux)
# -------------------------------
alias meminfo='free -m -l -t'
alias memhog='ps -eo pid,ppid,cmd,%mem --sort=-%mem | head'
alias cpuhog='ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head'
alias cpuinfo='lscpu'
alias distro='cat /etc/*-release'

# -------------------------------
# External services
# -------------------------------
alias weather='curl wttr.in'
alias weather-short='curl "wttr.in?format=3"'
alias cheat='curl cheat.sh/'
alias joke='curl https://icanhazdadjoke.com'

# -------------------------------
# Misc
# -------------------------------
alias cls='clear;ls'
alias plz="fc -ln -1 | xargs sudo"
alias when='date'
alias whereami='pwd'

# -------------------------------
# Package managers
# -------------------------------
alias brewup='brew update && brew upgrade && brew cleanup'
alias bunup='bun upgrade'
alias upall='brewup && bunup'

# -------------------------------
# Editors
# -------------------------------
alias v='nvim'

# -------------------------------
# AI CLI tools
# -------------------------------
alias cc="claude --dangerously-skip-permissions"
alias cx="codex --dangerously-bypass-approvals-and-sandbox"
alias oc="opencode"
alias cc-start="claude --dangerously-skip-permissions"
alias cc-continue="claude --dangerously-skip-permissions --continue"
