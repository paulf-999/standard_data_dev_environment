#!/bin/bash

#=======================================================================
# Variables
#=======================================================================

# Source shell_utils.sh relative to this script
source "${SHELL_UTILS_PATH}"

# Path to the shell profile header template
SHELL_PROFILE_HEADER_TEMPLATE="${TEMPLATES_DIR}/shell_profile_header.txt"

#=======================================================================
# Helper Functions
#=======================================================================

# Function to append the template to the shell profile (Zsh or Bash)
append_template_to_shell_profile() {
    local shell_profile_file="$1"
    cat "$SHELL_PROFILE_HEADER_TEMPLATE" | cat - "$shell_profile_file" > temp && mv temp "$shell_profile_file"
}

# Function to handle Zsh setup
setup_zsh() {
    log_message "${DEBUG_DETAILS}" "Setting up env vars in Zsh."
    # Check if .zshrc exists, create it if not
    if [ ! -f ~/.zshrc ]; then
        echo "Creating .zshrc as it does not exist"
        touch ~/.zshrc
    fi
    append_template_to_shell_profile ~/.zshrc

    # Check if PATH modification is already in .zshrc
    if ! grep -q "$HOME/.local/bin" ~/.zshrc; then
        echo "export PATH=\$PATH:\$HOME/.local/bin" >> ~/.zshrc
        log_message "${DEBUG_DETAILS}" "Added \$HOME/.local/bin to PATH in .zshrc"
    fi

    # Reload .zshrc only if running in Zsh
    if [ -n "$ZSH_VERSION" ]; then
        source ~/.zshrc
    else
        echo "Warning: Zsh configuration (.zshrc) was modified but not reloaded because the current shell is Bash."
    fi
}

# Function to handle Bash setup
setup_bash() {
    log_message "${DEBUG_DETAILS}" "Setting up env vars in Bash."
    # Check if either .bash_profile or .bashrc exists
    if [ ! -f ~/.bash_profile ] && [ ! -f ~/.bashrc ]; then
        echo "Neither .bash_profile nor .bashrc exist. Creating .bash_profile"
        touch ~/.bash_profile
    fi

    # Append template to the appropriate file (prefer .bash_profile if it exists)
    if [ -f ~/.bash_profile ]; then
        append_template_to_shell_profile ~/.bash_profile
        . ~/.bash_profile
    elif [ -f ~/.bashrc ]; then
        append_template_to_shell_profile ~/.bashrc
        . ~/.bashrc
    fi
}

# Function to set up environment variables
setup_environment_variables() {

    # a. Check if the shell_profile_header.txt file exists
    if [ ! -f "$SHELL_PROFILE_HEADER_TEMPLATE" ]; then
        log_message "${ERROR}" "Template file $SHELL_PROFILE_HEADER_TEMPLATE not found!"
        exit 1
    fi

    # b. Check for Zsh or Bash shell
    if [ -n "$ZSH_VERSION" ]; then
        setup_zsh
    elif [ "$BASH" ]; then
        setup_bash
    else
        log_message "${ERROR}" "Unsupported shell. Neither Zsh nor Bash detected."
        exit 1
    fi

    # Add local bin to PATH for global access
    export PATH="${PATH}:${HOME}/.local/bin"
}

#=======================================================================
# Main Script Execution
#=======================================================================

setup_environment_variables
