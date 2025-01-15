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

# Source common shell script utilities
source "${SCRIPT_DIR}/../scripts/sh/shell_utils.sh"

SETUP_SCRIPTS_DIR="src/setup/setup_scripts"
CONFIGURE_TOOLS_DIR="src/setup/configure_tools"
#=======================================================================
# Functions
#=======================================================================

# Install Unix packages
install_unix_packages() {
    print_section_header "${DEBUG}" "Step 1: Install Unix packages"
    bash ${SETUP_SCRIPTS_DIR}/install_unix_packages.sh || {
        print_error_message "Error: Failed to install Unix packages."
        exit 1
    }
}

# Install Python and pip
install_python_and_pip() {
    print_section_header "${DEBUG}" "Step 2: Install Python and pip"
    bash ${SETUP_SCRIPTS_DIR}/install_python_and_pip.sh || {
        print_error_message "Error: Failed to install Python and pip."
        exit 1
    }
}

# Install Python packages
install_python_packages() {
    print_section_header "${DEBUG}" "Step 3: Install Python packages"
    pip3 install --disable-pip-version-check -r src/setup/install_dependencies/requirements.txt -q || {
        print_error_message "Error: Failed to install Python packages."
        exit 1
    }
    log_message "${DEBUG_DETAILS}" "Python packages installed."
}

# Set up environment variables
setup_environment_variables() {
    print_section_header "${DEBUG}" "Step 4: Set up environment variables"
    bash ${SETUP_SCRIPTS_DIR}/set_up_environment_variables.sh || {
        print_error_message "Error: Failed to set up environment variables."
        exit 1
    }
}


# Configure development tools
configure_dev_tools() {
    print_section_header "${DEBUG}" "Step 5: Configure development tools"

    # Install VSCode extensions
    log_message "${DEBUG}" "Step 5: Install VSCode extensions"
    bash ${CONFIGURE_TOOLS_DIR}/vscode/configure_vscode.sh || {
        print_error_message "Error: Failed to configure Visual Studio Code."
        exit 1
    }

    # Configure SQLFluff
    # log_message "${DEBUG}" "Configure SQLFluff"
    # j2 templates/.sqlfluff_template.j2 -o ~/.sqlfluff || {
    #     print_error_message "Error: Failed to configure SQLFluff."
    #     exit 1
    # }

    # # Configure OhMyZsh
    # log_message "${DEBUG}" "Install ZSH and Oh My Zsh"
    # bash ${CONFIGURE_TOOLS_DIR}/configure_ohmyzsh.sh || {
    #     print_error_message "Error: Failed to install ZSH and Oh My Zsh."
    #     exit 1
    # }
}

#=======================================================================
# Main Script Logic
#=======================================================================

# Execute setup steps in sequence

# install_unix_packages  # 1. Install system dependencies first
install_python_and_pip  # 2. Install Python and pip after system setup
install_python_packages  # 3. Install Python packages next
# setup_environment_variables  # 4. Set environment variables after core software installation
configure_dev_tools  # 5. Configure SQLFluff after dev tools

log_message "${INFO}" "Environment setup complete." && echo
