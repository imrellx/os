# ~/.config/zsh/aliases.zsh file holding all my aliases.
#
# If exa installed, then use eza for some ls commands
# Tools
#if command_exists eza ; then
# -------------------------------
# Helpers (zsh)
# -------------------------------
command_exists() { (( $+commands[$1] )) }

# If cd was previously aliased anywhere, remove it so we can define cd() safely
unalias cd 2>/dev/null

# -------------------------------
# eza aliases + macOS fallback
# -------------------------------
if command_exists eza; then
  alias l='eza -aF --icons'
  alias la='eza -aF --icons'
  alias ll='eza -laF --icons'
  alias lm='eza -lahr --color-scale --icons -s=modified'
  alias lb='eza -lahr --color-scale --icons -s=size'
  alias tree='f() { eza -aF --tree -L=${1:-2} --icons }; f'

  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
else
  # Colorized BSD/macOS ls fallback
  export CLICOLOR=1
  export CLICOLOR_FORCE=1

  alias l='ls -G'
  alias la='ls -AG'
  alias ll='ls -lAGh'
  alias lm='ls -tAG'
  alias lb='ls -lAGhS'
  alias tree='f() { command find "${1:-.}" -maxdepth "${2:-2}" -print 2>/dev/null; }; f'

  alias ls='ls -lGh'
  alias lsa='ls -laGh'
  alias lt='tree'
  alias lta='lt'
fi

