#!/usr/bin/env bash

# Helper script to switch between Neovim configs

set -e

CURRENT_CONFIG="$HOME/.config/nvim"
NEW_CONFIG="$HOME/.config/nvim.claude"
BACKUP_CONFIG="$HOME/.config/nvim.backup"

show_help() {
    cat << HELP
Neovim Config Switcher

Usage: ./switch.sh [command]

Commands:
    try         Try new config without changing current (NVIM_APPNAME=nvim.claude nvim)
    switch      Replace current config with new (backs up current first)
    restore     Restore original config from backup
    alias       Show alias to add to shell config
    help        Show this help message

Examples:
    ./switch.sh try          # Try new config in current directory
    ./switch.sh switch       # Replace current config (makes backup)
    ./switch.sh restore      # Go back to original config
HELP
}

try_new() {
    echo "Trying new config..."
    echo "Press Ctrl-C to exit"
    NVIM_APPNAME=nvim.claude nvim "$@"
}

switch_to_new() {
    if [ -d "$CURRENT_CONFIG" ]; then
        echo "Backing up current config to $BACKUP_CONFIG"
        mv "$CURRENT_CONFIG" "$BACKUP_CONFIG"
    fi

    echo "Switching to new config..."
    mv "$NEW_CONFIG" "$CURRENT_CONFIG"

    echo "✓ Done! New config is now active."
    echo "  Your old config is backed up at: $BACKUP_CONFIG"
    echo "  Run './switch.sh restore' to go back"
}

restore_old() {
    if [ ! -d "$BACKUP_CONFIG" ]; then
        echo "Error: No backup found at $BACKUP_CONFIG"
        exit 1
    fi

    if [ -d "$CURRENT_CONFIG" ]; then
        echo "Moving current config to $NEW_CONFIG"
        mv "$CURRENT_CONFIG" "$NEW_CONFIG"
    fi

    echo "Restoring original config..."
    mv "$BACKUP_CONFIG" "$CURRENT_CONFIG"

    echo "✓ Done! Original config restored."
}

show_alias() {
    cat << 'ALIAS'
Add this to your ~/.bashrc or ~/.zshrc:

    alias nvim-new='NVIM_APPNAME=nvim.claude nvim'

Then you can use:
    nvim       # Old config
    nvim-new   # New config
ALIAS
}

case "${1:-help}" in
    try)
        shift
        try_new "$@"
        ;;
    switch)
        switch_to_new
        ;;
    restore)
        restore_old
        ;;
    alias)
        show_alias
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
