#!/bin/bash

# Inputs
ROOT_DIR=$(pwd)

# Source shell_utils.sh relative to this script
source "${ROOT_DIR}/src/sh/shell_utils.sh"

#=======================================================================
# Helper Functions
#=======================================================================

# Function to check and install required Python packages
install_python_packages() {

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

    log_message "${DEBUG_DETAILS}" "Python packages installed successfully & are visible on the PATH variable.\n"
}

#=======================================================================
# Main Script Logic
#=======================================================================

install_python_packages
