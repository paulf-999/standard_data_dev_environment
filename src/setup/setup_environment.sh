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
# Functions
#=======================================================================

# Function to export directory paths
export_directory_vars() {
    # Compute the root setup directory
    ROOT_SETUP_DIR=$(cd "$(dirname "$0")/../.."; pwd)

    # Ensure the ROOT_SETUP_DIR is set before proceeding
    if [[ -z "$ROOT_SETUP_DIR" ]]; then
        echo "Error: ROOT_SETUP_DIR is empty"
        exit 1
    fi

    # Set the other paths using ROOT_SETUP_DIR
    SHELL_UTILS_PATH="${ROOT_SETUP_DIR}/src/scripts/sh/shell_utils.sh"
    INSTALL_DEP_DIR="${ROOT_SETUP_DIR}/src/setup/install_dependencies"
    SETUP_SCRIPTS_DIR="${ROOT_SETUP_DIR}/src/setup/setup_scripts"
    CONFIGURE_TOOLS_DIR="${ROOT_SETUP_DIR}/src/setup/configure_tools"
    TEMPLATES_DIR="${ROOT_SETUP_DIR}/src/setup/templates"
    source "${SHELL_UTILS_PATH}"

    # Export variables
    export ROOT_SETUP_DIR
    export SHELL_UTILS_PATH
    export INSTALL_DEP_DIR
    export SETUP_SCRIPTS_DIR
    export CONFIGURE_TOOLS_DIR
    export TEMPLATES_DIR

    # Print the exported variables for debugging
    # echo "ROOT_SETUP_DIR = ${ROOT_SETUP_DIR}"
    # echo "SHELL_UTILS_PATH = ${SHELL_UTILS_PATH}"
    # echo "SETUP_SCRIPTS_DIR = ${SETUP_SCRIPTS_DIR}"
    # echo "INSTALL_DEP_DIR = ${INSTALL_DEP_DIR}"
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
    log_message "${DEBUG}" "1. Install VSCode extensions"
    bash ${CONFIGURE_TOOLS_DIR}/vscode/configure_vscode.sh || {
        print_error_message "Error: Failed to configure Visual Studio Code."
        exit 1
    }

    # Configure SQLFluff
    log_message "${DEBUG}" "2. Configure SQLFluff"
    j2 ${TEMPLATES_DIR}/.sqlfluff_template.j2 -o ~/.sqlfluff || {
        print_error_message "Error: Failed to configure SQLFluff."
        exit 1
    }

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

export_directory_vars  # set up common

# install_unix_packages  # 1. Install system dependencies first
install_python_and_pip  # 2. Install Python and pip after system setup
install_python_packages  # 3. Install Python packages next
# setup_environment_variables  # 4. Set environment variables after core software installation
configure_dev_tools  # 5. Configure SQLFluff after dev tools

log_message "${INFO}" "Environment setup complete." && echo
