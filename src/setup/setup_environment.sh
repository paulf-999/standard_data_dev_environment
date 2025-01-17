#!/bin/bash

#=======================================================================
# Script Name: setup_environment.sh
# Description: Sets up the standard data developer environment by
#              installing dependencies, configuring tools, setting up
#              environment variables, and verifying library installations.
#
# Author:       Paul Fry
# Date:         14th January 2025
#=======================================================================

#=======================================================================
# Functions
#=======================================================================

# Function to export directory paths
export_directory_vars() {
    ROOT_SETUP_DIR=$(cd "$(dirname "$0")/../.."; pwd)

    if [[ -z "$ROOT_SETUP_DIR" || ! -d "$ROOT_SETUP_DIR" ]]; then
        echo "Error: ROOT_SETUP_DIR is invalid or does not exist."
        exit 1
    fi

    SHELL_UTILS_PATH="${ROOT_SETUP_DIR}/src/scripts/sh/shell_utils.sh"
    INSTALL_DEP_DIR="${ROOT_SETUP_DIR}/src/setup/install_dependencies"
    SETUP_SCRIPTS_DIR="${ROOT_SETUP_DIR}/src/setup/setup_scripts"
    CONFIGURE_TOOLS_DIR="${ROOT_SETUP_DIR}/src/setup/configure_tools"
    TEMPLATES_DIR="${ROOT_SETUP_DIR}/src/setup/templates"

    for dir in "$SHELL_UTILS_PATH" "$INSTALL_DEP_DIR" "$SETUP_SCRIPTS_DIR" "$CONFIGURE_TOOLS_DIR" "$TEMPLATES_DIR"; do
        if [[ ! -e "$dir" ]]; then
            echo "Error: Directory or file ${dir} does not exist."
            exit 1
        fi
    done

    source "${SHELL_UTILS_PATH}"
    export ROOT_SETUP_DIR SHELL_UTILS_PATH INSTALL_DEP_DIR SETUP_SCRIPTS_DIR CONFIGURE_TOOLS_DIR TEMPLATES_DIR

    # Source set_up_environment_variables.sh
    source "${SETUP_SCRIPTS_DIR}/setup_environment_variables.sh"
}

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

# Function to check and install required Python packages
install_python_packages() {
    print_section_header "${DEBUG}" "Step 3: Install Python packages"

    # Install Python packages from requirements.txt
    pip3 install --disable-pip-version-check -r "${INSTALL_DEP_DIR}/requirements.txt" -q || {
        print_error_message "Error: Failed to install Python packages."
        exit 1
    }

    log_message "${DEBUG_DETAILS}" "Python packages installed."
}

# Configure development tools
configure_dev_tools() {
    print_section_header "${DEBUG}" "Step 4: Configure development tools"

    # Install VSCode extensions
    log_message "${DEBUG}" "4.1. Install VSCode extensions"
    bash ${CONFIGURE_TOOLS_DIR}/vscode/configure_vscode.sh || {
        print_error_message "Error: Failed to configure Visual Studio Code."
        exit 1
    }

    # Configure OhMyZsh
    log_message "${DEBUG}" "4.2. Install ZSH and Oh My Zsh"
    bash ${CONFIGURE_TOOLS_DIR}/ohmyzsh/configure_ohmyzsh.sh || {
        print_error_message "Error: Failed to install ZSH and Oh My Zsh."
        exit 1
    }

    # Configure SQLFluff using jinja2 template
    log_message "${DEBUG}" "4.3. Configure SQLFluff"
    j2 ${TEMPLATES_DIR}/.sqlfluff_template.j2 -o ~/.sqlfluff || {
        print_error_message "Error: Failed to configure SQLFluff."
        exit 1
    }
}

#=======================================================================
# Main Script Logic
#=======================================================================

# Prerequisite: Add Python user binary path to PATH, e.g.: /Users/paulfry/Library/Python/3.9/bin
# To find this path, run $(python3 -m site --user-base)/bin

# Execute setup steps in sequence
export_directory_vars  # Set up common directory vars
install_unix_packages  # 1. Install system dependencies first
install_python_and_pip  # 2. Install Python and pip after system setup
add_python_user_bin_to_path  # Add Python user bin to PATH
install_python_packages  # 3. Install Python packages
setup_environment_variables  # 4. Set environment variables after core software installation
configure_dev_tools  # 5. Configure dev tools after core setup

log_message "${INFO}" "Environment setup complete." && echo
