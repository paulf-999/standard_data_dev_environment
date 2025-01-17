#!/bin/bash

#=======================================================================
# Variables
#=======================================================================

# Source shell_utils.sh relative to this script
source "${SHELL_UTILS_PATH}"

# The path to add to the PATH variable
LOCAL_BIN_PATH="$HOME/.local/bin"

#=======================================================================
# Helper Functions
#=======================================================================

# Function to ensure the PATH modification is added to the shell profile
ensure_path_in_profile() {
    local shell_profile_file="$1"
    if [ -f "$shell_profile_file" ]; then
        if ! grep -q "$LOCAL_BIN_PATH" "$shell_profile_file"; then
            echo "export PATH=\$PATH:$LOCAL_BIN_PATH" >> "$shell_profile_file"
        fi
    else
        echo "export PATH=\$PATH:$LOCAL_BIN_PATH" > "$shell_profile_file"
    fi
}

# Function to handle Zsh setup
setup_zsh() {
    log_message "${DEBUG_DETAILS}" "Setting up environment variables in Zsh."

    # Check or create .zshrc
    [ ! -f ~/.zshrc ] && touch ~/.zshrc

    # Append template and ensure PATH modification
    ensure_path_in_profile ~/.zshrc

    # Reload .zshrc if running in Zsh
    if [ -n "$ZSH_VERSION" ]; then
        source ~/.zshrc
    else
        echo "Warning: Zsh configuration (.zshrc) was modified but not reloaded because the current shell is Bash."
    fi
}

# Function to handle Bash setup
setup_bash() {
    log_message "${DEBUG_DETAILS}" "Setting up environment variables in Bash."

    # Check or create .bash_profile or .bashrc
    if [ ! -f ~/.bash_profile ] && [ ! -f ~/.bashrc ]; then
        echo "Neither .bash_profile nor .bashrc exist. Creating .bash_profile."
        touch ~/.bash_profile
    fi

    # Use .bash_profile if it exists, otherwise use .bashrc
    if [ -f ~/.bash_profile ]; then
        shell_profile_file=~/.bash_profile
    else
        shell_profile_file=~/.bashrc
    fi

    # Append template and ensure PATH modification
    ensure_path_in_profile "$shell_profile_file"

    # Reload shell profile
    source "$shell_profile_file"
}

# Function to set up environment variables
setup_environment_variables() {

    # Determine the current shell and set up accordingly
    if [ -n "$ZSH_VERSION" ]; then
        setup_zsh
    elif [ "$BASH" ]; then
        setup_bash
    else
        log_message "${ERROR}" "Unsupported shell. Neither Zsh nor Bash detected."
        exit 1
    fi

    # Always update PATH for the current shell session
    export PATH="${PATH}:${LOCAL_BIN_PATH}"
}

#=======================================================================
# Main Script Execution
#=======================================================================

setup_environment_variables
