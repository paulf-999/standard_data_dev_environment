#!/bin/bash

# Compute the root setup directory
ROOT_DIR=$(cd "$(dirname "$0")/../../../../"; pwd)
# echo "ROOT_DIR: $ROOT_DIR"

# Ensure the ROOT_DIR is set before proceeding
if [[ -z "$ROOT_DIR" ]]; then
    echo "Error: ROOT_DIR is empty"
    exit 1
fi

# Set the other paths using ROOT_DIR
SHELL_UTILS_PATH="${ROOT_DIR}/src/sh/shell_utils.sh"
# echo "SHELL_UTILS_PATH: $SHELL_UTILS_PATH"

# Check if shell_utils.sh exists
if [[ ! -f "$SHELL_UTILS_PATH" ]]; then
    echo "Error: shell_utils.sh not found at $SHELL_UTILS_PATH"
    exit 1
fi

# Source shell_utils.sh
source "${SHELL_UTILS_PATH}"

# Export variables
export ROOT_DIR SHELL_UTILS_PATH

# Ensure necessary functions are defined
if ! declare -f log_message >/dev/null; then
    echo "Error: log_message function not found after sourcing shell_utils.sh"
    exit 1
fi

# Detect operating system
OS_TYPE=$(uname -s)

#=======================================================================
# Cleanup Script
#=======================================================================

remove_zsh() {
    log_message "${DEBUG}" "# Removing zsh"
    if [[ "${OS_TYPE}" == "Darwin" ]]; then
        if command -v brew &>/dev/null && brew list zsh &>/dev/null; then
            log_message "${DEBUG_DETAILS}" "Uninstalling zsh via Homebrew..."
            brew uninstall --quiet zsh
        elif command -v zsh &>/dev/null && ! brew list zsh &>/dev/null; then
            log_message "${DEBUG_DETAILS}" "zsh is installed via system, not Homebrew. Attempting system removal."
        else
            log_message "${DEBUG_DETAILS}" "zsh is not installed."
        fi
    elif [[ "${OS_TYPE}" == "Linux" ]]; then
        log_message "${DEBUG_DETAILS}" "Uninstalling zsh via apt..."
        sudo apt remove -yqq zsh zsh-common zsh-doc
    else
        log_message "${DEBUG_DETAILS}" "Unsupported operating system: ${OS_TYPE}"
    fi
}

# Function to remove Oh My Zsh
remove_ohmyzsh() {
    log_message "${DEBUG}" "# Removing Oh My Zsh"
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        rm -rf "$HOME/.oh-my-zsh"
        log_message "${DEBUG_DETAILS}" "Removed Oh My Zsh."
    else
        log_message "${DEBUG_DETAILS}" "Oh My Zsh is not installed."
    fi
}

# Function to remove Zsh plugins
remove_ohmyzsh_plugins() {
    log_message "${DEBUG}" "# Removing Oh My Zsh plugins"
    local plugins=(
        "zsh-syntax-highlighting"
        "zsh-completions"
        "zsh-autosuggestions"
    )

    for plugin in "${plugins[@]}"; do
        local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin"
        if [[ -d "$plugin_dir" ]]; then
            rm -rf "$plugin_dir"
            log_message "${DEBUG_DETAILS}" "Removed plugin: $plugin"
        else
            log_message "${DEBUG_DETAILS}" "Plugin '$plugin' is not installed."
        fi
    done
}

# Function to remove Powerlevel10k
remove_powerlevel10k() {
    log_message "${DEBUG}" "# Removing Powerlevel10k theme"
    local theme_dir="$HOME/.oh-my-zsh/themes/powerlevel10k"
    if [[ -d "$theme_dir" ]]; then
        rm -rf "$theme_dir"
        log_message "${DEBUG_DETAILS}" "Removed Powerlevel10k theme."
    else
        log_message "${DEBUG_DETAILS}" "Powerlevel10k theme is not installed."
    fi

    # Reset ZSH_THEME in .zshrc
    if [[ -f "$HOME/.zshrc" ]]; then
        sed -i.bak 's/ZSH_THEME=".*"/ZSH_THEME="robbyrussell"/' "$HOME/.zshrc"
        log_message "${DEBUG_DETAILS}" "Reset ZSH_THEME in .zshrc to 'robbyrussell'."
    fi
}

# Cleanup .zshrc file
cleanup_zshrc() {
    log_message "${DEBUG}" "# Cleaning up .zshrc"
    if [[ -f "$HOME/.zshrc" ]]; then
        sed -i.bak '/zsh-syntax-highlighting/d' "$HOME/.zshrc"
        sed -i.bak '/zsh-autosuggestions/d' "$HOME/.zshrc"
        sed -i.bak '/zsh-completions/d' "$HOME/.zshrc"
        sed -i.bak '/autoload -U compinit/d' "$HOME/.zshrc"
        sed -i.bak '/compinit/d' "$HOME/.zshrc"
        log_message "${DEBUG_DETAILS}" "Removed plugin configurations from .zshrc."
    else
        log_message "${DEBUG_DETAILS}" ".zshrc not found."
    fi
}

#=======================================================================
# Main Cleanup Logic
#=======================================================================

remove_powerlevel10k
remove_ohmyzsh_plugins
remove_ohmyzsh
remove_zsh
cleanup_zshrc

log_message "${DEBUG}" "Cleanup completed."
