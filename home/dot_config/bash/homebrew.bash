# ABOUTME: Homebrew configuration and update functions for Linux (bash)
# ABOUTME: Mirrors zsh homebrew config for consistent cross-platform experience
# ~/.config/bash/homebrew.bash
# DOCS https://docs.brew.sh/Manpage#environment
#───────────────────────────────────────────────────────────────────────────────

export HOMEBREW_EDITOR="${EDITOR:-vim}"

# Brewfile locations (in os repo inventory folder)
export BREWFILE_DIR="$HOME/Code/personal/os/inventory"
export BREWFILE_COMMON="$BREWFILE_DIR/Brewfile.common"
export BREWFILE_PLATFORM="$BREWFILE_DIR/Brewfile.linux"

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_DISPLAY_INSTALL_TIMES=1

#───────────────────────────────────────────────────────────────────────────────

_pretty_header() {
  [[ "$2" != "no-line-break" ]] && echo
  # On Linux, assume dark terminal
  local fg="\e[1;37m"
  local bg="\e[1;44m"
  echo -e "$fg$bg $1 \e[0m"
}

_brew_bundle_install() {
  local brewfile="$1"
  local name="$2"
  if [[ ! -f "$brewfile" ]]; then
    echo "⚠️  $name not found: $brewfile"
    return 1
  fi
  if ! brew bundle check --file="$brewfile" --no-upgrade &>/dev/null; then
    export HOMEBREW_COLOR=1
    brew bundle install --file="$brewfile" --verbose --no-upgrade |
      grep --invert-match --extended-regexp "^Using |^Skipping install of "
  else
    echo "✅ $name satisfied."
  fi
}

update() {
  _pretty_header "brew update" "no-line-break"
  brew update

  _pretty_header "brew bundle install (common)"
  _brew_bundle_install "$BREWFILE_COMMON" "Brewfile.common"

  _pretty_header "brew bundle install (platform)"
  _brew_bundle_install "$BREWFILE_PLATFORM" "Brewfile.platform"

  _pretty_header "brew upgrade"
  if [[ -n $(brew outdated) ]]; then
    brew upgrade
  else
    echo "✅ Already up-to-date."
  fi

  # 10% of the time, run `brew doctor`
  if ((RANDOM % 100 < 10)); then
    _pretty_header "brew doctor"
    brew doctor
  fi

  echo "🍺 Homebrew update finished."
}
