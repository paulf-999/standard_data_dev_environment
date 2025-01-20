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
    ROOT_DIR=$(cd "$(dirname "$0")/../.."; pwd)

    # verify ROOT_DIR exists
    if [[ -z "$ROOT_DIR" || ! -d "$ROOT_DIR" ]]; then
        echo "Error: ROOT_DIR is invalid or does not exist."
        exit 1
    fi

    # paths to commonly used directories
    IP_CONFIG_DIR="${ROOT_DIR}/config"
    TEMPLATES_DIR="${IP_CONFIG_DIR}/templates"
    SETUP_SCRIPTS_DIR="${ROOT_DIR}/src/sh/setup_scripts"

    # path the shell_utils.sh
    SHELL_UTILS_PATH="${ROOT_DIR}/src/sh/shell_utils.sh"

    # verify each of the commonly used directory vars exist
    for dir in "$IP_CONFIG_DIR" "$TEMPLATES_DIR" "$SETUP_SCRIPTS_DIR" "$SHELL_UTILS_PATH"; do
        if [[ ! -e "$dir" ]]; then
            echo "Error: Directory or file ${dir} does not exist."
            exit 1
        fi
    done

    # export these variables for use in other shell scripts used
    export ROOT_DIR IP_CONFIG_DIR TEMPLATES_DIR SETUP_SCRIPTS_DIR SHELL_UTILS_PATH

    # source the shell_utils.sh file
    source "${SHELL_UTILS_PATH}"
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
    pip3 install --disable-pip-version-check -r "${ROOT_DIR}/requirements.txt" -q || {
        print_error_message "Error: Failed to install Python packages from requirements.txt."
        exit 1
    }

    # Install j2cli for Jinja2 template rendering
    pip3 install --disable-pip-version-check j2cli -q || {
        print_error_message "Error: Failed to install j2cli."
        exit 1
    }

    # Verify j2 is installed
    if ! command -v j2 &>/dev/null; then
        print_error_message "Error: j2 command is not available after installation."
        exit 1
    fi

    log_message "${DEBUG_DETAILS}" "Python packages installed successfully & are visible on the PATH variable."
}


# Install Python and pip
setup_environment_variables() {
    print_section_header "${DEBUG}" "Step 3: Set up environment variables"
    bash ${SETUP_SCRIPTS_DIR}/setup_environment_variables.sh || {
        print_error_message "Error: Failed to set up environment variables."
        exit 1
    }
}

# Configure development tools
configure_dev_tools() {
    print_section_header "${DEBUG}" "Step 4: Configure development tools"

    # Install VSCode extensions
    log_message "${DEBUG}" "4.1. Install VSCode extensions"
    bash ${SETUP_SCRIPTS_DIR}/vscode/configure_vscode.sh || {
        print_error_message "Error: Failed to configure Visual Studio Code."
        exit 1
    }

    # Configure SQLFluff using jinja2 template
    log_message "${DEBUG}" "4.2. Configure SQLFluff"
    # To avoid any potential issue, we'll update the PATH for the current shell session
    export PATH="${PATH}:${LOCAL_BIN_PATH}:${PYTHON_BIN_PATH}"
    j2 ${TEMPLATES_DIR}/.sqlfluff_template.j2 -o ~/.sqlfluff || {
        print_error_message "Error: Failed to configure SQLFluff."
        exit 1
    }
}

#=======================================================================
# Main Script Logic
#=======================================================================

# Execute setup steps in sequence
export_directory_vars  # Set up common directory vars
install_unix_packages  # 1. Install system dependencies first
install_python_and_pip  # 2. Install Python and pip after system setup
install_python_packages  # 3. Install Python packages
configure_dev_tools  # 4. Configure dev tools after core setup

log_message "${INFO}" "Environment setup complete." && echo
