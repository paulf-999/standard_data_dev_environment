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
configure_dev_tools  # Install Python packages