# -------------------------------
# Other helpers
# -------------------------------
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# -------------------------------
# zoxide-aware cd (requires `z` to exist)
# -------------------------------
zd() {
  if (( $# == 0 )); then
    builtin cd ~ && return
  elif [[ -d "$1" ]]; then
    builtin cd "$1"
  else
    z "$@" && printf " \U000F17A9 " && pwd || echo "Error: Directory not found"
  fi
}

cd() { zd "$@"; }

# Git
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'

# List all files colorized in long format, including dot files
# alias la="ls -Gla"

# Edit this .zshrc file
alias ezrc='vl ~/.config/zsh/.zshrc'

# Source .zshrc
alias szrc='source ~/.config/zsh/.zshrc'

# Undo a `git push`
alias undopush="git push -f origin HEAD^:master"

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en1"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
alias whois="whois -h whois-servers.net"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Start an HTTP server from a directory
alias server="open http://localhost:8080/ && python -m SimpleHTTPServer 8080"

# Trim new lines and copy to clipboard
alias cp="tr -d '\n' | pbcopy"

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"

# File size
alias fs="stat -f \"%z bytes\""

# Empty the Trash
alias emptytrash="rm -rfv ~/.Trash"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.Finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.Finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Disable Spotlight
alias spotoff="sudo mdutil -a -i off"
# Enable Spotlight
alias spoton="sudo mdutil -a -i on"

# List contents of packed file, depending on type
ls-archive () {
  if [ -z "$1" ]; then
    echo "No archive specified"
    return;
  fi
  if [[ ! -f $1 ]]; then
    echo "File not found"
    return;
  fi
  ext="${1##*.}"
  if [ $ext = 'zip' ]; then
    unzip -l $1
  elif [ $ext = 'rar' ]; then
    unrar l $1
  elif [ $ext = 'tar' ]; then
    tar tf $1
  elif [ $ext = 'tar.gz' ]; then
    echo $1
  elif [ $ext = 'ace' ]; then
    unace l $1
  else
    echo "Unknown Archive Format"
  fi
}

alias lz='ls-archive'

# Make directory, and cd into it
mkcd() {
  local dir="$*";
  mkdir -p "$dir" && cd "$dir";
}

# Make dir and copy
mkcp() {
  local dir="$2"
  local tmp="$2"; tmp="${tmp: -1}"
  [ "$tmp" != "/" ] && dir="$(dirname "$2")"
  [ -d "$dir" ] ||
    mkdir -p "$dir" &&
    cp -r "$@"
}

# Move dir and move into it
mkmv() {
  local dir="$2"
  local tmp="$2"; tmp="${tmp: -1}"
  [ "$tmp" != "/" ] && dir="$(dirname "$2")"
  [ -d "$dir" ] ||
      mkdir -p "$dir" &&
      mv "$@"
}

# Change directory aliases
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Search files in the current folder
alias f="find . | grep "

# Search command line history
alias hf="history | grep"

# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Finding files and directories
alias dud='du -d 1 -h' # List sizes of files within directory
alias duf='du -sh *' # List total size of current directory
alias ff='find . -type f -name' # Find a file by name within current directory
(( $+commands[fd] )) || alias fd='find . -type d -name' # Find direcroy by name

# Command line history
alias h='history' # Shows full history
alias h-search='fc -El 0 | grep' # Searchses for a word in terminal history
alias top-history='history 0 | awk '{print $2}' | sort | uniq -c | sort -n -r | head'
alias histrg='history -500 | rg' # Rip grep search recent history

# Fuzzy search through command history with Ctrl+R
if [[ ! "$terminfo[kcuu1]" ]]; then
  bindkey '^R' fzf-history-widget
fi

fzf-history-widget() {
  local selected_command=$(fc -rl 1 | fzf --height 40% --reverse --tac | sed -E 's/ *[0-9]+\*? +//')
  LBUFFER="$selected_command"
  zle redisplay
}
zle -N fzf-history-widget

# Find + manage aliases
alias al='alias | less' # List all aliases
alias as='alias | grep' # Search aliases
alias ar='unalias' # Remove given alias

# System Monitoring
alias meminfo='free -m -l -t' # Show free and used memory
alias memhog='ps -eo pid,ppid,cmd,%mem --sort=-%mem | head' # Processes consuming most mem
alias cpuhog='ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head' # Processes consuming most cpu
alias cpuinfo='lscpu' # Show CPU Info
alias distro='cat /etc/*-release' # Show OS info alias ports='netstat -tulanp' # Show open ports

# Copy / pasting
alias cpwd='pwd | pbcopy' # Copy current path
alias pa='pbpaste' # Paste clipboard contents

# App Specific
#if command_exists code ; then; alias vsc='code .'; fi # Launch VS Code in current dir
#if command_exists cointop ; then; alias crypto='cointop'; fi
#if command_exists gotop ; then; alias gto='gotop'; fi

# External Services
alias myip='curl icanhazip.com'
alias weather='curl wttr.in'
alias weather-short='curl "wttr.in?format=3"'
alias cheat='curl cheat.sh/'
alias tinyurl='curl -s "http://tinyurl.com/api-create.php?url='
alias joke='curl https://icanhazdadjoke.com'
alias hackernews='curl hkkr.in'
alias worldinternet='curl https://status.plaintext.sh/t'

# Random lolz
alias cls='clear;ls' # Clear and ls
alias plz="fc -l -1 | cut -d' ' -f2- | xargs sudo" # Re-run last cmd as root
alias yolo='git add .; git commit -m "YOLO"; git push origin master'
alias when='date' # Show date
alias whereami='pwd'

# Alias for install script
#alias dotfiles="${DOTFILES_DIR:-$HOME/Library/CloudStorage/Dropbox/Utilities/dotfiles}/guided-install.sh"
#alias dots="dotfiles"

# random stuff
#alias f="spf"
#alias y="yazi"

# Shortcuts
# alias d="cd ~/Dropbox"
alias doc="cd ~/Documents"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="cd ~/Code"
alias c="cd ~/.config"
alias h="cd ~/"
alias v="cd ~/vault-002"

# Start screen saver
alias afk="open /System/Library/CoreServices/ScreenSaverEngine.app"

# Reload native apps
alias killfinder="killall Finder"
alias killdock="killall Dock"
alias killmenubar="killall SystemUIServer NotificationCenter"
alias killos="killfinder && killdock && killmenubar"

# Log off
alias logoff="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# all in one homebrew, gem update commands
alias brewup='brew update && brew upgrade && brew cleanup'
#alias gemup='gem update --system && gem update && gem cleanup'
alias npmup='npm -g update && npm-check-updates -u && npm install'
alias sysup='sudo softwareupdate -i -a'
#alias upall='sysup && brewup && gemup && npmup'
alias upall='sysup && brewup && npmup'

# Nvim
alias v='nvim' # default Neovim config
alias vl='NVIM_APPNAME=nvim-lazyvim nvim' # LazyVim
alias va='NVIM_APPNAME=nvim-astrovim nvim' # AstroVim
alias vh='NVIM_APPNAME=nvim-adibhanna nvim' # Adib's Vim
alias vc='NVIM_APPNAME=nvim-cpplain nvim' # cpplain's Vim
alias lazy='NVIM_APPNAME=nvim-lazyvim nvim' # LazyVim

#alias codex="codex --yolo"
#alias amp="amp --dangerously-allow-all"
#alias claude="claude --dangerously-skip-permissions"
alias cc="claude --dangerously-skip-permissions"
alias cx="codex --dangerously-bypass-approvals-and-sandbox"
alias oc="opencode"
alias cc-start="claude --dangerously-skip-permissions"
alias cc-continue="claude --dangerously-skip-permissions --continue"
