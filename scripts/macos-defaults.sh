# ABOUTME: macOS defaults captured from Ivo's MacBook (2026-01-06)
# ABOUTME: Run with: bash scripts/macos-defaults.sh (then log out/restart for some to take effect)

#!/bin/bash

set -e

echo "Applying macOS defaults..."

# =============================================================================
# Dock
# =============================================================================

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Enable magnification
defaults write com.apple.dock magnification -bool true

# Minimize windows into their application icon
defaults write com.apple.dock minimize-to-application -bool true

# Don't automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# =============================================================================
# Finder
# =============================================================================

# Show path bar at bottom of Finder windows
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar at bottom of Finder windows
defaults write com.apple.finder ShowStatusBar -bool true

# --- Extras (uncomment to enable) ---
# Show hidden files in Finder
# defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
# defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable warning when changing file extension
# defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Default to list view in Finder (Nlsv=list, icnv=icon, clmv=column, Flwv=gallery)
# defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# =============================================================================
# Screenshots
# =============================================================================

# Save screenshots to Downloads instead of Desktop
defaults write com.apple.screencapture location -string "${HOME}/Downloads"

# Disable floating thumbnail after taking screenshot
defaults write com.apple.screencapture show-thumbnail -bool false

# --- Extras (uncomment to enable) ---
# Save screenshots as PNG (default) - alternatives: JPG, PDF, TIFF
# defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
# defaults write com.apple.screencapture disable-shadow -bool true

# =============================================================================
# Trackpad
# =============================================================================

# Enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# --- Extras (uncomment to enable) ---
# Enable three-finger drag
# defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# =============================================================================
# Global UI
# =============================================================================

# Dark mode (comment out if you prefer light)
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Double-click title bar to fill/maximize (not minimize)
defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Fill"

# --- Extras (uncomment to enable) ---
# Fast key repeat (lower = faster, default InitialKeyRepeat=25, KeyRepeat=6)
# defaults write NSGlobalDomain InitialKeyRepeat -int 15
# defaults write NSGlobalDomain KeyRepeat -int 2

# Disable auto-correct
# defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable auto-capitalization
# defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart quotes (annoying for coding)
# defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes
# defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# =============================================================================
# Security / Privacy
# =============================================================================

# --- Extras (uncomment to enable) ---
# Disable "Are you sure you want to open this application?" dialog
# defaults write com.apple.LaunchServices LSQuarantine -bool false

# =============================================================================
# Desktop Services
# =============================================================================

# --- Extras (uncomment to enable) ---
# Don't create .DS_Store files on network volumes
# defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Don't create .DS_Store files on USB volumes
# defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# =============================================================================
# Apply changes
# =============================================================================

# Restart affected applications
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

echo "Done! Some changes may require logout/restart to take effect."
