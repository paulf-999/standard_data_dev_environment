#!/bin/bash

#=======================================================================
# Variables
#=======================================================================

# Source shell_utils.sh relative to this script
source src/sh/shell_utils.sh

# The path to add to the PATH variable
LOCAL_BIN_PATH="$HOME/.local/bin"
PYTHON_BIN_PATH="$HOME/Library/Python/3.9/bin"  # Path for user-installed Python packages

#=======================================================================
# Helper Functions
#=======================================================================

# Function to ensure the PATH modification is added to the shell profile
ensure_path_in_profile() {
    local shell_profile_file="$1"

    if [ -f "$shell_profile_file" ]; then
        # log_message "${DEBUG_DETAILS}" "$shell_profile_file found. Ensuring PATH modifications..."

        if ! grep -q "$LOCAL_BIN_PATH" "$shell_profile_file"; then
            # Adding $LOCAL_BIN_PATH to $shell_profile_file
            echo "export PATH=\$PATH:$LOCAL_BIN_PATH" >> "$shell_profile_file"
        fi

        if ! grep -q "$PYTHON_BIN_PATH" "$shell_profile_file"; then
            # Adding $PYTHON_BIN_PATH to $shell_profile_file
            echo "export PATH=\$PATH:$PYTHON_BIN_PATH" >> "$shell_profile_file"
        fi
    else
        echo "$shell_profile_file not found. Creating and adding PATH modifications..."
        echo "export PATH=\$PATH:$LOCAL_BIN_PATH" > "$shell_profile_file"
        echo "export PATH=\$PATH:$PYTHON_BIN_PATH" >> "$shell_profile_file"
    fi
}

# Function to handle Zsh setup (if Zsh is installed)
setup_zsh() {
    if command -v zsh &> /dev/null; then

        log_message "${DEBUG_DETAILS}" "Zsh found! Setting up environment variables in Zsh."

        # Check or create .zshrc
        if [ ! -f ~/.zshrc ]; then
            log_message "${DEBUG_DETAILS}" "Creating .zshrc file in home directory."
            touch ~/.zshrc
        fi

        # Append template and ensure PATH modification
        ensure_path_in_profile ~/.zshrc

        # Reload .zshrc if running in Zsh
        if [ -n "$ZSH_VERSION" ]; then
            log_message "${DEBUG_DETAILS}" "Reloading .zshrc for Zsh session..."
            source ~/.zshrc
        else
            log_message "${DEBUG_DETAILS}" "Not in Zsh shell. Starting a new Zsh shell to reload .zshrc."
            exec zsh -c "source ~/.zshrc; exec zsh"
        fi
    else
        echo "Zsh is not installed. Skipping Zsh setup."
    fi
}

# Function to handle Bash setup
setup_bash() {

    log_message "${DEBUG_DETAILS}" "Bash found! Setting up environment variables in Bash."

    # Check or create .bash_profile or .bashrc
    if [ ! -f ~/.bash_profile ] && [ ! -f ~/.bashrc ]; then
        log_message "${DEBUG_DETAILS}" "Neither .bash_profile nor .bashrc exists. Creating .bash_profile."
        touch ~/.bash_profile
    fi

    # Use .bash_profile if it exists, otherwise use .bashrc
    if [ -f ~/.bash_profile ]; then
        # log_message "${DEBUG_DETAILS}" "Using .bash_profile for Bash configuration."
        shell_profile_file=~/.bash_profile
    else
        # log_message "${DEBUG_DETAILS}" "Using .bashrc for Bash configuration."
        shell_profile_file=~/.bashrc
    fi

    # Append template and ensure PATH modification
    ensure_path_in_profile "$shell_profile_file"

    # Reload shell profile
    # log_message "${DEBUG_DETAILS}" "Reloading Bash profile..."
    source "$shell_profile_file"
}

#=======================================================================
# Main Script Execution
#=======================================================================

# Set up environment variables for both Zsh and Bash
setup_zsh
setup_bash

# Always update PATH for the current shell session
export PATH="${PATH}:${LOCAL_BIN_PATH}:${PYTHON_BIN_PATH}"

#=======================================================================
# Troubleshooting Step
#=======================================================================

# Check PATH Modifications:
# Ensure that ~/.zshrc, ~/.bash_profile, or equivalent shell configuration files have been updated with the correct paths.
# Run the following command to confirm the paths are included:
# echo $PATH
