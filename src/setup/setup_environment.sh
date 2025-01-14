#!/bin/bash

# ignore shellcheck warning, re: non-constant source (for .bashrc)
# shellcheck disable=SC1090

#=======================================================================
# Script Name: setup_environment.sh
# Description: Sets up the standard data developer environment by
#              installing dependencies, configuring tools, and
#              preparing the environment for use.
#
# Author:       Paul Fry
# Date:         14th January 2025
#=======================================================================

#=======================================================================
# Variables
#=======================================================================

# Get the directory where the script is located
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Directory for installation dependencies
INSTALL_DEP_DIR="src/setup/install_dependencies"

# Source common shell script utilities using the dynamic path
source "${SCRIPT_DIR}/../scripts/sh/shell_utils.sh"
source "${INSTALL_DEP_DIR}/install_unix_packages.sh"

#=======================================================================
# Functions
#=======================================================================

# Function to install Python and pip
install_python_and_pip() {
    print_section_header "${DEBUG}" "Step 2: Instal Python and pip"

    # Check the OS type
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Check for apt-get (Ubuntu/Debian)
        if command -v apt-get &>/dev/null; then
            sudo apt-get update
            sudo apt-get install -y python3 python3-pip || {
                log_message "${ERROR}" "Failed to install Python or pip using apt-get."
                exit 1
            }
        # Check for yum (CentOS/Fedora)
        elif command -v yum &>/dev/null; then
            sudo yum install -y python3 python3-pip || {
                log_message "${ERROR}" "Failed to install Python or pip using yum."
                exit 1
            }
        # Check for dnf (Fedora)
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y python3 python3-pip || {
                log_message "${ERROR}" "Failed to install Python or pip using dnf."
                exit 1
            }
        else
            log_message "${ERROR}" "No suitable package manager found (apt-get, yum, or dnf)."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS: Check if Python 3 is already installed
        if command -v python3 &>/dev/null; then
            log_message "${DEBUG_DETAILS}" "Python3 is already installed on macOS - skipping installation."
        else
            # macOS uses Homebrew to install Python if not already installed
            brew install python || {
                log_message "${ERROR}" "Failed to install Python or pip using Homebrew."
                exit 1
            }
        fi

        # Check if pip3 is installed (for Python 3)
        if ! command -v pip3 &>/dev/null; then
            log_message "${DEBUG_DETAILS}" "pip3 not found, installing pip3."
            # Install pip3 for Python 3
            curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
            sudo python3 get-pip.py || {
                log_message "${ERROR}" "Failed to install pip3."
                exit 1
            }
            rm get-pip.py
        else
            log_message "${DEBUG_DETAILS}" "pip3 is already installed - skipping installation"
        fi
    else
        log_message "${ERROR}" "Unsupported OS detected for Python and pip installation."
        exit 1
    fi
}

# Function to install Python packages
install_python_packages() {
    print_section_header "${DEBUG}" "Step 3: Installing Python packages"

    # Install the Python packages listed within requirements.txt
    pip3 install --disable-pip-version-check -r ${INSTALL_DEP_DIR}/requirements.txt -q || {
        print_error_message "Error: Failed to install Python packages."
        exit 1
    }
}

# Function to configure development tools
configure_dev_tools() {
    print_section_header "${DEBUG}" "Step 4: Configuring development tools"
    bash configure_tools/configure_vscode.sh  # Configure Visual Studio Code
    bash configure_tools/configure_airflow.sh  # Configure Airflow
}

# Function to set up environment variables
setup_environment_variables() {
    print_section_header "${DEBUG}" "Step 5: Setting up environment variables"

    # Add environment variables to shell configuration
    sh src/sh/common/add_env_vars_to_shell_header.sh

    # Reload shell configuration
    source ~/.bashrc

    # Add local bin to PATH for global access
    export PATH="${PATH}:${HOME}/.local/bin"
}

# Function to configure SQLFluff
configure_sqlfluff() {
    print_section_header "${DEBUG}" "Step 6: Configuring SQLFluff"

    # Generate SQLFluff configuration from template
    j2 templates/.sqlfluff_template.j2 -o ~/.sqlfluff || {
        print_error_message "Error: Failed to configure SQLFluff."
        exit 1
    }
}

# Function to install ZSH and ohmyzsh
install_zsh_and_ohmyzsh() {
    print_section_header "${DEBUG}" "Step 7: Installing ZSH and ohmyzsh"

    # Run ZSH/ohmyzsh installation script
    bash src/scripts/sh/ohmyzsh/install_zsh_and_ohmyzsh.sh || {
        print_error_message "Error: Failed to install ZSH and ohmyzsh."
        exit 1
    }
}

#=======================================================================
# Main Script Logic
#=======================================================================

# Execute setup steps in sequence
# install_unix_packages           # Install system dependencies first
install_python_and_pip            # Install Python and pip after system setup
# install_python_packages           # Install Python packages next
# setup_environment_variables       # Set environment variables after core software installation
# configure_dev_tools               # Configure development tools after Python packages
# configure_sqlfluff                # Configure SQLFluff after dev tools
# install_zsh_and_ohmyzsh           # Install ZSH and ohmyzsh as the last step

log_message "${INFO}" "Environment setup completed successfully." && echo
